import 'package:rangking_cabang_olahraga/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authC = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${authC.userRole.value.toUpperCase()}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authC.logout(),
          ),
        ],
      ),
      body: Text("Under Development"),
    );
  }
}
