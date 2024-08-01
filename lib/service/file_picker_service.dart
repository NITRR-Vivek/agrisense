import 'package:file_picker/file_picker.dart';
import 'package:ml_kit_ocr/ml_kit_ocr.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'dart:io';

class FilePickerService {
  static Future<String> extractText(PlatformFile file) async {
    if (file.extension == 'pdf') {
      return _extractTextFromPdf(file);
    } else if (file.extension == 'jpg' || file.extension == 'jpeg' || file.extension == 'png') {
      return _extractTextFromImage(file);
    } else {
      throw Exception('Unsupported file type');
    }
  }

  static Future<String> _extractTextFromPdf(PlatformFile file) async {
    String text = await ReadPdfText.getPDFtext(file.path!);
    return text;
  }

  static Future<String> _extractTextFromImage(PlatformFile file) async {
    final ocr = MlKitOcr();
    final result = await ocr.processImage(InputImage.fromFilePath(file.path!));

    String extractedText = '';
    for (var block in result.blocks) {
      for (var line in block.lines) {
        for (var element in line.elements) {
          extractedText += element.text + ' ';
        }
      }
    }
    return extractedText.trim();
  }
}
