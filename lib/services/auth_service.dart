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
      print("✓ Registration successful");
    } on FirebaseAuthException catch (e) {
      print("❌ Firebase Auth Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected Error: $e");
      rethrow;
    }
  }

  /// Login With Username
  Future<void> login({
  required String username,
  required String password,
}) async {
  _logDebugInfo();
  await _checkNetworkConnectivity();
  
  try {
    final snapshot = await firestore
        .collection('users')
        .where(
          'username',
          isEqualTo: username,
        )
        .limit(1)
        .get();

    print("Found docs: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty) {
      throw Exception('Username not found');
    }

    final email = snapshot.docs.first['email'];

    print("Email: $email");

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("✓ Login successful for email: $email");
  } on FirebaseAuthException catch (e) {
    print("❌ Firebase Auth Code: ${e.code}");
    print("❌ Firebase Auth Message: ${e.message}");
    print("❌ Firebase StackTrace: ${e.stackTrace}");
    rethrow;
  } catch (e) {
    print("❌ Unexpected error: $e");
    rethrow;
  }
}

  Future<void> logout() async {
    await auth.signOut();
  }

  /// Diagnostic: Check Firebase initialization and device info
  void _logDebugInfo() {
    print("\n═══════ Firebase Debug Info ═══════");
    print("Firebase App Initialized: ${Firebase.apps.isNotEmpty}");
    if (Firebase.apps.isNotEmpty) {
      print("App Name: ${Firebase.apps[0].name}");
    }
    print("Auth User: ${auth.currentUser?.email ?? 'None (Not signed in)'}");
    print("════════════════════════════════════\n");
  }

  /// Diagnostic: Check network connectivity
  Future<void> _checkNetworkConnectivity() async {
    try {
      print("\nChecking network connectivity...");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("✓ Network connectivity: OK");
      }
    } on SocketException catch (_) {
      print("❌ Network connectivity: FAILED");
      print("   Please check your internet connection!");
      rethrow;
    }
  }
}