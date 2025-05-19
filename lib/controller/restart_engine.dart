import 'dart:developer';

import 'package:get/get.dart';
import 'package:speednode/controller/foreground_controller.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/controller/single_dns_ping_controller.dart';
import 'package:speednode/controller/stop_watch_controller.dart';
import 'package:speednode/core/services/windows_local_notif.dart';
import 'package:speednode/core/widgets/flutter_toast.dart';

class RestartEngine extends GetxController {
    final dnsPingController = Get.find<SingleDnsPingController>();
        final SpeednodeEngineController speednodeEngineController = Get.find();
  final StopWatchController stopWatchController = Get.find();
  final ForegroundController foregroundController = Get.find();

  void restartEngineAndroid() async {
    log('Ananas1');

    await speednodeEngineController.stopDnsForAndroid();
    await foregroundController.stopService();
    stopWatchController.stopWatchTime();

    await speednodeEngineController.startDnsForAndroid();
    await foregroundController
        .startService(speednodeEngineController.selectedDns.value.name);
    stopWatchController.startWatchTime();

    FlutterToast(message: "Service Restarted Successfully").flutterToast();
  }

  void startEngineAndroid() {
    speednodeEngineController.startDnsForAndroid();
    foregroundController
        .startService(speednodeEngineController.selectedDns.value.name);
    stopWatchController.startWatchTime();
    speednodeEngineController.isActive.value = true;
    FlutterToast(message: "Service Started Successfully").flutterToast();
  }

  void restartEngineWindows() async {
    await speednodeEngineController.stopDnsForWindows();
    stopWatchController.stopWatchTime();
    await speednodeEngineController.startDnsForWindows();
    stopWatchController.startWatchTime();
    WindowsLocalNotif(body: "Service Restarted Successfully", title: "SpeedNode");
  }

  void startEngineWindows() {
    speednodeEngineController.startDnsForWindows();
    stopWatchController.startWatchTime();
    WindowsLocalNotif(body: "Service Started Successfully", title: "SpeedNode");
  }
}
