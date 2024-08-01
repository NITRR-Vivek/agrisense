import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../notification_screen/notification_screen.dart';
import '../qrscanner_screen.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: AppBar(
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text('Agri Sense', style: TextStyle(color: AppColors.darkAppColor300, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.darkAppColor300),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScannerScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.darkAppColor300),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
