import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'your_username', // Replace with dynamic username
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            color: Colors.black,
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.black,
            onPressed: () {
              // Handle new message action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: () {
              // Handle more options action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.black),
                    onPressed: () {
                      // Handle filter action
                    },
                  ),
                ),
              ],
            ),
          ),
          // Categories (Primary, General, Channels, Requests)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton(context, 'Primary', isSelected: true),
                _buildCategoryButton(context, 'General'),
                _buildCategoryButton(context, 'Channels'),
                _buildCategoryButton(context, 'Requests'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey, height: 1),
          // Chats List
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual chat count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg', // Replace with actual user's avatar
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Username', // Replace with actual username
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '12:34 PM', // Replace with actual timestamp
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Last message goes here...', // Replace with actual last message
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () {
                    // Handle chat tap to open conversation
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label,
      {bool isSelected = false}) {
    return TextButton(
      onPressed: () {
        // Handle category selection
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
