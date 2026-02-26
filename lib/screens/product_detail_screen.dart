import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.network(product.image, fit: BoxFit.cover),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
            ],
          ),
          Positioned(
            top: 60,
            left: 24,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Row(
                            children: List.generate(5, (index) => Icon(Icons.star, size: 16, color: index < product.rating ? AppColors.accent : Colors.grey.shade300)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _DetailBadge(icon: Icons.straighten, label: product.size),
                          _DetailBadge(icon: Icons.eco_outlined, label: product.type),
                          _DetailBadge(icon: Icons.scale_outlined, label: product.weight),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Product Description', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('\$${product.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      PlantifyButton(
                        text: 'Add to cart',
                        isFullWidth: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(border: Border.all(color: AppColors.primary.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
