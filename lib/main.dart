import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantapp/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure you import this
import 'package:plantapp/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Disable Firestore offline persistence
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  runApp(const PlantifyApp());
}

class PlantifyApp extends StatelessWidget {
  const PlantifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plantify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SplashScreen(),
    );
  }
}