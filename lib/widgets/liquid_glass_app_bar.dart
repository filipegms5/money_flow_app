import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;
  final bool? centerTitle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final Color? backgroundColor;

  const LiquidGlassAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.automaticallyImplyLeading,
    this.centerTitle,
    this.leading,
    this.bottom,
    this.toolbarHeight,
    this.backgroundColor,
  }) : assert(
          title == null || titleText == null,
          'Cannot provide both title and titleText',
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ??
          (titleText != null
              ? Text(
                  titleText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      centerTitle: centerTitle,
      leading: leading,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: backgroundColor ?? Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? kToolbarHeight,
      );
}

