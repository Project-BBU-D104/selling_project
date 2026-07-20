import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ApiServices {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> uploadImage(File file, String path) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref().child('$path/$fileName');
    
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  // GET
  Stream<List<Map<String,dynamic>>> get(
      String collection
  ){

    return _db
    .collection(collection)
    .snapshots()
    .map((snapshot){
      return snapshot.docs.map((doc){
        return {
          "id": doc.id,
          ...doc.data()
        };
      }).toList();
    });
  }

// get by id
Future<Map<String, dynamic>?> getById(
  String collection,
  String id,
) async {
  final doc = await _db
      .collection(collection)
      .doc(id)
      .get();

  if (!doc.exists) {
    return null;
  }

  return {
    "id": doc.id,
    ...doc.data()!,
  };
}
  // POST
  Future<String> post(
      String collection,
      Map<String,dynamic> data
  ) async {
    final result =
    await _db
    .collection(collection)
    .add(data);
    return result.id;
  }
  
  // PUT
  Future<void> put(
      String collection,
      String id,
      Map<String,dynamic> data
  ) async {
    await _db
    .collection(collection)
    .doc(id)
    .update(data);
  }
  // DELETE
  Future<void> delete(
      String collection,
      String id
  ) async {
    await _db
    .collection(collection)
    .doc(id)
    .delete();
  }

  Stream<List<Map<String, dynamic>>> getSubCollection(
  String collection,
  String docId,
  String subCollection,
) {
  return _db
      .collection(collection)
      .doc(docId)
      .collection(subCollection)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  });
}

Future<String> postSubCollection(
  String collection,
  String docId,
  String subCollection,
  Map<String, dynamic> data,
) async {
  final ref = await _db
      .collection(collection)
      .doc(docId)
      .collection(subCollection)
      .add(data);

  return ref.id;
}
}
