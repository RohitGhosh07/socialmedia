import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              // Replace with notification icon
              backgroundColor: Colors.grey,
              // You can use an image or an icon here
              // Example: child: Icon(Icons.notification),
            ),
            title: Text(
              'Notification Title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Notification message'),
            trailing: Text('Time'), // Replace with notification time
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
    );
  }
}
