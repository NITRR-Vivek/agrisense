import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';

import 'cart_screen.dart';

class ShopScreen extends StatelessWidget {
  final List<Product> products = [
    Product('Tomato Seeds', 'assets/images/tomato_seeds.jpeg', 10.0),
    Product('Corn Seeds', 'assets/images/corn_seeds.png', 15.0),
    Product('Wheat Fertilizer', 'assets/images/wheat_fertilizer.png', 20.0),
    Product('Tractor Oil', 'assets/images/tractor_oil.jpeg', 25.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    product.image,
                    width: 80,  // Increased width for a bigger image
                    height: 80,  // Increased height for a bigger image
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),  // Increased space between image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\₹${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart action
                      Cart.addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the cart screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        },
        backgroundColor: AppColors.darkAppColor300,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class Product {
  final String name;
  final String image;
  final double price;

  Product(this.name, this.image, this.price);
}
