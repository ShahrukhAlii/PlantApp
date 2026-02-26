import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class CartItemModel {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItemModel({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> cart = [
    CartItemModel(
        name: 'Potted Cacti',
        price: 9.99,
        image: 'https://picsum.photos/seed/cactus/200/200'),
    CartItemModel(
        name: 'Long Leaf',
        price: 9.99,
        image: 'https://picsum.photos/seed/leaf/200/200'),
    CartItemModel(
        name: 'Hangable Plant',
        price: 9.99,
        image: 'https://picsum.photos/seed/hang/200/200'),
  ];

  double get subtotal =>
      cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get discount => subtotal > 30 ? 7.99 : 0;

  double get total => subtotal - discount;

  void increaseQty(int index) {
    setState(() {
      cart[index].quantity++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: cart.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shopping_cart_outlined,
                  size: 80, color: AppColors.primary),
              SizedBox(height: 20),
              Text(
                'Your cart is empty!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return _CartItem(
                    item: item,
                    onAdd: () => increaseQty(index),
                    onRemove: () => decreaseQty(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _SummaryRow(
                label: 'Subtotal',
                value: '\$${subtotal.toStringAsFixed(2)}'),
            _SummaryRow(
                label: 'Discount',
                value: '-\$${discount.toStringAsFixed(2)}'),
            const Divider(height: 30),
            _SummaryRow(
                label: 'Total',
                value: '\$${total.toStringAsFixed(2)}',
                isTotal: true),
            const SizedBox(height: 20),
            PlantifyButton(text: 'Proceed', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartItem({
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.image,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('\$${item.price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ],
            ),
          ),
          Row(
            children: [
              _QtyBtn(icon: Icons.remove, onTap: onRemove),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12),
                child: Text(item.quantity.toString(),
                    style:
                    const TextStyle(fontWeight: FontWeight.bold)),
              ),
              _QtyBtn(icon: Icons.add, onTap: onAdd, isPrimary: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _QtyBtn({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border:
          isPrimary ? null : Border.all(color: AppColors.primary),
        ),
        child: Icon(icon,
            size: 14,
            color:
            isPrimary ? Colors.white : AppColors.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color:
                  isTotal ? AppColors.primary : Colors.grey,
                  fontWeight: isTotal
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: isTotal ? 18 : 14)),
          Text(value,
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isTotal ? 18 : 14)),
        ],
      ),
    );
  }
}