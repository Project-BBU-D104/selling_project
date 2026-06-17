import 'package:cloud_firestore/cloud_firestore.dart';

class ApiServices {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;
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
