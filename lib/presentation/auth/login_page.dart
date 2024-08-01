import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../widgets/custom_mobile_number.dart';
import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Country selectedCountry = CountryParser.parseCountryCode("IN");
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  String getPhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    return phoneNumber;
  }

  String getCountryCode() {
    final countryCode = selectedCountry.phoneCode;
    return countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.appIcon, height: 100, width: 100),
                  const SizedBox(height: 40),
                  RichText(
                    text: const TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(fontSize: 24, color: AppColors.darkAppColor100),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Agri Sense',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkAppColor300,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  CustomPhoneNumber(
                    country: selectedCountry,
                    controller: phoneNumberController,
                    onTap: (Country value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                  const Text(
                    'A 6-digit OTP will be sent to verify your mobile number.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPScreen(
                            phone: getPhoneNumber(),
                            country: getCountryCode(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Send OTP',style: TextStyle(color: AppColors.darkAppColor300),),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
