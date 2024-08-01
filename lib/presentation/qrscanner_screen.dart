import 'package:agrisense/presentation/qr_result_screen.dart';
import 'package:agrisense/presentation/widgets/camera_screen_overlay.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/scan.dart';

import '../utils/constants.dart';


class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isZoomed = false;
  String zoomText = "1X";

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  void closeScreen(){
    isScanCompleted = false;
  }
  Future<void> _handlePickFromGallery() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      String? code = await Scan.parse(pickedImage.path);
      if (code!.isNotEmpty) {
        isScanCompleted = true;
        showDialog(
          context: context,
          builder: (context) => QRresultScreenDialog(
            code: code,
            closeScreen: closeScreen,
          ),
        );
      }
    }
  }
  void _handleToggleFlashlight() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    cameraController.toggleTorch();
  }
  void _handleZoomCamera() {
    isZoomed = !isZoomed;
    if(isZoomed){
      zoomText = "2X";
      cameraController.setZoomScale(0.8);

    }else{
      zoomText = "1X";
      cameraController.setZoomScale(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcode){
              if(!isScanCompleted){
                String qrCode = barcode.raw?.toString() ?? '---';
                String code = qrCode.split('rawValue: ')[1].split(' ')[0].trim();
                if (code.endsWith(',')) {
                  code = code.substring(0, code.length - 1);
                }
                isScanCompleted = true;
                showDialog(
                  context: context,
                  builder: (context) => QRresultScreenDialog(
                    code: code,
                    closeScreen: closeScreen,
                  ),
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultScreen(code:code,closeScreen: closeScreen)));
              }
            },
            overlayBuilder: (context,size){
              return ScannerOverlay(
                onPickFromGallery: _handlePickFromGallery,
                onToggleFlashlight: _handleToggleFlashlight,
                onZoomCamera: _handleZoomCamera,
                isFlashlightOn: isFlashOn,
                isZoomed: isZoomed,
                zoomText:zoomText
              );
            },
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.darkAppColor300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
