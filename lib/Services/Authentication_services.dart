  import 'package:commit_app/Connector/connector_function.dart';
import 'package:commit_app/Services/Database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';



  class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await Connector_functions.saveUserLoggedInStatus(false);
      await Connector_functions.saveUserEmailSF("");
      await Connector_functions.saveUserNameSF("");

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}