package com.example.speednode

import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.content.Context
import android.net.VpnService
import android.os.Binder
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.util.Log
import android.service.quicksettings.Tile

class SpeedNodeService : VpnService() {

    private var vpnInterface: ParcelFileDescriptor? = null
    private val binder = LocalBinder()
    private var statusListener: ((String) -> Unit)? = null 

    companion object {
        const val ACTION_START_DNS = "ACTION_START_DNS"
        const val ACTION_STOP_DNS = "ACTION_STOP_DNS"
        var isRunning = false
    }

    private var dnsServers: List<String> = listOf("78.157.42.100", "78.157.42.101")

    inner class LocalBinder : Binder() {
        fun getService(): SpeedNodeService = this@SpeedNodeService
    }

    override fun onBind(intent: Intent?): IBinder {
        return binder
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            
            ACTION_START_DNS -> {
            val disallowedApps = intent.getStringArrayListExtra("disallowedApps") ?: listOf()
            startDns(disallowedApps)
            }
            ACTION_STOP_DNS -> {
                Log.d("SpeedNodeService", "Stopping DNS")
                stopDns()
            }
        }
        return START_STICKY
    }

    fun setDnsServers(dnsList: List<String>) {
        dnsServers = dnsList
        Log.d("SpeedNodeService", "DNS servers updated: $dnsServers")
    }

    
    fun setStatusListener(listener: (String) -> Unit) {
        statusListener = listener
    }
    
    private fun updateStatus(status: String) {
        statusListener?.invoke(status)
    }

    fun startDns(disallowedApps: List<String>) {
        if (!isRunning) {
            val builder = Builder()
            builder.setSession("SpeedNodeDNS")
                .addAddress("10.0.0.2", 24)
    
        if (dnsServers.isNotEmpty()) {
            builder.addDnsServer(dnsServers[0])
            Log.d("SpeedNodeService", "Primary DNS set: ${dnsServers[0]}")
        }

        if (dnsServers.size > 1) {
            builder.addDnsServer(dnsServers[1])
            Log.d("SpeedNodeService", "Secondary DNS set: ${dnsServers[1]}")
        }
    
            for (app in disallowedApps) {
                try {
                    builder.addDisallowedApplication(app)
                    Log.d("SpeedNodeService", "SpeedNode started with disallowed app: $app")
                } catch (e: Exception) {
                    Log.e("SpeedNodeService", "Error adding disallowed application: $app, ${e.message}")
                }
            }
    
            vpnInterface?.close()
            vpnInterface = builder.establish()
            isRunning = true
            updateStatus("VPN_STARTED")
            Log.d("SpeedNodeService", "SpeedNode started with DNS: $dnsServers")
        }
    }
    

    fun stopDns() {
        vpnInterface?.close()
        vpnInterface = null
        isRunning = false
        updateStatus("DNS_STOPPED") 
        
        Log.d("SpeedNodeService", "DNS disconnected")
    }


    override fun onDestroy() {
        stopDns()
        super.onDestroy()
    }

}
