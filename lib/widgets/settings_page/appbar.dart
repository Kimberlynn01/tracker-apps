import 'package:flutter/material.dart';

class AppBarSettings extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSettings({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text(
        'Settings',
        style: TextStyle(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
    );
  }
}
