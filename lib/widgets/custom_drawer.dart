import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/styles/app_style.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Color? isActive(String? currentRoute, String to) {
    return currentRoute == to ? AppColors.activeMenuColor : null;
  }

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: ListView(
        children: [
          Consumer<AppProvider>(builder: (context, appState, child) {
            return ListTile(
              title: Text(
                'Bem vindo, ${appState.state.userName.text}',
                style: AppFonts.drawerTitle,
              ),
            );
          }),
          itemMenu(
            title: "Inicio",
            backgroundColor: isActive(currentRoute, '/home'),
            icon: const Icon(Icons.home_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          itemMenu(
            title: "Configurar escala",
            backgroundColor: isActive(currentRoute, '/escala'),
            icon: const Icon(Icons.calendar_month_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/escala');
            },
          ),
          itemMenu(
              title: "Radar",
              icon: const Icon(Icons.radar_outlined),
              enabled: false),
        ],
      ),
    );
  }

  Widget itemMenu(
      {required String title,
      Icon? icon,
      void Function()? onTap,
      Color? backgroundColor,
      bool enabled = true,
      String? currentRoute}) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: backgroundColor,
      ),
      child: ListTile(
          leading: icon,
          enabled: enabled,
          title: Text(title, style: AppFonts.menuTile),
          onTap: onTap),
    );
  }
}
