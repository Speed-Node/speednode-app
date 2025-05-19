import 'package:get/get.dart';
import 'package:speednode/controller/blocked_apps_controller.dart';
import 'package:speednode/controller/check_for_update_controller.dart';
import 'package:speednode/controller/foreground_controller.dart';
import 'package:speednode/controller/glow_controller.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/controller/splash_controller.dart';
import 'package:speednode/controller/stop_watch_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => SpeednodeEngineController());
    Get.lazyPut(() => CheckForUpdateController());
    Get.lazyPut(() => ForegroundController());
    Get.lazyPut(() => StopWatchController());
    Get.lazyPut(() => GlowController());
    Get.lazyPut(() => BlockedAppsController());
  }
}

