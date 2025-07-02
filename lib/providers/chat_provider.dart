import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/agent/agent_client.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/providers/agent_client_provider.dart';

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>(
      (ref) => ChatHistoryNotifier(ref),
    );

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  ChatHistoryNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> sendMessage(String text) async {
    state = [...state, ChatMessage.user(text)];

    try {
      final itinerary = await ref.read(agentClientProvider).getItinerary(text);
      state = [...state, ChatMessage.assistant(itinerary, isPartial: false)];
    } catch (e) {
      state = [
        ...state,
        ChatMessage.assistant(
          "Oops, something went wrong: $e",
          isPartial: false,
        ),
      ];
    }
  }

  void clear() => state = [];
}
