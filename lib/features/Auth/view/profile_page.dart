import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/services/local_avatar_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../tasks/viewmodel/prov.dart';
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
  String? photoPath;

  @override
  void initState() {
    super.initState();
    LocalAvatarStorage.getSavedPath().then((path) {
      if (mounted) setState(() => photoPath = path);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.bottomSheetBacgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.fontColor),
                title: Text(
                  "Choose from gallery",
                  style: TextStyle(color: AppColors.fontColor),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.fontColor),
                title: Text(
                  "Take a photo",
                  style: TextStyle(color: AppColors.fontColor),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final path = await LocalAvatarStorage.pickAndSave(source: source);
    if (path != null && mounted) {
      setState(() => photoPath = path);
    }
  }

  Widget _fieldLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }

  Widget _statItem({
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.floatingBtnColor, size: 26),
        const SizedBox(height: 6),
        Text(
          "$count",
          style: TextStyle(
            color: AppColors.fontColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final taskProvider = context.watch<TaskProvider>();

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

    final allTasks =
        taskProvider.pendingTasks.length + taskProvider.completedTasks.length;
    final done = taskProvider.completedTasks.length;
    final pending = taskProvider.pendingTasks.length;

    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      body: authProvider.isLoading && authProvider.user == null
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.floatingBtnColor,
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.bottomSheetBacgroundColor,
                        image: photoPath != null
                            ? DecorationImage(
                          image: FileImage(File(photoPath!)),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: photoPath == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickPhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.floatingBtnColor,
                            border: Border.all(
                              color: AppColors.bodyColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  authProvider.user?.name ?? "",
                  style: TextStyle(
                    color: AppColors.fontColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Center(
                child: Text(
                  "To-Do App User",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.bottomSheetBacgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem(
                      icon: Icons.check_circle_outline,
                      count: allTasks,
                      label: "All Tasks",
                    ),
                    _statItem(
                      icon: Icons.check_circle_outline,
                      count: done,
                      label: "Done",
                    ),
                    _statItem(
                      icon: Icons.pending_actions_outlined,
                      count: pending,
                      label: "Pending",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "Personal Information",
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _fieldLabel("Name"),
              const SizedBox(height: 6),
              AppTextField(
                controller: nameController,
                borderRadius: 12,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel("Email"),
              const SizedBox(height: 6),
              AppTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                borderRadius: 12,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel("New password"),
              const SizedBox(height: 6),
              AppTextField(
                controller: passwordController,
                isPassword: true,
                borderRadius: 12,
                hintText: "Leave empty to keep current password",
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
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
              const SizedBox(height: 28),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}