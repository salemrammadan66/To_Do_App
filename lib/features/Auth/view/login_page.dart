import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/auth_provider.dart';
import 'Cutomized_Widgets/login_page_text_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> frmKey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            //image
            child: Image.asset(fit: BoxFit.fill, "assets/images/study2.jpg"),
          ),

          Container(
            // gradient
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withValues(alpha: 1), Colors.transparent],
              ),
            ),
          ),

          BackdropFilter(
            // blur
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withValues(alpha: 0)),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: frmKey,
                    child: Column(
                      children: [
                        // Email
                        LoginPageTextfields(
                          hintText: "Email",
                          controller: emailcontroller,
                        ),

                        const SizedBox(height: 15),

                        // Password
                        LoginPageTextfields(
                          hintText: "Password",
                          isPassword: true,
                          controller: passcontroller,
                        ),

                        const SizedBox(height: 25),

                        // Login Button
                        Consumer<AuthProvider>(
                          builder: (context, prov, child) {
                            if (prov.isLoading) {
                              return CircularProgressIndicator(
                                color: AppColors.floatingBtnColor,
                              );
                            }
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (frmKey.currentState!.validate()) {
                                        await prov.login(
                                          emailcontroller.text,
                                          passcontroller.text,
                                        );
                                        if (prov.error == null) {
                                          if (!context.mounted) return;
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "home",
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.floatingBtnColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                if (prov.error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      prov.error!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Password Change
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
