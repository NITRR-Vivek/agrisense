import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../utils/constants.dart';

class CustomPinCodeTextField extends StatefulWidget {
  const CustomPinCodeTextField({
    super.key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  });

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  final Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  State<CustomPinCodeTextField> createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {
  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
      alignment: widget.alignment ?? Alignment.center,
      child: pinputWidget,
    )
        : pinputWidget;
  }

  Widget get pinputWidget => Pinput(
    controller: widget.controller,
    length: 6,
    keyboardType: TextInputType.number,
    autofocus: false,
    cursor: const Text("___"),
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    defaultPinTheme: PinTheme(
        height: 48,
        width: 48,
        textStyle: widget.textStyle ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.primaryColor),
        )),
    focusedPinTheme: PinTheme(
      height: 48.0,
      width: 48.0,
      textStyle: widget.textStyle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.secondaryColor, width: 2.0),
      ),
    ),
    submittedPinTheme: PinTheme(
      height: 48.0,
      width: 48.0,
      textStyle: widget.textStyle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.secondaryColor),
      ),
    ),
    onChanged: (value) => widget.onChanged(value),
    validator: widget.validator,
  );
}
