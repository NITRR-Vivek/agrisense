import 'package:agrisense/presentation/ai_tools/crop_disease.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'chat_pdf.dart';
import 'chatai.dart';
import 'crop_yield.dart';

class AIToolsScreen extends StatelessWidget {
  AIToolsScreen({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Tools',
          style: TextStyle(
            color: AppColors.darkAppColor300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _tools.length,
          itemBuilder: (context, index) {
            final tool = _tools[index];
            return GestureDetector(
              onTap: () => _navigateToScreen(context, tool['screen']),
              child: Card(
                color: AppColors.lightAppColor800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        tool['image'],
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tool['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tool['description'],
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _tools = [
    {
      'image': 'assets/images/crop_disease.png',
      'title': 'Crop Disease Prediction',
      'description': 'Predict the likelihood of diseases affecting your crops using advanced AI algorithms.',
      'screen': const CropDiseasePrediction(),
    },
    {
      'image': 'assets/images/crop_yield.png',
      'title': 'Crop Yield Prediction',
      'description': 'It will help predict the potential yield of your crops using data-driven insights and machine learning models.',
      'screen': const CropYieldPrediction(),
    },
    {
      'image': 'assets/images/queries2.png',
      'title': 'Chat with FarmBot',
      'description': 'Chat with AI related to health related concerns and potential medical conditions.',
      'screen': const ChatScreen(),
    },
    {
      'image': 'assets/images/queries.png',
      'title': 'AI with Pdf/Images',
      'description': 'Chat with AI using context of your image or PDF texts',
      'screen': const ChatPdf(),
    },
    // Add more tools as needed
  ];
}
