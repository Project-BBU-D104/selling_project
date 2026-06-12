import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final ctr = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Login Screen'),
            ElevatedButton(onPressed: () {
              ctr.onLoginPressed();
            }, child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}