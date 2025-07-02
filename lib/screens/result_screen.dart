// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/providers/chat_provider.dart';
import 'package:wanderer/utils/colors.dart';
import 'package:wanderer/widgets/chat_input.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final String userInput;
  const ResultScreen({super.key, required this.userInput});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool _chatMode = false;
  final TextEditingController _followUpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // send the initial itinerary request
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatHistoryProvider.notifier).sendMessage(widget.userInput);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatHistoryProvider);
    final assistant = messages.lastWhere(
      (m) => m.role == MessageRole.assistant,
      orElse: () => ChatMessage.assistant("", isPartial: false),
    );
    final isLoading = messages.isEmpty || assistant.isPartial;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          "Wanderer AI",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: AppColors.buttonBg,
            child: const Text("S", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1) Show the two-card “chat history”:
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonBg,
                        ),
                      )
                      : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: [
                          _buildMessageCard(
                            isUser: true,
                            content: widget.userInput,
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: () {
                                  /* copy widget.userInput */
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildMessageCard(
                            isUser: false,
                            content: assistant.content,
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: () {
                                  /* copy assistant.content */
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.download_for_offline,
                                  size: 20,
                                ),
                                onPressed: () {
                                  /* save offline */
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 20),
                                onPressed: () {
                                  // regenerate entire itinerary
                                  ref.read(chatHistoryProvider.notifier)
                                    ..clear()
                                    ..sendMessage(widget.userInput);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
            ),

            // 2) Bottom area: either the two big buttons or the ChatInput
            Padding(
              padding: const EdgeInsets.all(16),
              child:
                  _chatMode
                      ? ChatInput(
                        controller: _followUpController,
                        onSend: (text) {
                          // send the follow-up, then exit chatMode
                          ref
                              .read(chatHistoryProvider.notifier)
                              .sendMessage(text);
                          setState(() => _chatMode = false);
                          _followUpController.clear();
                        },
                      )
                      : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonBg,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () => setState(() => _chatMode = true),
                              child: Text(
                                "Follow up to refine",
                                style: TextStyle(color: AppColors.bgColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                side: BorderSide(color: AppColors.buttonBg),
                              ),
                              onPressed: () {
                                // save offline logic
                              },
                              child: const Text("Save Offline"),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard({
    required bool isUser,
    required String content,
    required List<Widget> actions,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? "You" : "Itinera AI",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(mainAxisSize: MainAxisSize.min, children: actions),
          ],
        ),
      ),
    );
  }
}
