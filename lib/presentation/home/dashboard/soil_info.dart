import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:lottie/lottie.dart';

class SoilInfoScreen extends StatefulWidget {
  const SoilInfoScreen({super.key});

  @override
  _SoilInfoScreenState createState() => _SoilInfoScreenState();
}

class _SoilInfoScreenState extends State<SoilInfoScreen> {
  bool isLoading = true;
  bool isWateringOn = false;
  final Random random = Random();
  Map<String, dynamic> soilInfo = {};
  List<String> tips = [
    "Rotate crops to maintain soil health.",
    "Use organic fertilizers to enrich the soil.",
    "Mulch your garden to retain moisture.",
    "Test soil pH regularly.",
    "Water plants early in the morning."
  ];

  @override
  void initState() {
    super.initState();
    _fetchSoilInfo();
  }

  Future<void> _fetchSoilInfo() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay
    setState(() {
      isLoading = false;
      soilInfo = {
        'temperature': 22 + random.nextInt(10), // Random temperature
        'moisture': 30 + random.nextInt(50), // Random moisture
        'pH': 5.5 + random.nextDouble() * 2.5, // Random pH value
        'nitrogen': random.nextInt(100),
        'phosphorus': random.nextInt(100),
        'potassium': random.nextInt(100)
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Information'),
        backgroundColor: AppColors.darkAppColor200
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSoilInfoCard(),
            const SizedBox(height: 16),
            _buildRandomTipCard(),
            const SizedBox(height: 16),
            _buildWateringSwitch(),
            if (isWateringOn) ...[
              const SizedBox(height: 16),
              _buildWateringAnimation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSoilInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soil Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Temperature', '${soilInfo['temperature']} °C'),
            _buildInfoRow('Moisture', '${soilInfo['moisture']} %'),
            _buildInfoRow('pH', soilInfo['pH'].toStringAsFixed(1)),
            _buildInfoRow('Nitrogen', '${soilInfo['nitrogen']} ppm'),
            _buildInfoRow('Phosphorus', '${soilInfo['phosphorus']} ppm'),
            _buildInfoRow('Potassium', '${soilInfo['potassium']} ppm'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildRandomTipCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tip for You',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            const SizedBox(height: 16),
            Text(
              tips[random.nextInt(tips.length)],
              style: const TextStyle(fontSize: 16, color: AppColors.darkAppColor300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWateringSwitch() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Watering',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            Switch(
              value: isWateringOn,
              onChanged: (value) {
                _toggleWatering(value);
              },
              activeColor: AppColors.darkAppColor300,
            ),
          ],
        ),
      ),
    );
  }
  void _toggleWatering(bool value) {
    setState(() {
      isWateringOn = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isWateringOn ? 'Watering turned on' : 'Watering turned off'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  Widget _buildWateringAnimation() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Lottie.asset(
        'assets/watering.json',
        fit: BoxFit.cover,
      ),
    );
  }
}
