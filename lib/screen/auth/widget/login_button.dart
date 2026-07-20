import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/auth_controller.dart';

class LoginButton extends StatelessWidget {
  final AuthController authCtr;
  final TextEditingController emailCtr;
  final TextEditingController passwordCtr;

  const LoginButton({
    super.key,
    required this.authCtr,
    required this.emailCtr,
    required this.passwordCtr,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003B6D),
            foregroundColor: Colors.white,
          ),
          onPressed: authCtr.loading.value
              ? null
              : () {
                  authCtr.login(
                    email: emailCtr.text.trim(),
                    password: passwordCtr.text.trim(),
                  );
                },
          child: authCtr.loading.value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  "Sign In to Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
