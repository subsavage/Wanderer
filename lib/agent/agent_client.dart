// lib/agent/agent_client.dart
import 'package:flutter_gemini/flutter_gemini.dart';

class AgentClient {
  /// Sends the user’s query as a single prompt (no roles).
  Future<String> getItinerary(String userQuery) async {
    // 1) Build a single prompt that includes your “system” instructions
    final promptText = '''
You are Wanderer, an AI travel planner. 
When the user gives you a location or budget,
you output a day‐by‐day itinerary.

${userQuery.trim()}
''';

    // 2) Call the one‐shot prompt API
    final resp = await Gemini.instance.prompt(parts: [Part.text(promptText)]);

    // 3) Return the text output (or an empty string)
    return resp?.output?.trim() ?? '';
  }
}
