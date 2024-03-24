// ignore_for_file: deprecated_member_use

import 'package:course_udemy_expense_tracker_app/widgets/settings_page/appbar.dart';
import 'package:course_udemy_expense_tracker_app/widgets/settings_page/settings_forms.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const AppBarSettings(),
      body: const SettingsForms(),
    );
  }
}
