import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodel/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loadedOnce = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _fieldLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    if (!_loadedOnce) {
      _loadedOnce = true;
      Future.microtask(() async {
        final authProvider = context.read<AuthProvider>();
        await authProvider.fetchProfile();
        final user = authProvider.user;
        if (user != null) {
          nameController.text = user.name;
          emailController.text = user.email;
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: AppBar(
        backgroundColor: AppColors.bodyColor,
        iconTheme: IconThemeData(color: AppColors.fontColor),
        title: Text("Profile", style: TextStyle(color: AppColors.fontColor)),
      ),
      body: authProvider.isLoading && authProvider.user == null
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.floatingBtnColor,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel("Name"),
            const SizedBox(height: 6),
            AppTextField(
              controller: nameController,
              borderRadius: 12,
            ),
            const SizedBox(height: 16),
            _fieldLabel("Email"),
            const SizedBox(height: 6),
            AppTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              borderRadius: 12,
            ),
            const SizedBox(height: 16),
            _fieldLabel("New password"),
            const SizedBox(height: 6),
            AppTextField(
              controller: passwordController,
              isPassword: true,
              borderRadius: 12,
              hintText: "Leave empty to keep current password",
            ),
            if (authProvider.error != null) ...[
              const SizedBox(height: 12),
              Text(
                authProvider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 24),
            AppPrimaryButton(
              text: "Save changes",
              isLoading: authProvider.isLoading,
              backgroundColor: AppColors.saveBtnColor,
              height: 48,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final provider = context.read<AuthProvider>();

                final success = await provider.updateProfile(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );

                if (!context.mounted) return;

                passwordController.clear();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? "Profile updated"
                          : (provider.error ?? "Something went wrong"),
                    ),
                    backgroundColor: success
                        ? AppColors.checkedTaskColor
                        : Colors.red,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: AppTextActionButton(
                text: "Log out",
                color: Colors.red,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  navigator.pushNamedAndRemoveUntil(
                    "welcome",
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}