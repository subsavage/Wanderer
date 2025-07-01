import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/agent/agent_client.dart';
import 'package:wanderer/models/chat_message.dart';

/// Holds the chat history and streams in assistant chunks.
final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>(
      (ref) => ChatHistoryNotifier(ref),
    );

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref ref;
  ChatHistoryNotifier(this.ref) : super([]);

  Future<void> sendMessage(String text) async {
    // 1) Append user message
    state = [...state, ChatMessage.user(text)];

    // 2) Stream assistant response
    final stream = ref.read(agentClientProvider).streamItinerary(text, state);

    await for (final chunk in stream) {
      // Remove any previous partial message
      final withoutOld =
          state.where((m) => m.role != MessageRole.assistant).toList();
      // Append new partial
      state = [
        ...withoutOld,
        ChatMessage.assistant(chunk.content, isPartial: !chunk.isFinal),
      ];
    }
  }

  void clear() => state = [];
}
