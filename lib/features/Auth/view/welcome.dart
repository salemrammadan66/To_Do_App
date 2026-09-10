import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_buttons.dart';
import 'Cutomized_Widgets/info_for_welcome.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            //image
            child: Image.asset(fit: BoxFit.fill, "assets/images/study.jpg"),
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
          InfoForWelcome(),

          // Buttons at bottom
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: "Register",
                    onPressed: () {
                      Navigator.pushNamed(context, "register");
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: AppPrimaryButton(
                    text: "Log In",
                    onPressed: () {
                      Navigator.pushNamed(context, "login");
                    },
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
