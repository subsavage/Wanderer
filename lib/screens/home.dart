import 'package:flutter/material.dart';
import 'package:wanderer/utils/colors.dart';
import 'package:wanderer/widgets/chat_list.dart';
import 'package:wanderer/widgets/chatbubble.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: Text(
          "Hey Shubham 👋",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "What’s your vision for this trip?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Chatbubble(),
          Expanded(child: const ChatList()),
          Spacer(),
        ],
      ),
    );
  }
}
