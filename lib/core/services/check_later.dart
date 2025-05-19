// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:speednode/controller/speednode_engine_controller.dart';
// import 'package:speednode/controller/stop_watch_controller.dart';
// import 'package:speednode/gen/assets.gen.dart';
// import 'package:speednode/services/windows_local_notif.dart';
// import 'package:tray_manager/tray_manager.dart';
// import 'package:window_manager/window_manager.dart';

// final SpeednodeEngineController speednodeEngineController = Get.find();
// final StopWatchController stopWatchController = Get.find();
// Future<void> initializeTray() async {
//   await TrayManager.instance.setIcon(Assets.png.tray);
//   Menu menu = Menu(
//     items: [
//       MenuItem.checkbox(
//         checked: speednodeEngineController.isActive.value,
//         label:
//             speednodeEngineController.isActive.value ? "Disconnect" : "Connect",
//         key: 'connectButton',
//       ),
//       MenuItem.submenu(
//         label: "DNS List",
//         submenu: Menu(
//           items: [
//             for (var item in speednodeEngineController.combinedListDns)
//               MenuItem.checkbox(
//                 key: 'dnsList',
//                 checked: speednodeEngineController.selectedDns.value == item,
//                 label: item.name,
//               )
//           ],
//         ),
//       ),
//       MenuItem.separator(),
//       MenuItem(
//         key: 'show',
//         label: 'Show App',
//       ),
//       MenuItem(
//         key: 'exit',
//         label: 'Exit',
//       ),
//     ],
//   );
//   await TrayManager.instance.setContextMenu(menu);
//   TrayManager.instance.addListener(TrayManagerService());
//   log("Tray initialized successfully.");
//   await TrayManager.instance.setToolTip('SpeedNode');
// }

// class TrayManagerService implements TrayListener {
//   @override
//   void onTrayIconMouseDown() {
//     windowManager.show();
//   }

//   @override
//   void onTrayIconMouseUp() {}

//   @override
//   void onTrayIconRightMouseDown() {
//     TrayManager.instance.popUpContextMenu();
//   }

//   @override
//   void onTrayIconRightMouseUp() {}

//   @override
//   void onTrayMenuItemClick(MenuItem menuItem) {
//     log("Menu item clicked: ${menuItem.key}");
//     if (menuItem.key == 'connectButton') {
//       if (speednodeEngineController.isActive.value) {
//         speednodeEngineController.stopDnsForWindows();
//         stopWatchController.stopWatchTime();
//         initializeTray();
//         WindowsLocalNotif(
//           body:
//               "SpeedNode has disconnected from the ${speednodeEngineController.selectedDns.value.name}.",
//           title: "Service Stopped",
//         ).showNotification();
//       } else {
//         speednodeEngineController.startDnsForWindows();
//         stopWatchController.startWatchTime();
//         initializeTray();
//         WindowsLocalNotif(
//           body:
//               "SpeedNode has successfully connected to the ${speednodeEngineController.selectedDns.value.name}.",
//           title: "Service Started",
//         ).showNotification();
//       }
//       log("Your connection button state is : ${speednodeEngineController.isActive.value.toString()}");
//     } else if (menuItem.key == 'dnsList') {
//       var selectedDns = speednodeEngineController.combinedListDns
//           .firstWhereOrNull((dns) => dns.name == menuItem.label);

//       if (selectedDns != null) {
//         speednodeEngineController.selectedDns.value = selectedDns;
//         speednodeEngineController.saveSelectedDnsValue();
//         log("Selected DNS: ${speednodeEngineController.selectedDns.value.name}");
//         initializeTray();
//       }
//     } else if (menuItem.key == 'show') {
//       windowManager.show();
//     } else if (menuItem.key == 'exit') {
//       TrayManager.instance.destroy();
//       windowManager.close();
//     }
//   }

//   void onTrayIconMouseDoubleClick() {
//     log("Tray icon double-clicked.");
//     windowManager.isVisible().then((isVisible) {
//       if (isVisible) {
//         windowManager.hide();
//       } else {
//         windowManager.show();
//       }
//     });
//   }

//   void onTrayIconRightMouseDoubleClick() {}
// }
