

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetGoogleEmail {

  Future<Map<String, dynamic>> getGoogleEmail() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(

    );

    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        return {'result': false};
      }

      final GoogleSignInAuthentication googleAuth = await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user?.email != null) {
        String name = '', surname = '';

        if (authResult.user?.displayName != null) {
          List<String> list = authResult.user!.displayName!.split(' ');
          name = list[0];
          surname = list[1];
        }

        return {
          'result': true,
          'email': authResult.user?.email,
          'password': authResult.user?.uid,
          'phone': authResult.user?.phoneNumber,
          'name': name,
          'surname': surname,
          'user_photo': authResult.user?.photoURL,
        };
      } else {
        print('Error: result = false');
        return {'result': false};
      }
    } catch (e) {
      print('Error while getting email - $e');
      return {'result': false};
    }
  }
}
