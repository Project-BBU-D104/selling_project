import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth auth =
      FirebaseAuth.instance;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  /// Register
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _logDebugInfo();
    await _checkNetworkConnectivity();
    
    try {
      final credential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'username': username,
        'email': email,
      });
      
    } on FirebaseAuthException catch (e) {
      print("❌ Firebase Auth Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected Error: $e");
      rethrow;
    }
  }

  /// Login With Username
  Future<User?> login({
  required String username,
  required String password,
}) async {
  _logDebugInfo();
  await _checkNetworkConnectivity();

  try {
    final snapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Username not found');
    }

    final email = snapshot.docs.first['email'];

    final credential =
        await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  } on FirebaseAuthException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}

  Future<void> logout() async {
    await auth.signOut();
  }

  /// Diagnostic: Check Firebase initialization and device info
  void _logDebugInfo() {
   
    if (Firebase.apps.isNotEmpty) {
      print("App Name: ${Firebase.apps[0].name}");
    }
     
  }

  /// Diagnostic: Check network connectivity
  Future<void> _checkNetworkConnectivity() async {
    try {
       
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("✓ Network connectivity: OK");
      }
    } on SocketException catch (_) {
      print("   Please check your internet connection!");
      rethrow;
    }
  }
}