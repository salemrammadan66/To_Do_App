import 'package:flutter/material.dart';

class CuteAvatarData {
  final int id;
  final String assetPath;

  const CuteAvatarData({
    required this.id,
    required this.assetPath,
  });
}

const String _basePath = 'assets/cute_avatars';

/// كتالوج كل الأشكال المتاحة للاختيار
const List<CuteAvatarData> kCuteAvatars = [
  CuteAvatarData(id: 0, assetPath: '$_basePath/bat.png'),
  CuteAvatarData(id: 1, assetPath: '$_basePath/bear.png'),
  CuteAvatarData(id: 2, assetPath: '$_basePath/bee.png'),
  CuteAvatarData(id: 3, assetPath: '$_basePath/butterfly.png'),
  CuteAvatarData(id: 4, assetPath: '$_basePath/cat.png'),
  CuteAvatarData(id: 5, assetPath: '$_basePath/cool.png'),
  CuteAvatarData(id: 6, assetPath: '$_basePath/crow.png'),
  CuteAvatarData(id: 7, assetPath: '$_basePath/dinosaur.png'),
  CuteAvatarData(id: 8, assetPath: '$_basePath/dog.png'),
  CuteAvatarData(id: 9, assetPath: '$_basePath/dragon.png'),
  CuteAvatarData(id: 10, assetPath: '$_basePath/elephant.png'),
  CuteAvatarData(id: 11, assetPath: '$_basePath/frog.png'),
  CuteAvatarData(id: 12, assetPath: '$_basePath/hippopotamus.png'),
  CuteAvatarData(id: 13, assetPath: '$_basePath/kitty.png'),
  CuteAvatarData(id: 14, assetPath: '$_basePath/koala.png'),
  CuteAvatarData(id: 15, assetPath: '$_basePath/monkey.png'),
  CuteAvatarData(id: 16, assetPath: '$_basePath/owl.png'),
  CuteAvatarData(id: 17, assetPath: '$_basePath/panda.png'),
  CuteAvatarData(id: 18, assetPath: '$_basePath/penguin.png'),
  CuteAvatarData(id: 19, assetPath: '$_basePath/rat.png'),
  CuteAvatarData(id: 20, assetPath: '$_basePath/smiling.png'),
  CuteAvatarData(id: 21, assetPath: '$_basePath/snail.png'),
  CuteAvatarData(id: 22, assetPath: '$_basePath/starfish.png'),
  CuteAvatarData(id: 23, assetPath: '$_basePath/stingray.png'),
  CuteAvatarData(id: 24, assetPath: '$_basePath/teddy-bear.png'),
  CuteAvatarData(id: 25, assetPath: '$_basePath/whale.png'),
  CuteAvatarData(id: 26, assetPath: '$_basePath/kitty2.png'),
];

CuteAvatarData avatarById(int id) =>
    kCuteAvatars.firstWhere((a) => a.id == id, orElse: () => kCuteAvatars.first);

class CuteAvatar extends StatelessWidget {
  final CuteAvatarData data;
  final double size;
  final bool selected;

  const CuteAvatar({
    super.key,
    required this.data,
    this.size = 48,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: selected
            ? Border.all(color: Colors.orangeAccent, width: 2)
            : null,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Image.asset(data.assetPath, fit: BoxFit.contain),
    );
  }
}