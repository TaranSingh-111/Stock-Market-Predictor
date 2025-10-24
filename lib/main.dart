import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:stock_market_predictor/screens/main_screen.dart';
import 'package:stock_market_predictor/screens/login_screen.dart';
import 'package:stock_market_predictor/screens/sign_up_screen.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';



void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    getPages: [
      GetPage(name: '/login', page: () => const LoginScreen()),
      GetPage(name: '/signup', page: () => const SignUpScreen()),
      GetPage(name: '/main', page: () => const MainScreen()),
    ],
  ));
}