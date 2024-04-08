import 'package:flutter/material.dart';
import 'package:list_application/draganddrop.dart';

class CartPage extends StatelessWidget {
  final List<Customer> _customer;

  const CartPage({super.key, required List<Customer> customer})
      : _customer = customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: ,
    );
  }

  Widget _buildCartList(){
    return ListView.builder(
      itemCount: _customer.length,
      itemBuilder: (context, index) {
      final customer = _customer[index];
      if(customer.items.isEmpty){
        return ListTile(
          title: Text(customer.name),
          subtitle: const Text('cart is empty'),
        );
      } else{
        return ;
      }
      },
      );
  }

  Widget _buildCustomCartListItem({required Customer customer}){
    List<Item> customerItemList = customer.items;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      }, 
      separatorBuilder:(context, index) {
        final item = customerItemList[index];
        return 
      }, 
      itemCount: customerItemList.length);
  }

}
