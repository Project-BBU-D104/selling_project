import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  }

  /// Login With Username
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .where(
          'username',
          isEqualTo: username,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception(
        'Username not found',
      );
    }

    final email =
        snapshot.docs.first['email'];

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}