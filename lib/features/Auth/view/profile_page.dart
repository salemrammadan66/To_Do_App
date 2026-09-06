import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
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

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: AppColors.toDoCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.appBarColor,
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
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(),
            ),
            const SizedBox(height: 16),
            _fieldLabel("Email"),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(),
            ),
            const SizedBox(height: 16),
            _fieldLabel("New password"),
            const SizedBox(height: 6),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(
                hint: "Leave empty to keep current password",
              ),
            ),
            if (authProvider.error != null) ...[
              const SizedBox(height: 12),
              Text(
                authProvider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saveBtnColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
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
                            : (provider.error ??
                            "Something went wrong"),
                      ),
                      backgroundColor: success
                          ? AppColors.checkedTaskColor
                          : Colors.red,
                    ),
                  );
                },
                child: authProvider.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
                    : const Text(
                  "Save changes",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}