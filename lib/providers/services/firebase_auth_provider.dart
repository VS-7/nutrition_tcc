import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider with ChangeNotifier {
  User? user;

  FirebaseAuthProvider() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<String?> createEmailPasswordAccount(
      String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      final message = e.message;
      return message ?? 'Ocorreu um erro inesperado. Tente mais tarde.';
    } catch (e) {
      debugPrint(
          "Error on method 'createEmailPasswordAccount', in class 'FirebaseAuthProvider': $e");
    }
    return null;
  }

  Future<String?> loginEmailPassword(
      String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        return "Senha ou email inválidos.";
      }
      final message = e.message;
      return message ?? 'Ocorreu um erro inesperado. Tente mais tarde.';
    } catch (e) {
      debugPrint(
          "Error on method 'loginEmailPassword', in class 'FirebaseAuthProvider': $e");
    }
    return null;
  }

  Future<String?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null;
    } catch (e) {
      debugPrint(
          "Error on method 'signOut', in class 'FirebaseAuthProvider': $e");
      return "Ocorreu um erro inesperado. Tente mais tarde.";
    }
  }

  Future<String?> updatePassword(String password) async {
    try {
      await user?.updatePassword(password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        return "Por favor. Faça logout e login novamente para conseguir redefinir a senha.";
      }
    } catch (e) {
      debugPrint(
          "Error on method 'updatePassword', in class 'FirebaseAuthProvider': $e");
      return "Ocorreu um erro inesperado. Tente mais tarde.";
    }
    return null;
  }

  Future<String?> updatePasswordViaEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      debugPrint(
          "Error on method 'updatePasswordViaEmail', in class 'FirebaseAuthProvider': $e");
      return "Ocorreu um erro inesperado. Tente mais tarde.";
    }
  }

  String? get uid {
    return user?.uid;
  }
}
