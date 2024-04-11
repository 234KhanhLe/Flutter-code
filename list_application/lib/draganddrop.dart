import 'package:flutter/material.dart';
import 'package:list_application/bottomnavigator.dart';
import 'package:list_application/cartpage.dart';

class TotalPage extends StatelessWidget {
  const TotalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    );
  }
}

@immutable
class Item {
  final int totalPrices;
  final String name;
  final String uid;
  final String imagePath;
  const Item({
    required this.totalPrices,
    required this.name,
    required this.uid,
    required this.imagePath,
  });

  String get formattedTotalPrices =>
      '\$${(totalPrices / 100.0).toStringAsFixed(2)}';
}

class Customer {
  final String name;
  final List<Item> items;

  Customer({
    required this.name,
    List<Item>? items,
  }) : items = items ?? [];

  String get formatTotalPrices {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPrices);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }

  void removeItem(Item item) {
    items.remove(item);
  }
}

const List<Item> _items = [
  Item(totalPrices: 100, name: 'Dish A', uid: '1', imagePath: 'images/D.png'),
  Item(totalPrices: 200, name: 'Dish B', uid: '2', imagePath: 'images/E.png'),
  Item(totalPrices: 300, name: 'Dish C', uid: '3', imagePath: 'images/F.png'),
];

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});
  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(name: 'Table A'),
    Customer(name: 'Table B'),
    Customer(name: 'Table C'),
    Customer(name: 'Table D')
  ];

  final GlobalKey _draggableKey = GlobalKey();
  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      customer.items.add(item);
    });
  }

  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = _buildContent();
        break;
      case 1:
        body = CartPage(customer: _people);
        break;
      default:
        body = Container();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(context),
      body: body,
      bottomNavigationBar:
          BottomNavigationBarWidget(currentIndex: _currentIndex, onTap: _onTap),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFF64209)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.purple],
          ),
        ),
        child: Center(
          child: Text(
            'Order Food',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 36,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        imagePath: item.imagePath,
      ),
      child: MenuListItem(
        imagePath: item.imagePath,
        name: item.name,
        price: item.formattedTotalPrices,
      ),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItem, rejectedItem) {
            return CustomerCart(
                hasItems: customer.items.isNotEmpty,
                highlighted: candidateItem.isNotEmpty,
                customer: customer);
          },
          onAcceptWithDetails: (details) {
            _itemDroppedOnCustomerCart(item: details.data, customer: customer);
          },
        ),
      ),
    );
  }
}

class CustomerCart extends StatelessWidget {
  const CustomerCart({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 8 : 4,
        borderRadius: BorderRadius.circular(22),
        color: highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight:
                          hasItems ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      customer.formatTotalPrices,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: textColor,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final bool isDepressed;

  const MenuListItem(
      {super.key,
      this.name = '',
      this.price = '',
      required this.imagePath,
      this.isDepressed = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  final GlobalKey dragKey;
  final String imagePath;

  const DraggingListItem(
      {super.key, required this.dragKey, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
