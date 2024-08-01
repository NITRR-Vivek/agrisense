import 'package:flutter/material.dart';
import '../../service/model_predictor.dart';
import '../../utils/constants.dart';

class CropYieldPrediction extends StatefulWidget {
  const CropYieldPrediction({super.key});

  @override
  State<CropYieldPrediction> createState() => _CropYieldPredictionState();
}

class _CropYieldPredictionState extends State<CropYieldPrediction> {
  final _formKey = GlobalKey<FormState>();

  double soil = 0.0;
  double seed = 0.0;
  double fertilizer = 0.0;
  double sunny = 0.0;
  double rainfall = 0.0;
  double irrigation = 0.0;

  bool _isLoading = false;
  String? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crop Yield Prediction',
          style: TextStyle(
            color: AppColors.darkAppColor300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFormField('Soil Quality', 'Soil quality index, ranging from 50 to 100', (value) {
                    soil = double.parse(value);
                  }),
                  buildTextFormField('Seed Variety', 'Enter seed variety', (value) {
                    seed = double.parse(value);
                  }),
                  buildTextFormField('Fertilizer Amount (kg/hectare)', 'The amount of fertilizer used in kilograms per hectare', (value) {
                    fertilizer = double.parse(value);
                  }),
                  buildTextFormField('Sunny Days', 'The number of sunny days during the growing season', (value) {
                    sunny = double.parse(value);
                  }),
                  buildTextFormField('Rainfall (mm)', 'Total rainfall received during the growing season in millimeters', (value) {
                    rainfall = double.parse(value);
                  }),
                  buildTextFormField('Irrigation Schedule', 'The number of irrigations during the growing season', (value) {
                    irrigation = double.parse(value);
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _predict,
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_result != null) Text('Predicted Yield: $_result'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, String hint, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  void _predict() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final predictor = ModelPredictor();
        final predictedYield = await predictor.predictYield(soil, seed, fertilizer, sunny, rainfall, irrigation);
        setState(() {
          _result = predictedYield.toStringAsFixed(2);
        });
      } catch (e) {
        setState(() {
          _result = 'Failed to predict yield';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
