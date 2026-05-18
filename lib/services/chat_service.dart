import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Chat>> getMyChats() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList());
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  Future<String> getOrCreateChat({
    required String productId,
    required String productTitle,
    required String productImage,
    required double productPrice,
    required String sellerId,
    required String sellerName,
  }) async {
    final uid = _auth.currentUser!.uid;
    final userName = _auth.currentUser!.displayName ?? 'User';

    final existing = await _firestore
        .collection('chats')
        .where('productId', isEqualTo: productId)
        .where('buyerId', isEqualTo: uid)
        .get();

    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id;
    }

    final chatDoc = await _firestore.collection('chats').add({
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'productPrice': productPrice,
      'buyerId': uid,
      'buyerName': userName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'participants': [uid, sellerId],
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    return chatDoc.id;
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    String? imageUrl,
  }) async {
    final uid = _auth.currentUser!.uid;
    final userName = _auth.currentUser!.displayName ?? 'User';

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'chatId': chatId,
      'senderId': uid,
      'senderName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }
}