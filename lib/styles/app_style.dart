import 'package:flutter/material.dart';

class AppColors {
  static get preBoardingMeeting => Colors.orange;
  static get embarked => const Color.fromARGB(255, 214, 0, 0);
  static get desembarkationDay => const Color.fromARGB(255, 122, 208, 255);
  static get selectedColor => const Color.fromARGB(255, 123, 148, 164);
  static get todayColor => const Color.fromARGB(255, 18, 148, 242);
  static get activeMenuColor => const Color.fromARGB(255, 204, 230, 248);
}

class AppFonts {
  static get menuTile =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static get drawerTitle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}
