// import 'package:flutter/material.dart';
// import 'package:kkh_events/api/routes/jumbledPost.dart';
// import 'package:kkh_events/api/routes/profile_post.dart';
// import 'package:video_player/video_player.dart';
// import 'package:kkh_events/screens/profile_screen.dart';
// import 'package:kkh_events/screens/reel_screen.dart';

// class PostView extends StatelessWidget {
//   final String? profilePic;
//   final String? username;
//   final String? mediaUrl;
//   final String? mediaType;
//   final String? content;
//   final String? createdAt;
//   final int? userId;
//   final String? likeCount;
//   final String? commentCount;
//   final int mainUserId;
//   final int index;
//   final List<dynamic> posts;

//   const PostView({
//     Key? key,
//     required this.profilePic,
//     required this.username,
//     required this.mediaUrl,
//     required this.mediaType,
//     required this.content,
//     required this.createdAt,
//     required this.userId,
//     required this.likeCount,
//     required this.commentCount,
//     required this.mainUserId,
//     required this.index,
//     required this.posts,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(profilePic ?? ''),
//           ),
//           title: Text(
//             username ?? '',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           trailing: const Icon(Icons.more_vert),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProfileScreen(
//                   userId: userId,
//                   mainuserId: mainUserId,
//                 ),
//               ),
//             );
//           },
//         ),
//         mediaType == 'video' && mediaUrl != null && mediaUrl!.isNotEmpty
//             ? GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ReelScreen(
//                         reels: posts.where((post) {
//                           return (post is Posts || post is JumbledPostAPI) &&
//                               (post.mediaType == 'video');
//                         }).map((post) {
//                           return {
//                             'mediaUrl': post.mediaUrl as String?,
//                             'username': post.username as String?,
//                             'profilePic': post.profilePic as String?,
//                             'content': post.content as String?,
//                             'createdAt': post.createdAt as String?,
//                           };
//                         }).toList(),
//                         initialIndex: index,
//                       ),
//                     ),
//                   );
//                 },
//                 // child: _buildVideoPlayer(index, mediaUrl!),
//               )
//             : mediaUrl != null && mediaUrl!.isNotEmpty
//                 ? Image.network(
//                     mediaUrl!,
//                     height: 400,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   )
//                 : _buildBrokenImage(),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.favorite_border),
//                 onPressed: () {
//                   // Handle like logic
//                 },
//               ),
//               Text(likeCount ?? '0'),
//               IconButton(
//                 icon: const Icon(Icons.comment),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () {},
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const Icon(Icons.bookmark_border),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Liked by user1 and others',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 '${username ?? 'User'}: ${content ?? 'Great picture!'}',
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'View all comments',
//                 style: TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 createdAt ?? '5 minutes ago',
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

// //  Widget _buildVideoPlayer(int index, String videoUrl) {
// //     if (!_videoControllers.containsKey(index)) {
// //       _videoControllers[index] = VideoPlayerController.network(videoUrl)
// //         ..initialize().then((_) {
// //           setState(() {
// //             _videoControllers[index]?.play();
// //           });
// //         }).catchError((error) {
// //           print("Video player error: $error");
// //         });
// //     }

// //     VideoPlayerController controller = _videoControllers[index]!;

// //     return controller.value.isInitialized
// //         ? AspectRatio(
// //             aspectRatio: controller.value.aspectRatio,
// //             child: VideoPlayer(controller),
// //           )
// //         : _buildShimmerEffect();
// //   }

//   Widget _buildBrokenImage() {
//     return Container(
//       height: 400,
//       color: Colors.grey,
//       child: const Center(child: Text('Broken Image')),
//     );
//   }
// }
