import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'users';

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch users from Firestore
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromJson(data);
      }).toList();
    });
  }

  /// Upload image to Supabase Storage
  Future<String?> uploadImage(File file) async {
    try {
      final extension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final path = 'profiles/$fileName';

      await _supabase.storage.from('user-images').upload(
            path,
            file,
            fileOptions: FileOptions(
              cacheControl: '3600',
              contentType: 'image/$extension',
              upsert: false,
            ),
          );

      final String publicUrl =
          _supabase.storage.from('user-images').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception("Failed to upload image to Supabase: $e");
    }
  }

  /// Add new user (បង្កើតទាំងក្នុង Firebase Auth និង Firestore ព្រមគ្នា)
  Future<void> addUser(UserModel user, String password) async {
    try {
      // ១. បង្កើតគណនីក្នុង Firebase Authentication ជាមុនសិន
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email ?? '',
        password: password,
      );
      String uid = userCredential.user!.uid;

      // ២. បង្កើត Model ជាមួយ UID ដែលបានពី Auth
      UserModel userWithId = UserModel(
        id: uid,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: password, 
        role: user.role,
        status: user.status,
        imageUrl: user.imageUrl,
        createdAt: user.createdAt,
      );

      // ៣. រក្សាទុកចូល Firestore យ៉ាងពិតប្រាកដដោយប្រើ doc(uid)
      await _firestore.collection(collection).doc(uid).set(userWithId.toJson());
      
    } catch (e) {
      throw Exception("Failed to create user: $e");
    }
  }

  /// Update existing user in Firestore
  Future<void> updateUser(UserModel user) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception("Cannot update user without a valid ID");
    }

    try {
      await _firestore.collection(collection).doc(user.id!).update(user.toJson());
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }

  /// Delete user from Firestore
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }
}