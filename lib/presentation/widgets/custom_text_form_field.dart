import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String fieldKey;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final int? width;
  final Map<String, String> formData;
  final String? suffixText;
  final bool? capitalize;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.fieldKey,
    this.inputType,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    required this.formData,
    this.width,
    this.suffixText, this.capitalize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: inputType,
            controller: controller,
            readOnly: readOnly,
            initialValue: controller != null ? null : initialValue,
            textCapitalization: capitalize == true ? TextCapitalization.characters : TextCapitalization.none,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor,width: 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.darkAppColor100),
                borderRadius: BorderRadius.circular(12.0),
              ),
              labelStyle: const TextStyle(
                  color: AppColors.darkAppColor100,
              ),
              labelText: labelText,
              suffixText: suffixText, // Added suffixText
              suffixStyle: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 14.0,
              ),
            ),
            onSaved: (value) => formData[fieldKey] = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
            cursorColor: AppColors.darkAppColor400,
          ),
        ],
      ),
    );
  }
}
