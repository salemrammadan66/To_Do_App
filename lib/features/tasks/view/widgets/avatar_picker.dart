import 'package:flutter/material.dart';

import '../../../../core/widgets/cute_avatars.dart';

class AvatarPicker extends StatelessWidget {
  final int selectedId;
  final ValueChanged<int> onSelected;

  const AvatarPicker({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kCuteAvatars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final avatar = kCuteAvatars[index];
          return GestureDetector(
            onTap: () => onSelected(avatar.id),
            child: CuteAvatar(
              data: avatar,
              size: 52,
              selected: avatar.id == selectedId,
            ),
          );
        },
      ),
    );
  }
}