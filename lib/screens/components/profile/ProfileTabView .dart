// import 'package:flutter/material.dart';
// import 'package:kkh_events/api/routes/profile.dart';
// import 'package:kkh_events/api/routes/profile_post.dart';
// import 'package:video_player/video_player.dart';

// class ProfileTabView extends StatelessWidget {
//   final ProfilePostAPI profilePostData;
//   final User user;

//   const ProfileTabView(
//       {Key? key, required this.profilePostData, required this.user})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           const TabBar(
//             indicatorColor: Colors.black,
//             tabs: [
//               Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
//               Tab(icon: Icon(Icons.list, color: Colors.black)),
//             ],
//           ),
//           SizedBox(
//             height: 400, // Limit the height for proper scrolling
//             child: TabBarView(
//               children: [
//                 GridView.builder(
//                   itemCount: profilePostData.posts?.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 2,
//                     mainAxisSpacing: 2,
//                   ),
//                   itemBuilder: (context, index) {
//                     final post = profilePostData.posts?[index];
//                     return GestureDetector(
//                       onLongPress: () => _showInstagramCard(
//                           context, post?.mediaUrl ?? '', post?.mediaType == 'video'),
//                       onTap: () => _openPostScroll(
//                           context, post?.mediaUrl ?? '', isVideo: post?.mediaType == 'video'),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(post?.mediaUrl ?? ''),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListView.builder(
//                   itemCount: profilePostData.posts?.length,
//                   itemBuilder: (context, index) {
//                     final post = profilePostData.posts?[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(user.profilePic ?? ''),
//                       ),
//                       title: Text(post?.content ?? 'No content'),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showInstagramCard(BuildContext context, String mediaUrl, bool isVideo) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(user.profilePic ?? ''),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(user.username ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.more_vert),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               isVideo
//                   ? VideoThumbnail(videoUrl: mediaUrl)
//                   : Image.network(mediaUrl),
//               const SizedBox(height: 10),
//               Text(
//                 profilePostData.posts?.first.content ?? '',
//                 style: const TextStyle(color: Colors.black),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _openPostScroll(BuildContext context, String initialMediaUrl, {bool isVideo = false}) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PostScrollView(
//           posts: profilePostData.posts,
//           initialIndex: profilePostData.posts
//                   ?.indexWhere((post) => post.mediaUrl == initialMediaUrl) ??
//               0,
//           isVideo: isVideo,
//           user: user,
//         ),
//       ),
//     );
//   }
// }

// class PostScrollView extends StatelessWidget {
//   final List<Posts> posts;
//   final int initialIndex;
//   final bool isVideo;
//   final ProfileUser? user;

//   const PostScrollView(
//       {Key? key,
//       required this.posts,
//       required this.initialIndex,
//       this.user,
//       this.isVideo = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: PageView.builder(
//         itemCount: posts.length,
//         controller: PageController(initialPage: initialIndex),
//         itemBuilder: (context, index) {
//           final post = posts[index];
//           return Column(
//             children: [
//               AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: isVideo
//                     ? VideoThumbnail(videoUrl: post.mediaUrl ?? '')
//                     : Image.network(post.mediaUrl ?? '', fit: BoxFit.cover),
//               ),
//               Container(
//                 color: Colors.black,
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(user?.profilePic ?? ''),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(user?.username ?? '',
//                         style: const TextStyle(color: Colors.white)),
//                     const Spacer(),
//                     IconButton(
//                       icon: const Icon(Icons.favorite_border,
//                           color: Colors.white),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.comment_outlined,
//                           color: Colors.white),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       icon:
//                           const Icon(Icons.share_outlined, color: Colors.white),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class VideoThumbnail extends StatefulWidget {
//   final String videoUrl;
//   const VideoThumbnail({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   _VideoThumbnailState createState() => _VideoThumbnailState();
// }

// class _VideoThumbnailState extends State<VideoThumbnail> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {}); // Update the UI when the video is initialized
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: () {
//         setState(() {
//           _isPlaying = true;
//           _controller.play();
//         });
//       },
//       onLongPressUp: () {
//         setState(() {
//           _isPlaying = false;
//           _controller.pause();
//         });
//       },
//       onTap: () {
//         // _openPostScroll(context, widget.videoUrl, isVideo: true);
//       },
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Show the video thumbnail
//           _controller.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               : const CircularProgressIndicator(),
//           if (!_isPlaying)
//             const Icon(Icons.play_circle_outline,
//                 size: 50, color: Colors.white),
//         ],
//       ),
//     );
//   }
// }
