import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/screens/itenary_screen.dart';
import 'package:wanderer/utils/colors.dart';
import 'package:wanderer/providers/chat_provider.dart';

class Chatbubble extends ConsumerStatefulWidget {
  const Chatbubble({super.key});

  @override
  ConsumerState<Chatbubble> createState() => _ChatbubbleState();
}

class _ChatbubbleState extends ConsumerState<Chatbubble> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ItineraryScreen(userInput: text)),
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat input bubble
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.buttonBg, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          constraints: const BoxConstraints(minHeight: 200, maxWidth: 350),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Describe your dream trip...",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
                ),
              ),

              // Mic icon (bottom-right inside bubble)
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    // TODO: Add mic input logic later
                  },
                  icon: Icon(Icons.mic, color: AppColors.buttonBg),
                ),
              ),
            ],
          ),
        ),

        // Send button (below bubble)
        ElevatedButton(
          onPressed: _sendMessage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBg,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            "Create My Itenary",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Inter",
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
