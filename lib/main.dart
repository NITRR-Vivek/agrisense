import 'package:agrisense/presentation/auth/login_page.dart';
import 'package:agrisense/presentation/auth/otp_screen.dart';
import 'package:agrisense/presentation/home_screen.dart';
import 'package:agrisense/presentation/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        hintColor: AppColors.accentColor,
        fontFamily: 'K2D',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
        '/otp': (context) => const OTPScreen(phone: '', country: ''),
      },
    );
  }
}
