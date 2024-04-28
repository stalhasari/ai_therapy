import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Google oturum açma için GoogleSignIn nesnesi oluşturun
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Kullanıcı Google oturum açma penceresini kapattıysa veya oturum açmayı iptal ettiyse
        return null;
      }

      // Google kimliğini alın
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // FirebaseAuth ile kimlik doğrulama sağlayın
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      googleAuthProvider.setCustomParameters({
        'login_hint': googleUser.email,
      });

      // Google kimlik doğrulama bilgilerini FirebaseAuth ile kullanın
      final authResult = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );

      // Oturum açma başarılıysa kullanıcıyı döndür
      return authResult.user;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş hatası: $error')),
      );
      return null;
    }
  }
}
