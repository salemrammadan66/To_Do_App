import 'dart:io';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class LocalAvatarStorage {
  static const _boxName = 'settingsBox';
  static const _key = 'profile_photo_path';

  static Future<String?> getSavedPath() async {
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    final path = box.get(_key) as String?;
    if (path != null && await File(path).exists()) {
      return path;
    }
    return null;
  }

  static Future<String?> pickAndSave({required ImageSource source}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final savedPath = '${dir.path}/profile_photo.jpg';

    final savedFile = await File(picked.path).copy(savedPath);

    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    await box.put(_key, savedFile.path);

    return savedFile.path;
  }
}