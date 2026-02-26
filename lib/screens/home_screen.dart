import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantapp/screens/plant_guide_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'ProfileScreen.dart';
import 'auth/login_screen.dart';
import 'cart_screen.dart';
import 'favouritesScreen.dart';
import 'notification_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNavIndex = 0;
  String _selectedRecommendedTab = 'All';

  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String profilePicUrl =
      'https://picsum.photos/seed/user/100/100'; // Default image

  final List<Map<String, dynamic>> recommendedItems = [
    {
      'name': 'Potted Cacti',
      'image': 'https://picsum.photos/seed/pottedcacti/200/200',
      'price': 9.99,
      'category': 'potted',
    },
    {
      'name': 'Potted Plant',
      'image': 'https://picsum.photos/seed/pottedplant/200/200',
      'price': 9.99,
      'category': 'potted',
    },
    {
      'name': 'Succulent',
      'image': 'https://picsum.photos/seed/succulent/200/200',
      'price': 8.99,
      'category': 'new',
    },
    {
      'name': 'Seed Pack',
      'image': 'https://picsum.photos/seed/seedpack/200/200',
      'price': 4.99,
      'category': 'seed',
    },
  ];

  List<Map<String, dynamic>> get filteredRecommendedItems {
    if (_selectedRecommendedTab.toLowerCase() == 'all') {
      return recommendedItems;
    } else {
      return recommendedItems
          .where((item) =>
      item['category'] ==
          _selectedRecommendedTab.toLowerCase())
          .toList();
    }
  }

  void onBottomNavTap(int index) {


    if (index == _selectedBottomNavIndex) return;
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        break;
      case 1: // Favourites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FavouritesScreen()),
        );
        break;
      case 2: // Menu (optional, maybe drawer)
        Scaffold.of(context).openEndDrawer();
        break;
      case 3: // Cart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
        break;
      case 4: // Profile / User
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen()),
        );
        break;
      default:
        break;
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          setState(() {
            userName = data['name'] ?? user.displayName ?? 'No Name';
            userEmail = data['email'] ?? user.email ?? 'No Email';
            profilePicUrl = data['profile_picture'] ?? user.photoURL ?? '';
          });
        } else {
          setState(() {
            userName = user.displayName ?? 'No Name';
            userEmail = user.email ?? 'No Email';
            profilePicUrl = user.photoURL ?? '';
          });
        }
      } catch (e) {
        setState(() {
          userName = user.displayName ?? 'No Name';
          userEmail = user.email ?? 'No Email';
          profilePicUrl = user.photoURL ?? '';
        });
      }
    } else {
      setState(() {
        userName = 'Guest';
        userEmail = 'Not logged in';
        profilePicUrl = 'https://picsum.photos/seed/guest/100/100';
      });
    }
  }

  void addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart!')),
    );
  }

  // void onBottomNavTap(int index) {
  //   if (index == _selectedBottomNavIndex) return;
  //   setState(() {
  //     _selectedBottomNavIndex = index;
  //   });
  //
  //   switch (index) {
  //     case 0:
  //     // Home, do nothing
  //       break;
  //     case 3: // Cart
  //       Navigator.pushNamed(context, '/cart');
  //       break;
  //     case 5: // Plant guide
  //       Navigator.pushNamed(context, '/plant_guide');
  //       break;
  //     default:
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Page for tab $index not implemented yet')),
  //       );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Menu',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 48),
                _MenuLink(
                  icon: Icons.star_border,
                  label: 'Trending plants',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
                _MenuLink(
                  icon: Icons.history,
                  label: 'Recents',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
                _MenuLink(
                  icon: Icons.favorite_border,
                  label: 'Favourite',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
                _MenuLink(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Your orders',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
                _MenuLink(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationSettingsScreen()),
                    );
                  },
                ),
                _MenuLink(
                  icon: Icons.book_outlined,
                  label: 'Plant guide',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PlantGuideScreen()),
                    );
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  label: const Text('Logout',
                      style: TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: profilePicUrl.isNotEmpty
                            ? NetworkImage(profilePicUrl)
                            : null,
                        child: profilePicUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(userEmail,
                              style:
                              const TextStyle(color: AppColors.primary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                      const SizedBox(width: 16),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: AppColors.primary),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Search bar + filter icon
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search, color: AppColors.primary),
                          suffixIcon: Icon(Icons.mic_none, color: AppColors.primary),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Categories
              _SectionHeader(title: 'Categories', onSeeAll: () {}),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryItem(name: 'Snake Plant', image: 'https://picsum.photos/seed/cat1/200/200'),
                    _CategoryItem(name: 'Semi-shade', image: 'https://picsum.photos/seed/cat2/200/200'),
                    _CategoryItem(name: 'Bonsai', image: 'https://picsum.photos/seed/cat3/200/200'),
                    _CategoryItem(name: 'Cactus', image: 'https://picsum.photos/seed/cat4/200/200'),
                    _CategoryItem(name: 'Miniature', image: 'https://picsum.photos/seed/cat5/200/200'),
                    _CategoryItem(name: 'Small leaf', image: 'https://picsum.photos/seed/cat6/200/200'),
                    _CategoryItem(name: 'Hangable', image: 'https://picsum.photos/seed/cat7/200/200'),
                    _CategoryItem(name: 'Flower', image: 'https://picsum.photos/seed/cat8/200/200'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Today's offer banner
              const _SectionHeader(title: 'Today\'s offer'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('50% OFF',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          Text('Limited Time Offer',
                              style: TextStyle(color: AppColors.primary, fontSize: 14)),
                        ],
                      ),
                    ),
                    Image.network('https://picsum.photos/seed/offer/300/300',
                        width: 100, height: 100),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Recommended for you
              const _SectionHeader(title: 'Recommended for you'),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TabItem(
                        label: 'All',
                        active: _selectedRecommendedTab == 'All',
                        onTap: () {
                          setState(() {
                            _selectedRecommendedTab = 'All';
                          });
                        }),
                    _TabItem(
                        label: 'new',
                        active: _selectedRecommendedTab == 'new',
                        onTap: () {
                          setState(() {
                            _selectedRecommendedTab = 'new';
                          });
                        }),
                    _TabItem(
                        label: 'seed',
                        active: _selectedRecommendedTab == 'seed',
                        onTap: () {
                          setState(() {
                            _selectedRecommendedTab = 'seed';
                          });
                        }),
                    _TabItem(
                        label: 'potted',
                        active: _selectedRecommendedTab == 'potted',
                        onTap: () {
                          setState(() {
                            _selectedRecommendedTab = 'potted';
                          });
                        }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredRecommendedItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredRecommendedItems[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item['image'],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                                  (starIndex) => Icon(
                                Icons.star,
                                size: 14,
                                color: starIndex < 4
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size(double.infinity, 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Add to cart',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Special offer banner
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/seed/giftbox/600/200'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Special Offer\nGift Boxes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.white60,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedBottomNavIndex,
        onTap: onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

// Supporting widgets
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (onSeeAll != null)
          TextButton(
              onPressed: onSeeAll,
              child: const Text('View all',
                  style: TextStyle(color: AppColors.primary, fontSize: 12))),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String image;
  const _CategoryItem({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _MenuLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _MenuLink({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary)
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabItem({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label[0].toUpperCase() + label.substring(1),
          style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
