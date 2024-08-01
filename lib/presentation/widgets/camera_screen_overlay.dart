import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ScannerOverlay extends StatelessWidget {
  final Function() onPickFromGallery;
  final Function() onToggleFlashlight;
  final Function() onZoomCamera;
  final bool isFlashlightOn;
  final bool isZoomed;

  const ScannerOverlay({super.key,
    required this.onPickFromGallery,
    required this.onToggleFlashlight,
    required this.onZoomCamera,
    required this.isFlashlightOn,
    required this.isZoomed,
    required String zoomText,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 70,
      right: 70,
      bottom: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton(
              onPressed: onPickFromGallery,
              icon: Icons.collections_rounded,
            ),
            _buildIconButton(

              onPressed: onToggleFlashlight,
              icon: Icons.flash_on,
              color: isFlashlightOn? AppColors.primaryColor : Colors.white,
            ),
            _buildIconButton(
              onPressed: onZoomCamera,
              icon: isZoomed? Icons.looks_two_outlined : Icons.looks_one_outlined,
              color: isZoomed? AppColors.primaryColor : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required VoidCallback onPressed, required IconData icon, Color? color}) {
    return Container(
      height: 40,

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: IconButton(
        iconSize: 24,
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Colors.white),
      ),
    );
  }
}
