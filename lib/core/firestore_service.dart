import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCollection(
    String collectionName,
  ) async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch $collectionName : $e');
    }
  }

  Future<List<String>> getOptions({
    required String collectionName,
    String documentId = 'main',
  }) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(documentId)
          .get();

      if (!doc.exists) return [];

      return List<String>.from(doc['options']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getVideos(
  String collectionName,
) async {
  final snapshot =
      await _firestore.collection(collectionName).get();

  return snapshot.docs.map((doc) {
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }).toList();
}

  Future<Map<String, dynamic>?> getDocument({
    required String collectionName,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(documentId)
          .get();

      return doc.data();
    } catch (e) {
      throw Exception('Failed to fetch document');
    }
  }

  Future<void> addDocument({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionName).add(data);
  }

  Future<void> updateDocument({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionName).doc(documentId).update(data);
  }

  Future<void> deleteDocument({
    required String collectionName,
    required String documentId,
  }) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }
}
