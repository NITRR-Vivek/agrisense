import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/constants.dart';


class QRresultScreenDialog extends StatelessWidget {
  final String code;
  final Function() closeScreen;

  const QRresultScreenDialog({super.key, required this.code, required this.closeScreen});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.darkAppColor300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("QR Scan Result",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                padding:const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const SizedBox(height: 10),
                    QrImageView(
                      data:code,backgroundColor: Colors.white,
                      size: 250,
                      version: QrVersions.auto,),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}