import 'package:flutter/material.dart';
import 'package:kkh_events/api/routes/chatid.dart';
import 'package:kkh_events/screens/chatiing_screen.dart';

class ChatScreen extends StatefulWidget {
  final int userId;

  const ChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<ChatIdAPI>> _chatListFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch the chat list when the widget is initialized
    _chatListFuture = ChatIdAPI.chatlist(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Handle edit button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ChatIdAPI>>(
              future: _chatListFuture, // The future that fetches the chat list
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading spinner while data is being fetched
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle any errors
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Show message when there are no chats
                  return const Center(child: Text('No chats found.'));
                } else {
                  // Extract the chat list
                  final chatList = snapshot.data!
                      .where((chat) => chat.otherUser!.username!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: chatList.length, // Number of chat items
                    itemBuilder: (context, index) {
                      final chat = chatList[index];
                      final otherUser = chat.otherUser;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            // Navigate to ChattingScreen and pass the user IDs
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChattingScreen(
                                    // userId: widget.userId,
                                    // otherUserId: otherUser!.id!,
                                    otherUserName: otherUser!.username!,
                                    otherUserProfilePic: otherUser.profilePic!),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: otherUser!.profilePic != null
                                    ? NetworkImage(otherUser.profilePic!)
                                    : const AssetImage(
                                            'assets/default_avatar.png')
                                        as ImageProvider, // Fallback image
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          otherUser.username ?? 'Unknown',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          chat.lastMessageTime ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      chat.lastMessage ?? 'No messages yet',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
