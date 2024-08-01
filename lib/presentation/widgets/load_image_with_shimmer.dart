import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadImageWithShimmer extends StatelessWidget {
  final String imagePath;

  const LoadImageWithShimmer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.error, color: Colors.red),
            );
          } else {
            return CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            );
          }
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
            ),
          );
        }
      },
    );
  }

  Future<void> _loadImage(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate a network delay
    // You can replace this with actual image loading logic if needed
  }
}
