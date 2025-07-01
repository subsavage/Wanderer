import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/models/itenary_chunk.dart';

/// Provider to fetch the singleton AgentClient
final agentClientProvider = Provider((_) => AgentClient());

class AgentClient {
  AgentClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.gemini.example', // ← your real endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer AIzaSyCoQHkHfIJXmP1f0aQhWoUqbmPS8lRyh9w',
        },
      ),
    );
  }

  late final Dio _dio;

  /// Function schema for your itinerary (Spec A)
  static const _itineraryFunction = {
    'name': 'generate_itinerary',
    'description': 'Creates a day-by-day trip plan',
    'parameters': {
      'type': 'object',
      'properties': {
        'title': {'type': 'string'},
        'startDate': {'type': 'string', 'format': 'date'},
        'endDate': {'type': 'string', 'format': 'date'},
        'days': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'date': {'type': 'string', 'format': 'date'},
              'summary': {'type': 'string'},
              'items': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'time': {'type': 'string'},
                    'activity': {'type': 'string'},
                    'location': {'type': 'string'},
                  },
                  'required': ['time', 'activity', 'location'],
                },
              },
            },
            'required': ['date', 'summary', 'items'],
          },
        },
      },
      'required': ['title', 'startDate', 'endDate', 'days'],
    },
  };

  /// Streams itinerary chunks from Gemini.
  ///
  /// [prompt] is the user’s text; [history] is your List<ChatMessage>.
  Stream<ItineraryChunk> streamItinerary(
    String prompt,
    List<ChatMessage> history,
  ) async* {
    // build the message list for the LLM
    final messages = [
      for (final m in history) m.toApiMap(),
      {'role': 'user', 'content': prompt},
    ];

    final payload = {
      'model': 'gemini-text-1',
      'messages': messages,
      'functions': [_itineraryFunction],
      'function_call': {'name': 'generate_itinerary'},
      'stream': true,
    };

    final response = await _dio.post<ResponseBody>(
      '/v1/chat/completions',
      data: jsonEncode(payload),
      options: Options(responseType: ResponseType.stream),
    );

    // **Fix**: response.data!.stream is Stream<Uint8List>
    await for (final chunk in response.data!.stream) {
      // Decode the bytes into a String
      final raw = utf8.decode(chunk);

      // Split into lines (SSE‐style) and parse each JSON object
      for (final line in raw.split('\n')) {
        if (line.trim().isEmpty) continue;
        final Map<String, dynamic> map = jsonDecode(line);
        yield ItineraryChunk.fromJson(map);
      }
    }
  }
}
