import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'load_image_with_shimmer.dart';

class ConsultationCard extends StatelessWidget {
  final String imagePath;
  final String doctorName;
  final String date;
  final String time;

  const ConsultationCard({
    super.key,
    required this.imagePath,
    required this.doctorName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.lightAppColor600,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadImageWithShimmer(imagePath: imagePath),
          const SizedBox(height: 10),
          Text(doctorName, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(date, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 5),
          Text(time, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
