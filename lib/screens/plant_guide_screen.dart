import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class PlantGuideScreen extends StatelessWidget {
  const PlantGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Guide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _GuideCard(
            title: 'Dracaena trifasciata',
            image: 'https://picsum.photos/seed/guide1/600/400',
            desc:
            'Dracaena trifasciata is a species of flowering plant in the family Asparagaceae, native to tropical West Africa. It is most commonly known as the snake plant, Saint George\'s sword, and mother-in-law\'s tongue.',
          ),
          SizedBox(height: 32),
          _GuideCard(
            title: 'Aloe vera',
            image: 'https://picsum.photos/seed/guide2/600/400',
            desc:
            'Aloe vera is a succulent plant species of the genus Aloe. It originates from the Arabian Peninsula and grows in tropical and semi-tropical climates around the world.',
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String image;
  final String desc;

  const _GuideCard({
    required this.title,
    required this.image,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // ✅ Correct clipping
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: PlantifyButton(
                    text: 'Know More',
                    isFullWidth: false,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}