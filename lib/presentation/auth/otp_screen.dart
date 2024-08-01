import 'dart:async';
import 'package:agrisense/presentation/auth/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../service/database_service.dart';
import '../../utils/constants.dart';
import '../../utils/shared_preference_helper_id.dart';
import '../home_screen.dart';
import '../widgets/custom_pincode_text_field.dart';
import '../widgets/custom_snack_bar.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String country;

  const OTPScreen({super.key, required this.phone, required this.country});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late Timer _timer;
  int _remainingSeconds = 60;
  bool _isResendClickable = false;
  final TextEditingController _otpController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false; // New state variable for loading indicator

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isResendClickable = true;
          _timer.cancel();
        }
      });
    });
  }

  Future<void> _validateOtp() async {
    setState(() {
      _isLoading = true; // Set loading to true when validating OTP
    });

    final enteredOTP = _otpController.text;
    if (enteredOTP == '888888') {
      print(widget.phone);
      bool userExists = await _databaseService.isUserExists(widget.phone);
      if (userExists) {
        await _saveToSharedPreferences();
        CustomSnackbar.show(context, message: "OTP Successfully Verified!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupScreen(phone: widget.phone)),
        );
      }
    } else {
      CustomSnackbar.show(context, message: "Incorrect OTP, please try again.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveToSharedPreferences() async {
    try {
      await SharedPreferencesHelperID.setLoggedIn(true);
      await SharedPreferencesHelperID.setPhone(widget.phone);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                "Enter the 6 digit OTP sent to +${widget.country}-${widget.phone}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomPinCodeTextField(
                context: context,
                controller: _otpController,
                onChanged: (value) {
                  // You can perform any necessary operations here
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _validateOtp, // Disable button when loading
                child: _isLoading
                    ? const SpinKitThreeBounce(
                  color: AppColors.darkAppColor300,
                  size: 20.0,
                )
                    : const Text(
                  'Verify OTP',
                  style: TextStyle(color: AppColors.darkAppColor300),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: "Didn’t receive OTP? ", style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: _isResendClickable ? 'Resend OTP' : 'Resend OTP in $_remainingSeconds sec',
                        style: _isResendClickable
                            ? const TextStyle(color: Colors.blueGrey, decoration: TextDecoration.underline)
                            : const TextStyle(color: Colors.black),
                        recognizer: _isResendClickable
                            ? (TapGestureRecognizer()
                          ..onTap = () {
                            CustomSnackbar.show(context, message: "OTP resent to +91-${widget.phone}");
                            if (mounted) {
                              setState(() {
                                _remainingSeconds = 30;
                                _isResendClickable = false;
                                _startTimer();
                              });
                            }
                          })
                            : null,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
