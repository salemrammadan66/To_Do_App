import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppToastType { success, error }

void showAppSnackBar(
  OverlayState overlay,
  String message, {
  AppToastType type = AppToastType.success,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _AppToast(
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      onDismissed: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _AppToast extends StatefulWidget {
  final String message;
  final AppToastType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismissed;

  const _AppToast({
    required this.message,
    required this.type,
    required this.onDismissed,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<_AppToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissed || !mounted) return;
    _dismissed = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.type == AppToastType.error;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + MediaQuery.of(context).padding.bottom,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade600 : AppColors.checkedTaskColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (widget.actionLabel != null && widget.onAction != null)
                  TextButton(
                    onPressed: () async {
                      _dismissed = true;
                      await _controller.reverse();
                      widget.onDismissed();
                      widget.onAction!();
                    },
                    child: Text(
                      widget.actionLabel!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
