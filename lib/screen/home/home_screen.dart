import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';
import 'package:selling_project/screen/home/widget/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: DrawerWidget(),
      body: const Center(
        child: Text("Home Screen"),
      ),
    );
  }
}