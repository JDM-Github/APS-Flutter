// import 'package:flutter/material.dart';

// class UserInfoSection extends StatelessWidget {
//   const UserInfoSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color.fromARGB(255, 80, 160, 170), // Base color
//             Color.fromARGB(
//                 255, 40, 120, 130), // A darker shade for the gradient
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: const Row(
//         children: [
//           // Profile Picture
//           CircleAvatar(
//             radius: 35,
//             backgroundImage: AssetImage('assets/user.png'),
//             backgroundColor: Colors.white,
//           ),
//           SizedBox(width: 15),

//           // User Details
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.person, color: Colors.white70, size: 18),
//                   SizedBox(width: 5),
//                   Text(
//                     'John Doe',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.work_outline, color: Colors.white70, size: 18),
//                   SizedBox(width: 5),
//                   Text(
//                     'Project Manager',
//                     style: TextStyle(fontSize: 14, color: Colors.white70),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.badge, color: Colors.white70, size: 18),
//                   SizedBox(width: 5),
//                   Text(
//                     'ID: 1245345',
//                     style: TextStyle(fontSize: 14, color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
