import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:speednode/core/resources/extention_sized.dart';
import 'package:speednode/controller/foreground_controller.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/controller/splash_controller.dart';
import 'package:speednode/controller/stop_watch_controller.dart';
import 'package:speednode/gen/assets.gen.dart';
import 'package:speednode/core/resources/app_colors.dart';
import 'package:speednode/screens/splash_screen.dart';
import 'package:speednode/core/services/windows_local_notif.dart';
import 'package:speednode/core/widgets/app_bar.dart';
import 'package:speednode/core/widgets/connect_button.dart';
import 'package:speednode/core/widgets/custom_snack_bar.dart';
import 'package:speednode/core/widgets/dns_status.dart';
import 'package:speednode/core/widgets/flutter_toast.dart';
import 'package:speednode/core/widgets/status_bar.dart';
import 'package:speednode/core/widgets/world_map.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final SpeednodeEngineController speednodeEngineController = Get.find();
  final StopWatchController stopWatchController = Get.find();
  final ForegroundController foregroundController = Get.find();
  final SplashScreenController splashController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "SpeedNode",
        fontFamily: 'Calistoga',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                side: const WidgetStatePropertyAll(BorderSide.none),
                backgroundColor: WidgetStatePropertyAll(
                  AppColors.iconAppBar,
                ),
              ),
              child: SvgPicture.asset(Assets.svg.crown),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const WorldMap(),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  splashController.isOffline.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Switch Back To ",
                              style: TextStyle(
                                color: AppColors.offlineStatusText,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            6.width,
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 20, 255, 118),
                                    width: 2),
                                backgroundColor:
                                    Colors.black.withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (Platform.isWindows) {
                                  WindowsLocalNotif(
                                    body: "Starting in Online Mode",
                                    title: "SpeedNode Service",
                                  ).showNotification();
                                } else if (Platform.isAndroid) {
                                  FlutterToast(
                                          message: "Starting in Online Mode")
                                      .flutterToast();
                                }

                                splashController.online.remove('offline');
                                splashController.getDnsListOnline();
                                Get.offAll(() => SplashScreen());
                              },
                              child: const Text(
                                "Online Mode",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 20, 255, 118),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Text(
                    stopWatchController
                        .formatDuration(stopWatchController.elapsedTime.value),
                    style: TextStyle(
                      fontFamily: 'IRANSansX',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.timer,
                    ),
                  ),
                  ConnectButton(),
                  const DNSStatus(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Platform.isAndroid
                          ? StatusIcon(
                              path: Assets.svg.download,
                              label: 'Download',
                              status: foregroundController.download.value,
                              color: AppColors.download,
                              iconColor: const Color(0xFF38AC72),
                              onTap: () {},
                            )
                          : StatusIcon(
                              path: Assets.svg.flush,
                              label: 'Flush DNS',
                              status: speednodeEngineController.isFlushing.value
                                  ? "Flushed Succesfully"
                                  : "Tap To Flush",
                              color: AppColors.download,
                              onTap: () {
                                if (speednodeEngineController.isActive.value) {
                                  CustomSnackBar(
                                    title: "Operation Failed",
                                    message:
                                        "Failed to FLUSH DNS, please stop the service first",
                                    backColor: Colors.red.shade700
                                        .withValues(alpha: 0.9),
                                    iconColor: Colors.white,
                                    icon: Icons.error_outline,
                                    textColor: Colors.white,
                                  ).customSnackBar();
                                } else {
                                  speednodeEngineController.flushDnsForWindows();
                                  CustomSnackBar(
                                    title: "Operation Success",
                                    message: "FLUSHED DNS Succesfully",
                                    backColor:
                                        const Color.fromARGB(80, 105, 240, 175),
                                    iconColor: Colors.greenAccent,
                                    icon: Icons.check_circle_outline_outlined,
                                    textColor: Colors.white,
                                  ).customSnackBar();
                                }
                              },
                              iconColor: const Color(0xFF38AC72),
                            ),
                      StatusIcon(
                        path: Assets.svg.global,
                        label: 'Address',
                        status: speednodeEngineController.isIpAddress.value
                            ? "IP: Getting IP..."
                            : "IP: ${speednodeEngineController.ipAddressString}",
                        color: AppColors.ip,
                        onTap: () => speednodeEngineController.getIpAddress(),
                        iconColor: const Color(0xFF428BC1),
                      ),
                      Platform.isAndroid
                          ? StatusIcon(
                              path: Assets.svg.upload,
                              label: 'Upload',
                              status: foregroundController.upload.value,
                              color: AppColors.upload,
                              iconColor: const Color(0xFFD2222D),
                              onTap: () {},
                            )
                          : StatusIcon(
                              path: Assets.svg.interface,
                              label: 'Interface',
                              status:
                                  "${speednodeEngineController.interfaceName.value} ⏷",
                              color: AppColors.upload,
                              onTap: () {
                                if (speednodeEngineController.isActive.value) {
                                  CustomSnackBar(
                                    title: "Operation Failed",
                                    message:
                                        "Failed to Select INTERFACE, please stop the service first",
                                    backColor: Colors.red.shade700
                                        .withValues(alpha: 0.9),
                                    iconColor: Colors.white,
                                    icon: Icons.error_outline,
                                    textColor: Colors.white,
                                  ).customSnackBar();
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: AppColors.background,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        title: Center(
                                          child: Text(
                                            "Select an Interface",
                                            style: TextStyle(
                                              color: AppColors.interfaceClose,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        content: SizedBox(
                                          height: 250,
                                          width: 300,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      speednodeEngineController
                                                          .interfaceKeys.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                        speednodeEngineController
                                                                .interfaceKeys[
                                                            index],
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .interfaceName,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        speednodeEngineController
                                                                .interfaceName
                                                                .value =
                                                            speednodeEngineController
                                                                    .interfaceKeys[
                                                                index];
                                                        speednodeEngineController
                                                            .saveInterfaceName();
                                                        log("Interface changed to ${speednodeEngineController.interfaceName.value}");
                                                        Navigator.pop(context);
                                                      },
                                                      leading:
                                                          speednodeEngineController
                                                                          .interfaceValues[
                                                                      index] ==
                                                                  'Connected'
                                                              ? const Icon(
                                                                  Icons
                                                                      .wifi_password_sharp,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          72,
                                                                          190,
                                                                          133),
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .wifi_off_outlined,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      hoverColor: AppColors
                                                          .interfaceHover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(
                                              overlayColor:
                                                  WidgetStatePropertyAll(
                                                AppColors.interfaceCloseHover,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "Close",
                                              style: TextStyle(
                                                color: AppColors.interfaceClose,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              iconColor: const Color(0xFFD2222D),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
