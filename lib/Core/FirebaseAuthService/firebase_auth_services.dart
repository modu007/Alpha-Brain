import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future registration({
    required String email,
    required String password,
  }) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // static Future signInWithGoogle() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn();
  //
  //   if (googleSignInAccount != null) {
  //     print("email: ${googleSignInAccount.email}");
  //
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //
  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(credential);
  //
  //       return userCredential;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // handle the error here
  //         print("google${e.message}");
  //       } else if (e.code == 'invalid-credential') {
  //         // handle the error here
  //         print("google${e.message}");
  //       }
  //       return e.code;
  //     } catch (error) {
  //       print("google${error.toString()}");
  //       // handle the error here
  //       return error;
  //     }
  //   }
  // }
  //
  // static Future<void> signOut() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  //   try {
  //     if (!kIsWeb) {
  //       await googleSignIn.signOut();
  //     }
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     print("google${e.toString()}");
  //   }
  // }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<String?> addPinToTheUser(
      {required User user, required String pin}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(user.uid).set({"pin": pin});
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future verifyPin({required User user}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      DocumentSnapshot snapshot = await users.doc(user.uid).get();
      return snapshot.data();
    } catch (e) {
      return 'fetching error';
    }
  }

  Future multiFactorEnable(
      {required User user,
      required String smsCode,
      required String verificationId}) async {
    try {
      // Verify and enroll second factor
      final secondFactorVerified = await verifySecondFactor(
        user: user,
        smsCode: smsCode,
        verificationId: verificationId,
      );
      if (!secondFactorVerified) {
        return 'Failed to verify second factor.';
      }
      return user;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> verifySecondFactor(
      {required User user,
      required String smsCode,
      required String verificationId}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // Enroll the second factor
      await user.multiFactor.enroll(
        PhoneMultiFactorGenerator.getAssertion(credential),
      );
      return true; // Successfully verified and enrolled second factor
    } on FirebaseAuthException {
      // Handle authentication errors
      return false;
    } catch (e) {
      // Handle other errors
      return false;
    }
  }

}
