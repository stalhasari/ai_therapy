import 'package:ai_therapy/firebase_options.dart';
import 'package:ai_therapy/models/const.dart';
import 'package:ai_therapy/views/user_views/chat_screen_view.dart';
import 'package:ai_therapy/views/user_views/login_view.dart';
import 'package:ai_therapy/views/user_views/phone_verification.dart';
import 'package:ai_therapy/views/user_views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}
