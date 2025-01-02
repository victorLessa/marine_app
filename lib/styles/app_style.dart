import 'package:flutter/material.dart';

class AppColors {
  static get primaryColor => const Color(0xFF5454FF);
  static get secondaryColor => const Color(0xFF8B9CFF);
  static get thirtyColor => const Color(0xFF54C0FF);
  static get thirtyColor30 => const Color.fromARGB(113, 84, 192, 255);
  static get preBoardingMeeting => Colors.orange;
  static get embarked => const Color.fromARGB(255, 214, 0, 0);
  static get desembarkationDay => const Color.fromARGB(255, 122, 208, 255);
  static get selectedColor => const Color(0xFF8B9CFF);
  static get todayColor => AppColors.thirtyColor;
  static get activeMenuColor => AppColors.thirtyColor30;
}

class AppFonts {
  static get menuTile =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static get drawerTitle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static get titleIntro => const TextStyle(
      fontSize: 24, color: Color(0xFF8B9CFF), fontWeight: FontWeight.bold);
  static get subtitleIntro =>
      const TextStyle(fontSize: 16, color: Color(0xFF55396B));
}
