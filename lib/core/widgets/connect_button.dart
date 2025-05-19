import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:speednode/core/resources/media_query_size.dart';
import 'package:speednode/controller/foreground_controller.dart';
import 'package:speednode/controller/glow_controller.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/controller/stop_watch_controller.dart';
import 'package:speednode/core/resources/app_colors.dart';
import 'package:speednode/core/services/windows_local_notif.dart';
import 'package:speednode/core/widgets/custom_snack_bar.dart';
import 'package:speednode/core/widgets/flutter_toast.dart';

class ConnectButton extends StatelessWidget {
  ConnectButton({super.key});
  final SpeednodeEngineController speednodeEngineController =
      Get.put(SpeednodeEngineController());
  final ForegroundController foregroundController =
      Get.put(ForegroundController());
  final StopWatchController stopWatchController =
      Get.put(StopWatchController());
  final GlowController glowController = Get.put(GlowController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool isOn = speednodeEngineController.isActive.value;
        bool isLoading = speednodeEngineController.isLoading.value;
        bool isPermissionGranted =
            speednodeEngineController.isPermissionGiven.value;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  if (Platform.isAndroid && !isPermissionGranted) {
                    speednodeEngineController.prepareDns();
                    return;
                  }
                  if (Platform.isWindows &&
                      speednodeEngineController.interfaceName.value
                          .contains('Select Interface')) {
                    CustomSnackBar(
                      title: "Operation Failed",
                      message:
                          "Failed to START SERVICE, please select an interface",
                      backColor: Colors.red.shade700.withValues(alpha: 0.9),
                      iconColor: Colors.white,
                      icon: Icons.error_outline,
                      textColor: Colors.white,
                    ).customSnackBar();
                    return;
                  }
                  if (Platform.isAndroid && isPermissionGranted && isOn) {
                    // FOR ANDROID
                    speednodeEngineController.stopDnsForAndroid();
                    foregroundController.stopService();
                    stopWatchController.stopWatchTime();
                    FlutterToast(message: "Service Stopped Successfully")
                        .flutterToast();
                  } else if (Platform.isAndroid &&
                      isPermissionGranted &&
                      !isOn) {
                    // FOR ANDROID
                    speednodeEngineController.startDnsForAndroid();
                    foregroundController.startService(
                        speednodeEngineController.selectedDns.value.name);
                    stopWatchController.startWatchTime();
                    FlutterToast(message: "Service Started Successfully")
                        .flutterToast();
                  } else if (Platform.isAndroid) {
                    log("Premission not granted!");
                  } else if (Platform.isWindows && isOn) {
                    // FOR WINDOWS
                    speednodeEngineController.stopDnsForWindows();
                    stopWatchController.stopWatchTime();
                    WindowsLocalNotif(
                      body:
                          "SpeedNode has disconnected from the ${speednodeEngineController.selectedDns.value.name}.",
                      title: "Service Stopped",
                    ).showNotification();
                  } else if (Platform.isWindows && !isOn) {
                    // FOR WINDOWS
                    speednodeEngineController.startDnsForWindows();
                    stopWatchController.startWatchTime();
                    WindowsLocalNotif(
                      body:
                          "SpeedNode has successfully connected to the ${speednodeEngineController.selectedDns.value.name}.",
                      title: "Service Started",
                    ).showNotification();
                  }
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height:
                ScreenSize.height * 0.25 > 200 ? 220 : ScreenSize.height * 0.27,
            width: ScreenSize.width * 0.4 > 200 ? 200 : ScreenSize.width * 0.55,
            decoration: BoxDecoration(
              color:
                  isOn ? AppColors.connectButtonOn : AppColors.connectButtonOff,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isOn
                      ? AppColors.connectButtonOnShadow
                      : AppColors.connectButtonOffShadow,
                  blurRadius: isOn ? glowController.glowValue.value : 16,
                  spreadRadius: isOn ? glowController.glowValue.value / 2 : 6,
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: isLoading
                  ? SpinKitWave(
                      key: const ValueKey("loading"),
                      color: AppColors.spinKit,
                      size: 40,
                    )
                  : Icon(
                      Icons.power_settings_new_outlined,
                      key: const ValueKey("icon"),
                      size: 120,
                      color: AppColors.powerIcon,
                    ),
            ),
          ),
        );
      },
    );
  }
}
