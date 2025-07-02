import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/providers/chat_provider.dart';
import 'package:wanderer/utils/colors.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatHistoryProvider);
    final assistantMessage = messages.lastWhere(
      (m) => m.role == MessageRole.assistant,
      orElse: () => ChatMessage.assistant(""),
    );

    final isLoading = assistantMessage.isPartial;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: const Text(
          "Your Itinerary",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child:
            isLoading
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonBg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Wanderer is crafting your journey...",
                      style: TextStyle(fontSize: 18, fontFamily: "Inter"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                : SingleChildScrollView(
                  child: Text(
                    assistantMessage.content,
                    style: const TextStyle(fontSize: 16, fontFamily: "Inter"),
                  ),
                ),
      ),
    );
  }
}
