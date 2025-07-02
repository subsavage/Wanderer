import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';

class Agent {
  void chatWithGemini() {
    Gemini.instance
        .chat([
          Content(
            parts: [
              Part.text(
                'Write the first line of a story about a magic backpack.',
              ),
            ],
            role: 'user',
          ),
          Content(
            parts: [
              Part.text(
                'In the bustling city of Meadow brook, lived a young girl named Sophie. She was a bright and curious soul with an imaginative mind.',
              ),
            ],
            role: 'model',
          ),
          Content(
            parts: [
              Part.text('Can you set it in a quiet village in 1600s France?'),
            ],
            role: 'user',
          ),
        ])
        .then((value) {
          log(value?.output ?? 'No output received');
        })
        .catchError((e) {
          log('Error in Gemini chat', error: e);
        });
  }
}
