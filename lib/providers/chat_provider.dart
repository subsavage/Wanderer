// chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>(
      (ref) => ChatHistoryNotifier(),
    );

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  ChatHistoryNotifier() : super([]);

  /// Sends a single‐shot request and appends the full reply.
  Future<void> sendMessage(String text) async {
    // 1) record the user’s query
    state = [...state, ChatMessage.user(text)];

    try {
      // 2) fire off Gemini.prompt and await the complete response
      final geminiResp = await Gemini.instance.prompt(parts: [Part.text(text)]);
      final reply = geminiResp?.output ?? '';

      // 3) append the assistant’s reply (final)
      state = [...state, ChatMessage.assistant(reply, isPartial: false)];
    } catch (err) {
      state = [
        ...state,
        ChatMessage.assistant(
          "Sorry, I ran into an error: $err",
          isPartial: false,
        ),
      ];
    }
  }

  /// If you’d rather show a streaming “building…” effect:
  Future<void> sendMessageStream(String text) async {
    state = [...state, ChatMessage.user(text)];

    // listen to partial outputs
    await for (final chunk in Gemini.instance.promptStream(
      parts: [Part.text(text)],
    )) {
      final partial = chunk?.output ?? '';
      final withoutOld = state.where((m) => m.role != MessageRole.assistant);
      state = [...withoutOld, ChatMessage.assistant(partial, isPartial: true)];
    }

    // mark final (replace the last partial with isPartial=false)
    final lastContent = state.last.content;
    final withoutOld = state.where((m) => m.role != MessageRole.assistant);
    state = [
      ...withoutOld,
      ChatMessage.assistant(lastContent, isPartial: false),
    ];
  }

  void clear() => state = [];
}
