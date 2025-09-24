import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authscreen/loginscreen.dart';
import '../screens/setting/googlecredential/googlecredentialscreen.dart';
import '../screens/setting/netsuitecredential/netsuitecredential.dart';
import '../screens/setting/uploadopenapikey/uploadopenapikey.dart';

class AdminController extends GetxController {
  var selectedIndex = 0.obs; // main menu index
  var selectedSubmenu = "".obs; // selected submenu
  var isSidebarOpen = true.obs;
  var expandedMenu = <String>[].obs;

  // Main menus
  final List<String> menuItems = ["Dashboard", "Settings", "Reports"];
  final List<IconData> menuIcons = [
    Icons.dashboard,
    Icons.settings,
    Icons.bar_chart
  ];

  // Settings submenu
  final List<String> settingsSubmenu = ["Netsuite Credential", "Google Credential","Upload Open API"];
  final Map<String, IconData> submenuIcons = {
    "Netsuite Credential": Icons.person,
    "Google Credential": Icons.lock,
    "Upload Open API" : Icons.key
  };
  final Map<String, Widget> settingsSubmenuPages = {
    "Netsuite Credential": Netsuitecredential(),
    "Google Credential": Googlecredentialscreen(),
    "Upload Open API" : Uploadopenapikeyscreen()
  };

  // Reports submenu
  final List<String> reportsSubmenu = ["Sales", "Analytics"];
  final Map<String, IconData> reportsSubmenuIcons = {
    "Sales": Icons.show_chart,
    "Analytics": Icons.analytics,
  };
  final Map<String, Widget> reportsSubmenuPages = {
    "Sales": Center(child: Text("Sales Report Page", style: TextStyle(fontSize: 22))),
    "Analytics": Center(child: Text("Analytics Report Page", style: TextStyle(fontSize: 22))),
  };

  Rx<Widget> currentSubmenuPage = Rx<Widget>(Container());
  RxString currentSubmenuTitle = "".obs;

  /// Click main menu
  void changePage(int index) {
    selectedIndex.value = index;
    selectedSubmenu.value = ""; // clear submenu highlight
    currentSubmenuPage.value = Container();
    currentSubmenuTitle.value = "";
  }

  /// Click submenu
  void openSubmenuPage(String submenu) {
    selectedSubmenu.value = submenu;

    if (settingsSubmenuPages.containsKey(submenu)) {
      currentSubmenuPage.value = settingsSubmenuPages[submenu]!;
      selectedIndex.value = menuItems.indexOf("Settings");
    } else if (reportsSubmenuPages.containsKey(submenu)) {
      currentSubmenuPage.value = reportsSubmenuPages[submenu]!;
      selectedIndex.value = menuItems.indexOf("Reports");
    }

    currentSubmenuTitle.value = submenu;
  }

  /// Toggle sidebar open/close
  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  /// Toggle arrow submenu open/close
  void toggleSubmenu(String menu) {
    if (expandedMenu.contains(menu)) {
      expandedMenu.remove(menu); // collapse
    } else {
      expandedMenu.add(menu); // expand
    }
  }

  bool isExpanded(String menu) => expandedMenu.contains(menu);


    /// Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all saved data

    // Navigate to login screen and remove all previous routes
    Get.offAll(() => Loginscreen());
  }
}

