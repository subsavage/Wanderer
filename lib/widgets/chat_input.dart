import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final void Function(String) onSend;
  final TextEditingController controller;

  const ChatInput({super.key, required this.onSend, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(minHeight: 200, maxWidth: 350),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Refine your itinerary...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  onSend(text);
                  controller.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }
}
