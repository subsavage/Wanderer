import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/providers/chat_provider.dart';
import 'package:wanderer/utils/colors.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatHistoryProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - index - 1];
        final isUser = message.role == MessageRole.user;

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                isUser ? 'You' : 'Itera AI',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.buttonBg : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 15,
                    color: isUser ? Colors.white : Colors.black87,
                    fontStyle:
                        message.isPartial ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
