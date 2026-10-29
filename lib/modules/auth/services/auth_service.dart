import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
 static Future<User> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateProfile(displayName: name);
      await credential.user?.updateDisplayName(name);
      await credential.user?.sendEmailVerification();
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }else{
        throw e.message??"";
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw "Invalid Email or Password";
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw "Invalid Email";
    } catch (e) {
      rethrow;
    }
  }

 static bool _googleInitialized = false;

 // لازم تتنادى مرة واحدة قبل أي استخدام لـ GoogleSignIn
 static Future<void> _initGoogle() async {
   if (_googleInitialized) return;
   await GoogleSignIn.instance.initialize();
   _googleInitialized = true;
 }

 static Future<User?> signInWithGoogle() async {
   await _initGoogle();
   try {
     final account = await GoogleSignIn.instance.authenticate();
     final idToken = account.authentication.idToken;
     final credential = GoogleAuthProvider.credential(idToken: idToken);
     final result =
     await FirebaseAuth.instance.signInWithCredential(credential);
     return result.user;
   } on GoogleSignInException catch (e) {
     if (e.code == GoogleSignInExceptionCode.canceled) return null;
     throw e.description ?? "Google sign in failed";
   } on FirebaseAuthException catch (e) {
     throw e.message ?? "Google sign in failed";
   }
 }

 static Future<void> logout() async {
   await _initGoogle();
   await GoogleSignIn.instance.signOut();
   await FirebaseAuth.instance.signOut();
 }
}
