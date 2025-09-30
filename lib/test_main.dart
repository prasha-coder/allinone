import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sih_2/services/auth_service_new.dart';
import 'package:sih_2/screens/role_selection_screen.dart';
import 'package:sih_2/app_theme.dart';
import 'package:sih_2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthServiceNew(),
      child: const TestApp(),
    ),
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThingBots - Test',
      theme: AppTheme.theme,
      home: const RoleSelectionScreen(),
    );
  }
}
