import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropDiseasePrediction extends StatefulWidget {
  const CropDiseasePrediction({super.key});

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

    // Make the request to your hosted model
    final url = Uri.parse('https://crop-disease-8dm5.onrender.com');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final result = jsonDecode(String.fromCharCodes(responseData));

    setState(() {
      _loading = false;
      _result = result['class'];  // Assuming the model returns a JSON with a 'class' field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Disease Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_image != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(_image!),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearImage,
                  ),
                ],
              ),
            if (_image == null)
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
            if (_image != null)
              ElevatedButton(
                onPressed: _predictDisease,
                child: _loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Predict'),
              ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Prediction: $_result',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
