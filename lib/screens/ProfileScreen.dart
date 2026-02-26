import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String profilePicUrl = 'https://picsum.photos/seed/user/100/100'; // Default image
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userData = await fetchUserProfile();
    setState(() {
      userName = userData['name'] ?? 'Unknown';
      userEmail = userData['email'] ?? 'Not provided';
      profilePicUrl = userData['profile_picture'] ?? 'https://picsum.photos/seed/default/100/100';
      loading = false;
    });
  }

  Future<Map<String, String>> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data()!;
          return {
            'name': userData['name'] ?? 'Unknown',
            'email': userData['email'] ?? 'Not provided',
            'profile_picture': userData['profile_picture'] ?? 'https://picsum.photos/seed/default/100/100',
          };
        } else {
          return {
            'name': 'Guest',
            'email': 'No email available',
            'profile_picture': 'https://picsum.photos/seed/guest/100/100',
          };
        }
      } catch (e) {
        print("Error fetching user data: $e");
        return {
          'name': 'Error fetching data',
          'email': 'Error',
          'profile_picture': 'https://picsum.photos/seed/error/100/100',
        };
      }
    } else {
      return {
        'name': 'Guest',
        'email': 'Not logged in',
        'profile_picture': 'https://picsum.photos/seed/guest/100/100',
      };
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(profilePicUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(userEmail,
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Profile options
              _ProfileOption(
                icon: Icons.person_outline,
                label: 'Account Details',
                onTap: () {
                  // Navigate to account details if needed
                },
              ),
              _ProfileOption(
                icon: Icons.shopping_cart_outlined,
                label: 'Orders',
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              _ProfileOption(
                icon: Icons.favorite_border,
                label: 'Favourites',
                onTap: () {
                  Navigator.pushNamed(context, '/favourites');
                },
              ),
              _ProfileOption(
                icon: Icons.book_outlined,
                label: 'Plant Guide',
                onTap: () {
                  Navigator.pushNamed(context, '/plant_guide');
                },
              ),
              _ProfileOption(
                icon: Icons.notifications_none,
                label: 'Notifications',
                onTap: () {
                  // Navigate to notifications if available
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  label: const Text('Logout',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ProfileOption({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}