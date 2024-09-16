import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChattingScreen extends StatefulWidget {
  final String otherUserName; // Add username parameter
  final String otherUserProfilePic; // Add profile picture URL

  const ChattingScreen({
    Key? key,
    required this.otherUserName,
    required this.otherUserProfilePic,
  }) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  late final WebViewController _controller;
  String url = 'http://192.168.50.226:3000';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(Uri.parse(url)); // Load the initial URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(
          color: Colors.black, // Make the back button black like Instagram
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUserProfilePic.isNotEmpty
                  ? NetworkImage(widget.otherUserProfilePic)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
              radius: 18,
            ),
            const SizedBox(width: 10), // Space between avatar and username
            Expanded(
              child: Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false, // Aligns the title to the left like Instagram
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
