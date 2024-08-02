import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropDiseasePrediction extends StatefulWidget {
  const CropDiseasePrediction({Key? key}) : super(key: key);

  @override
  _CropDiseasePredictionState createState() => _CropDiseasePredictionState();
}

class _CropDiseasePredictionState extends State<CropDiseasePrediction> {
  File? _image;
  bool _loading = false;
  String? _result;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _result = null;
    });
  }

  Future<void> _predictDisease() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final url = Uri.parse('https://crop-disease-8dm5.onrender.com/predict/');
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = jsonDecode(String.fromCharCodes(responseData));

      setState(() {
        _result = result['predicted_class'];
      });
    } catch (error) {
      setState(() {
        _result = 'Error predicting disease';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Disease Prediction'),
        backgroundColor: AppColors.lightAppColor300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_image != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    _image!,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearImage,
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _image == null ? _pickImage : _predictDisease,
              icon: _loading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Icon(Icons.search),
              label: Text(_image == null ? 'Select Image' : 'Predict'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: AppColors.darkAppColor300,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Prediction: $_result',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
