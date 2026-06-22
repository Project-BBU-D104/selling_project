import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/auth_controller.dart';
import 'widget/login_header.dart';
import 'widget/email_field.dart';
import 'widget/password_field.dart';
import 'widget/login_button.dart';
import 'widget/status_badge.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final authCtr = Get.put(AuthController());

  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const LoginHeader(),
                const SizedBox(height: 35),
                EmailField(controller: emailCtr),
                const SizedBox(height: 20),
                PasswordField(controller: passwordCtr),
                const SizedBox(height: 30),
                LoginButton(
                  authCtr: authCtr,
                  emailCtr: emailCtr,
                  passwordCtr: passwordCtr,
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: "New to HardwarePro? ",
                      ),
                      TextSpan(
                        text: "Create Account",
                        style: TextStyle(
                          color: Color(0xFF003B6D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const StatusBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
