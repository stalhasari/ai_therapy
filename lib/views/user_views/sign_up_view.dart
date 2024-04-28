import 'dart:developer';

import 'package:ai_therapy/views/user_views/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  bool isLoading = false;

  User? _user;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş hatası: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/therapy_asset.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: const Duration(seconds: 1),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/2man2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/women.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/2man.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 30, left: 30),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueAccent),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              )),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Kullanıcı Adı",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "+90", // Ülke kodu
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Aralık bırakın
                                  Expanded(
                                    child: TextField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Telefon Numarası",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Şifre",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: phoneController.text,
                                  verificationCompleted:
                                      (phoneAuthCredential) {},
                                  verificationFailed: (error) {
                                    log(error.toString());
                                  },
                                  codeSent:
                                      (verificationId, forceResendingToken) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhoneVerificationPage(
                                                  verificationId:
                                                      verificationId,
                                                )));
                                  },
                                  codeAutoRetrievalTimeout: (verificationId) {
                                    log("Zaman aşımına uğradı");
                                  },
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Colors.blue,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Kayıt Ol",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width:
                                80, // Increased width for larger logo display
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(60, 60),
                              ),
                              onPressed: () {
                                handleGoogleSignIn();
                              },
                              child:
                                  Image.asset('assets/images/google_logo.png'),
                            ),
                          ),
                          SizedBox(
                            width:
                                80, // Increased width for larger logo display
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(60, 60),
                              ),
                              onPressed: () {
                                handleGoogleSignIn();
                              },
                              child:
                                  Image.asset('assets/images/apple_logo.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
