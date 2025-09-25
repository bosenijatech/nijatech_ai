import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/app_color.dart';
import '../../controller/admin_controller.dart';
import '../dashboardscreen/dashboardscreen.dart';

class Adminscreen extends StatelessWidget {
  Adminscreen({super.key});

  final AdminController controller = Get.put(AdminController());

  /// Factory method to create fresh page instances
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return Center(
          child: Text("Settings Page", style: TextStyle(fontSize: 22)),
        );
      case 2:
        return Center(
          child: Text("Reports Page", style: TextStyle(fontSize: 22)),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// Sidebar
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controller.isSidebarOpen.value ? 200 : 60,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar Top
                  SizedBox(
                    height: 80,
                    child: controller.isSidebarOpen.value
                        ? Center(
                            // child: Text(
                            //   "Admin Panel",
                            //   style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            child: Image.asset('assets/images/nijalogo.png'),
                          )
                        : const Center(
                            child: Icon(
                              Icons.admin_panel_settings,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                  ),

                  // Menu items
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(controller.menuItems.length, (
                          index,
                        ) {
                          String menu = controller.menuItems[index];
                          bool mainSelected =
                              controller.selectedIndex.value == index &&
                              controller.selectedSubmenu.value.isEmpty;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main menu
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: () {
                                    if (menu == "Settings" ||
                                        menu == "Reports") {
                                      controller.toggleSubmenu(menu);
                                    } else {
                                      controller.changePage(index);
                                    }
                                  },
                                  child: Container(
                                    color: mainSelected
                                        ? Colors.blueAccent.withOpacity(0.3)
                                        : Colors.transparent,
                                    padding: controller.isSidebarOpen.value
                                        ? const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 20,
                                          )
                                        : const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 0,
                                          ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          controller.menuIcons[index],
                                          color: mainSelected
                                              ? AppColor.primary
                                              : Colors.grey,
                                        ),
                                        if (controller.isSidebarOpen.value) ...[
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              menu,
                                              style: TextStyle(
                                                color: mainSelected
                                                    ? AppColor.primary
                                                    : Colors.black,
                                                fontWeight: mainSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (menu == "Settings" ||
                                              menu == "Reports")
                                            Icon(
                                              controller.isExpanded(menu)
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: Colors.grey,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Settings Submenu
                              if (menu == "Settings" &&
                                  controller.isExpanded(menu))
                                Column(
                                  children: controller.settingsSubmenu.map((
                                    sub,
                                  ) {
                                    return Obx(() {
                                      bool isSelected =
                                          controller.selectedSubmenu.value ==
                                          sub;
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: InkWell(
                                          onTap: () =>
                                              controller.openSubmenuPage(sub),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20,
                                            ),
                                            color: isSelected
                                                ? Colors.blueAccent.withOpacity(
                                                    0.3,
                                                  )
                                                : Colors.transparent,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  controller.submenuIcons[sub],
                                                  size: 18,
                                                  color: isSelected
                                                      ? AppColor.primary
                                                      : Colors.grey[700],
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  sub,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isSelected
                                                        ? AppColor.primary
                                                        : Colors.black,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  }).toList(),
                                ),

                              // Reports Submenu
                              if (menu == "Reports" &&
                                  controller.isExpanded(menu))
                                Column(
                                  children: controller.reportsSubmenu.map((
                                    sub,
                                  ) {
                                    return Obx(() {
                                      bool isSelected =
                                          controller.selectedSubmenu.value ==
                                          sub;
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: InkWell(
                                          onTap: () =>
                                              controller.openSubmenuPage(sub),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20,
                                            ),
                                            color: isSelected
                                                ? Colors.blueAccent.withOpacity(
                                                    0.3,
                                                  )
                                                : Colors.transparent,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  controller
                                                      .reportsSubmenuIcons[sub],
                                                  size: 18,
                                                  color: isSelected
                                                      ? AppColor.primary
                                                      : Colors.grey[700],
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  sub,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isSelected
                                                        ? AppColor.primary
                                                        : Colors.black,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  }).toList(),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  // Logout button fixed at bottom
                  InkWell(
                    onTap: () => controller.logout(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      color: Colors.redAccent.withOpacity(0.1),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.redAccent),
                          if (controller.isSidebarOpen.value) ...[
                            const SizedBox(width: 10),
                            const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Main Content Area
          Expanded(
            child: Column(
              children: [
                // Topbar
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Page title
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.selectedSubmenu.value.isNotEmpty
                                ? controller.currentSubmenuTitle.value
                                : controller.menuItems[controller
                                      .selectedIndex
                                      .value],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Search Field
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search...",
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Profile avatar
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: Obx(
                    () => controller.selectedSubmenu.value.isNotEmpty
                        ? controller.currentSubmenuPage.value
                        : getPage(controller.selectedIndex.value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
