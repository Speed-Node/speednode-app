import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speednode/controller/speednode_engine_controller.dart';
import 'package:speednode/screens/dns_page.dart';
import 'package:speednode/screens/dns_ping.dart';
import 'package:speednode/screens/home_page.dart';
import 'package:speednode/screens/settings_page.dart';

class MainWrapperController extends GetxController {
  final speednodeEngineController =
      Get.find<SpeednodeEngineController>();
  final List<Widget> _pages = [
    HomePage(),
    DNSPage(),
    DNSPing(),
    SettingsPage(),
  ];
  @override
  void onInit() {
    super.onInit();
    speednodeEngineController.getIpAddress();
  }
  var selectedIndex = 0.obs;

  void onSelectPage(int index) {
    selectedIndex.value = index;
  }

  Widget get selectedPage => _pages[selectedIndex.value];
}
