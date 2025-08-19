import 'package:restaurant/app/controllers/auth_controller.dart';
import 'package:restaurant/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find<AuthController>();

    final userRole = authC.userRole.value;
    final bottomNavItem = userRole.toLowerCase() == "owner"
        ? [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
          ]
        : [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
          ];

    final pages =
        controller.pageConfig[userRole] ?? controller.pageConfig["customer"]!;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Welcome ${authC.userRole.value.toUpperCase()}')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authC.logout(),
          ),
        ],
      ),
      body: pages[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItem,
        currentIndex: controller.selectedIndex.value,
        onTap: (index) {
          controller.selectedIndex.value = index;
          print("✅ BottomNav tapped -> index: $index");
        },
      ),
    );
  }
}
