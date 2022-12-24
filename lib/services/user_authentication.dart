import 'package:firebase_auth/firebase_auth.dart';

class UserAuthenticationService {
  bool userLoggedIn() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
