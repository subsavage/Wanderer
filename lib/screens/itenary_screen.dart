import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/models/chat_message.dart';
import 'package:wanderer/providers/chat_provider.dart';
import 'package:wanderer/utils/colors.dart';

class ItineraryScreen extends ConsumerStatefulWidget {
  final String userInput;

  const ItineraryScreen({super.key, required this.userInput});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  bool isLoading = true;
  String resultText = "";

  @override
  void initState() {
    super.initState();
    _startGenerating();
  }

  Future<void> _startGenerating() async {
    final notifier = ref.read(chatHistoryProvider.notifier);

    await notifier.sendMessage(widget.userInput);

    // Get final assistant message from state
    final allMessages = ref.read(chatHistoryProvider);
    final last = allMessages.lastWhere((m) => m.role == MessageRole.assistant);

    setState(() {
      resultText = last.content;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: const Text("Home"),
      ),
      body: Center(
        child:
            isLoading
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Curating a perfect plan for you...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Itinerary Created 🌴",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            resultText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
