import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order('Tomato Seeds', 2, DateTime.now().subtract(const Duration(days: 2))),
    Order('Corn Seeds', 1, DateTime.now().subtract(const Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(order.productName),
            subtitle: Text(
                'Quantity: ${order.quantity} \nOrdered on: ${order.orderDate.toLocal()}'),
          ),
        );
      },
    );
  }
}

class Order {
  final String productName;
  final int quantity;
  final DateTime orderDate;

  Order(this.productName, this.quantity, this.orderDate);
}
