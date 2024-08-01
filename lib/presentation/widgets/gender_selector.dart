import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String?) onChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Row(
          children: ['Male', 'Female', 'Others'].map((gender) {
            return Row(
              children: [
                Radio<String>(
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                Text(gender),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
