import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUtil {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await firebaseAuth.signInWithCredential(credential);
    }
    return null;
  }
}
