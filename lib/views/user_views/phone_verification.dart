import 'dart:math';

import 'package:ai_therapy/views/user_views/chat_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final List<TextEditingController> _codeControllers =
      List.generate(6, (index) => TextEditingController());

  bool isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100), // Üst boşluk
              const Text(
                "Telefon Doğrulama",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Telefon numaranıza gönderilen 6 haneli kodu girin",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              // Şık bir kod giriş alanı
              Container(
                padding: const EdgeInsets.all(8.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 6; i++) _buildCodeNumberBox(i),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Doğrulama butonu
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final cred = PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: _codeControllers.toString());

                          await FirebaseAuth.instance
                              .signInWithCredential(cred);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatPage(),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          log(e.toString() as num);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text(
                        "Doğrula",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Her bir rakam için kutucuk oluşturma fonksiyonu
  Widget _buildCodeNumberBox(int index) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        controller: _codeControllers[index],
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus(); // Bir sonraki kutucuğa odaklan
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          counterText: '', // Karakter sayısını gizle
        ),
      ),
    );
  }
}
