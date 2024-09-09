import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomNotification {
  static void show(BuildContext context, String message) {
    OverlayEntry? overlayEntry; // Nullable declaration

    overlayEntry = OverlayEntry(
      builder: (context) => NotificationWidget(
        message: message,
        onDismissed: () {
          if (overlayEntry != null) {
            overlayEntry.remove();
          }
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class NotificationWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const NotificationWidget({
    Key? key,
    required this.message,
    required this.onDismissed,
  }) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start off the top of the screen
      end: Offset.zero, // End at its normal position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation

    Future.delayed(const Duration(seconds: 4), () {
      _controller.reverse(); // Reverse the animation
      Future.delayed(const Duration(milliseconds: 500),
          widget.onDismissed); // Remove the widget after reverse animation
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.0, // Position it near the top
      left: MediaQuery.of(context).size.width * 0.1, // Center horizontally
      right: MediaQuery.of(context).size.width * 0.1,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
