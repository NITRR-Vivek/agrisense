import 'package:agrisense/presentation/shop_screen/shop.dart';
import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: Cart.products.length,
        itemBuilder: (context, index) {
          final product = Cart.products[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Image.asset(product.image, width: 50, height: 50),
              title: Text(product.name),
              subtitle: Text('\₹${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    Cart.removeProduct(product);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${product.name} removed from cart')),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle purchase logic
            _showPurchaseConfirmation(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkAppColor300,
            padding: const EdgeInsets.all(15.0),
          ),
          child: const Text('Proceed to Purchase'),
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Purchase Confirmation'),
          content: const Text('Are you sure you want to purchase these items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Confirm purchase and clear cart
                setState(() {
                  Cart.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Purchase successful!')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class Cart {
  static final List<Product> _products = [];

  static List<Product> get products => _products;

  static void addProduct(Product product) {
    _products.add(product);
  }

  static void removeProduct(Product product) {
    _products.remove(product);
  }

  static void clear() {
    _products.clear();
  }
}
