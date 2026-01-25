// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:logger/web.dart';
// import 'package:progress_pals/core/theme/app_colors.dart';
// import 'package:progress_pals/presentation/widgets/app_button.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = FirebaseAuth.instance.currentUser;
//   }

//   Future<void> _logout() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 try {
//                   await FirebaseAuth.instance.signOut();
//                   if (mounted) {
//                     context.go('/');
//                   }
//                 } catch (e) {
//                   Logger().e('Error logging out: $e');
//                 }
//               },
//               child: const Text('Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Profile Avatar
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       AppColors.primary,
//                       AppColors.primary.withValues(alpha: 0.6),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _currentUser?.email?.isNotEmpty == true
//                         ? _currentUser!.email![0].toUpperCase()
//                         : 'U',
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // User Email
//               Text(
//                 _currentUser?.email ?? 'No email',
//                 style: const TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _currentUser?.displayName ?? 'User',
//                 style: const TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Account Info Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.divider, width: 1.5),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Account Information',
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildInfoRow('Email:', _currentUser?.email ?? 'N/A'),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'User ID:',
//                       _currentUser?.uid.substring(0, 8) ?? 'N/A',
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'Account Created:',
//                       _currentUser?.metadata.creationTime?.toString().split(
//                             '.',
//                           )[0] ??
//                           'N/A',
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'Email Verified:',
//                       _currentUser?.emailVerified == true ? 'Yes' : 'No',
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Preferences Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.divider, width: 1.5),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Preferences',
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Dark Mode',
//                           style: TextStyle(
//                             color: AppColors.textPrimary,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Switch(
//                           value: false,
//                           onChanged: (value) {
//                             setState(() {});
//                           },
//                           activeThumbColor: AppColors.primary,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Logout Button
//               AppButton(
//                 text: 'Logout',
//                 type: ButtonType.outline,
//                 onPressed: _logout,
//               ),
//               const SizedBox(height: 16),

//               // Version Info
//               Text(
//                 'Version 1.0.0',
//                 style: TextStyle(color: Colors.grey[500], fontSize: 12),
//               ),

//               const SizedBox(height: 120),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             style: const TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }
