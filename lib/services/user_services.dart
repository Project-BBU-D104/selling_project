import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selling_project/services/api_services.dart';
import 'package:selling_project/models/user_model.dart';


class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'username': username,
      'email': email,
      'role': 'Staff',
      'department': 'General',
      'status': true,
      'photoUrl': null,
    });
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Username not found');
    }

    final email = snapshot.docs.first['email'];

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}

class UserService {
  final ApiServices _api = ApiServices();
  final String collection = 'users';
  Stream<List<UserModel>> getUsers() {
    return _api.get(collection).map((snapshot) {
      return snapshot.map((json) => UserModel.fromJson(json)).toList();
    });
  }

  Future<void> addUser(UserModel user) async {
    Map<String, dynamic> data = user.toJson();
    
    final generatedId = await _api.post(collection, data);
    await _api.put(collection, generatedId, {'uid': generatedId});
  }

  Future<void> updateUser(UserModel user) async {
    if (user.uid == null || user.uid!.isEmpty) {
      throw Exception("Cannot update user without a valid UID");
    }
    await _api.put(collection, user.uid!, user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _api.delete(collection, id);
  }
}