import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.bgColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Hey Shubham 👋",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            SizedBox(height: 20),
            Chatbubble(),
            SizedBox(height: 25),
            Text(
              "Offline Saved Itineraries",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),

            Expanded(child: const ChatList()),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
