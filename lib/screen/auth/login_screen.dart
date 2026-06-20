// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:selling_project/controller/login_controller.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final ctr = Get.put(LoginController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Text('Login Screen'),
//             ElevatedButton(onPressed: () {
//               ctr.onLoginPressed();
//             }, child: const Text('Login'))
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authCtr =
      Get.put(AuthController());

  final TextEditingController usernameCtr =
      TextEditingController();

  final TextEditingController passwordCtr =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.store,
                        size: 80,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Computer Shop",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Login to continue",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: usernameCtr,
                        decoration:
                            const InputDecoration(
                          labelText: "Username",
                          prefixIcon:
                              Icon(Icons.person),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: passwordCtr,
                        obscureText: true,
                        decoration:
                            const InputDecoration(
                          labelText: "Password",
                          prefixIcon:
                              Icon(Icons.lock),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                authCtr.loading.value
                                    ? null
                                    : () {
                                        authCtr.login(
                                          username:
                                              usernameCtr
                                                  .text
                                                  .trim(),
                                          password:
                                              passwordCtr
                                                  .text
                                                  .trim(),
                                        );
                                      },
                            child:
                                authCtr.loading.value
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "LOGIN",
                                      ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          // Go Register Screen
                        },
                        child: const Text(
                          "Create Account",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}