import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  // Hard-coded notifications
  final List<String> notifications = [
    'The weather forecast predicts rain tomorrow. Prepare your fields accordingly.',
    'New message from Agronomist Patel regarding crop rotation advice.',
    'Soil test results for your recent samples are now available.',
    'Your order of organic fertilizers has been shipped and will arrive soon.',
    'Reminder: It’s time to apply pesticides for your tomato crop.',
    'The local market prices for wheat have increased by 5%.',
    'Check your irrigation system for maintenance this weekend.',
    'Your follow-up appointment with Agronomist Mehta is confirmed for next week.',
    'Reminder: Register for the upcoming Agricultural Expo next month.',
    'A new subsidy program is available for small-scale farmers. Apply now!',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: AppColors.darkAppColor300,
              fontWeight: FontWeight.w100,
              fontSize: 20
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: notifications.map((notification) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ListTile(
                leading: const Icon(Icons.notifications, color: AppColors.darkAppColor300),
                title: Text(
                  notification,
                  // style: const TextStyle(
                  //   color: AppColors.darkAppColor300,
                  // ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
