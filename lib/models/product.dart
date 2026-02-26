import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String image;
  final String category;
  final String description;
  final String size;
  final String type;
  final String weight;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
    this.description = "Bonsai is the Japanese art of growing and shaping miniature trees in containers...",
    this.size = "10cm",
    this.type = "new",
    this.weight = "125gm",
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
