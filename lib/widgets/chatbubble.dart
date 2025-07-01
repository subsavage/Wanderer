import 'package:flutter/material.dart';
import 'package:wanderer/utils/colors.dart';

class Chatbubble extends StatelessWidget {
  const Chatbubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.buttonBg, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(minHeight: 150, maxWidth: 300),
      child: Stack(
        children: [
          // Text input
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
            child: TextField(
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Describe your dream trip...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
            ),
          ),

          // Mic Icon
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                // TODO: Handle mic input
              },
              icon: Icon(Icons.mic, color: AppColors.buttonBg),
            ),
          ),
        ],
      ),
    );
  }
}
