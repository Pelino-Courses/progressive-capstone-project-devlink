import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<List<Chat>>(
        stream: chatService.getMyChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data ?? [];
          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: AppTheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('No conversations yet', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text('Message a seller to start chatting!', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherName = currentUid == chat.buyerId ? chat.sellerName : chat.buyerName;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                ),
                title: Text(otherName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.productTitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.secondary)),
                    Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant)),
                  ],
                ),
                trailing: Text(DateFormat('HH:mm').format(chat.lastMessageAt),
                    style: Theme.of(context).textTheme.labelSmall),
                onTap: () {
                  Navigator.pushNamed(context, '/chat', arguments: {
                    'chatId': chat.id,
                    'otherName': otherName,
                    'productTitle': chat.productTitle,
                    'productPrice': '${chat.productPrice.toStringAsFixed(0)} RWF',
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}