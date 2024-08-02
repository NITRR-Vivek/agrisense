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
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFormField('Soil Quality (50 to 100)', 'Soil quality index', (value) {
                    soil = double.parse(value);
                  }),
                  buildTextFormField('Seed Variety (0 or 1)', '0: low yield, and 1: high yield', (value) {
                    seed = double.parse(value);
                  }),
                  buildTextFormField('Fertilizer Amount (kg/hectare)', 'Amount of fertilizer used (kgs per hectare)', (value) {
                    fertilizer = double.parse(value);
                  }),
                  buildTextFormField('Sunny Days', 'Number of sunny days during the growing season', (value) {
                    sunny = double.parse(value);
                  }),
                  buildTextFormField('Rainfall (mm)', 'Total rainfall during the growing season in millimeters', (value) {
                    rainfall = double.parse(value);
                  }),
                  buildTextFormField('Irrigation Schedule', 'Number of irrigations during the growing season', (value) {
                    irrigation = double.parse(value);
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _predict,
                      child: const Text('Submit',style: TextStyle(color: AppColors.darkAppColor300),),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_result != null) Text('Predicted Yield: $_result kg/hectare',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
          labelStyle: const TextStyle(fontSize: 12),
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
        final predictedYield = await predictor.predictYield(
          soil,
          seed,
          fertilizer,
          sunny,
          rainfall,
          irrigation,
        );
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
