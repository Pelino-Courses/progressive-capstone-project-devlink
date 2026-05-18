import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _products => _firestore.collection('products');

  Stream<List<Product>> getProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Stream<List<Product>> getProductsByCategory(String category) {
    return _products
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Stream<List<Product>> getMyListings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _products
        .where('sellerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _products.get();
    final all = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    final lowerQuery = query.toLowerCase();
    return all.where((p) =>
        p.title.toLowerCase().contains(lowerQuery) ||
        p.description.toLowerCase().contains(lowerQuery) ||
        p.category.label.toLowerCase().contains(lowerQuery)).toList();
  }

  Future<String> uploadImage(File imageFile) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final ref = _storage.ref().child('product_images/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> addProduct(Product product) async {
    await _products.add(product.toFirestore());
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _products.doc(id).update(data);
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}