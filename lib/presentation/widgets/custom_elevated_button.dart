import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton({
    super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    super.margin,
    super.onPressed,
    super.buttonStyle,
    super.alignment,
    super.buttonTextStyle,
    super.isDisabled,
    super.height,
    super.width,
    required super.text,
    this.isLoading = false,
  });

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildElevatedButtonWidget,
    )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: height ?? 40,
    width: width ?? double.maxFinite,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      onPressed: isDisabled ?? false ? null : onPressed ?? () {},
      child: isLoading
          ? const CircularProgressIndicator(
        color: Colors.white,
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leftIcon != null) leftIcon!,
          Text(
            text,
            style: const TextStyle(color: AppColors.darkAppColor500,fontSize: 16),
          ),
          if (rightIcon != null) rightIcon!,
        ],
      ),
    ),
  );
}
