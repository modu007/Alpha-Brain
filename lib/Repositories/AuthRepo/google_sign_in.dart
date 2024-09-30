import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAuth {
  static Future<User?> signIn() async {
    final googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // Check if the account is null (user canceled or error occurred)
      if (googleSignInAccount == null) {
        log("Google sign-in was cancelled or failed.");
        return null;
      }

      // If account is not null, proceed with authentication
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      print(user);
      return user;
    } catch (e) {
      log("Google sign in failed: $e");
    }
    return null;
  }
}
