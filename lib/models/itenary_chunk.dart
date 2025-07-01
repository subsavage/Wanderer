class ItineraryChunk {
  final String content;
  final bool isFinal;

  ItineraryChunk(this.content, {this.isFinal = false});

  /// Parse a single JSON chunk from Gemini
  factory ItineraryChunk.fromJson(Map<String, dynamic> json) {
    // Gemini’s streaming chunk might look like:
    // { "choices": [ { "delta": { "function_call": {...} }, "finish_reason": null } ] }
    final choice = (json['choices'] as List).first;
    final delta = choice['delta'] as Map<String, dynamic>;

    // You can extract function_call arguments here. For now, we grab raw text.
    final text = delta['content'] as String? ?? '';
    final done = choice['finish_reason'] == 'function_call';

    return ItineraryChunk(text, isFinal: done);
  }
}
