import 'package:flutter/material.dart';

class CustomAppBar {
  AppBar showAppBar({Widget? title, Widget? leading, List<Widget>? actions}) {
    return AppBar(
      backgroundColor: const Color(0xffffffff),
      shadowColor: const Color(0xffffffff),
      surfaceTintColor: const Color(0xffffffff),
      elevation: 0,
      title: title,
      leading: leading,
      actions: actions,
    );
  }
}
