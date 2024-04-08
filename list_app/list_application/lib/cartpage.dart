import 'package:flutter/material.dart';
import 'package:list_application/draganddrop.dart';

class CartPage extends StatelessWidget {
  final List<Customer> _customer;

  CartPage({super.key, required List<Customer> customer})
      : _customer = customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List'),
      ),
      body: ListView.builder(
        itemCount: _customer.length,
        itemBuilder: (context, index) {
          return _buildCartList(_customer[index]);
        },
      ),
    );
  }

  Widget _buildCartList(Customer customer) {
    final num totalPriceOfEachCustomer = customer.items.isNotEmpty
        ? customer.items.map((item) => item.totalPrices).reduce((a, b) => a + b)
        : 0.0;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(customer.name),
            subtitle: customer.items.isEmpty
                ? const Text(
                    'No order',
                    style: TextStyle(color: Colors.red),
                  )
                : Text('${customer.items.length} items'),
          ),
          if (customer.items.isNotEmpty)
            Column(
              children: [
                for (final item in customer.items)
                  ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                        '\$${(item.totalPrices / 100.0).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.lightGreen)),
                  ),
                const Divider(),
                ListTile(
                  title: const Text('Total: '),
                  subtitle: Text(
                    '\$${(totalPriceOfEachCustomer / 100.0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
