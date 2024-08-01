import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/shared_preference_helper_id.dart';
import 'auth/login_page.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isLoggedIn = false;
  String phone = "";

  Future<void> _getUserDataFromSharedPreferences() async {
    final String? storedPhone = await SharedPreferencesHelperID.getPhone();
    final bool? loggedIn = await SharedPreferencesHelperID.getLoggedIn();

    if (storedPhone != null && loggedIn != null) {
      setState(() {
        phone = storedPhone;
        isLoggedIn = loggedIn;
      });
    }
  }

  void _navigateToNextScreen() {
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();

    _getUserDataFromSharedPreferences().then((_) {
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _navigateToNextScreen();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Image.asset(
                  AppImages.appIcon,
                  height: 150, // Adjust the height as needed
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Agri Sense',
                style: TextStyle(
                  color: AppColors.darkAppColor100,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
