import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../services/services.dart';
import '../providers/cart_provider.dart';
import '../widgets/loader.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;

  const MenuScreen({super.key, required this.restaurantId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<Map<String, dynamic>> _menuData;

  @override
  void initState() {
    super.initState();
    _menuData = ApiService().fetchMenu(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _menuData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: LottieLoader(url:'assets/menuLoading.json'),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Something went wrong!')),
          );
        } else if (snapshot.hasData) {
          final categories = snapshot.data!['data']['categories'];
          return DefaultTabController(
            length: categories.length,
            child: SafeArea(
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      title: Text('Menu'),
                      centerTitle: true,
                      pinned: false,
                      floating: true,
                      bottom: ButtonsTabBar(
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        backgroundColor: Colors.orangeAccent,
                        unselectedLabelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        unselectedBackgroundColor: Colors.transparent,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        tabs: categories.map<Widget>((category) {
                          return Tab(
                            text: category['name'],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    children: categories.map<Widget>((category) {
                      return ListView.builder(
                        itemCount: category['items'].length,
                        itemBuilder: (context, index) {
                          final item = category['items'][index];
                          return _buildMenuItem(context, item);
                        },
                      );
                    }).toList(),
                  ),
                ),
                bottomNavigationBar: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return cart.itemCount > 0
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to checkout screen or perform cart action
                                Navigator.of(context).pushNamed(
                                    '/cartScreen',
                                    arguments: widget.restaurantId);
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Proceed to Checkout (${cart.itemCount} items)',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data available')),
          );
        }
      },
    );
  }

  // Function to build each menu item
  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return Consumer<CartProvider>(
      // Use Consumer to access CartProvider
      builder: (context, cart, child) {
        final itemId = item['foodname'];
        int itemCount = 0; // Initialize itemCount

        if (itemId != null) {
          itemCount =
              cart.getItemCount(itemId); // Update itemCount if itemId is valid
        } else {
          print("Item ID is null or missing");
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (item['foodimg'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item['foodimg'],
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Icon(Icons.fastfood, size: 60, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['foodname'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('₹${item['price']}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),

                // If item is in cart, show - 1 + else show "Add" button
                itemCount > 0
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              cart.decreaseItemQuantity(
                                  itemId!); // Decrease quantity in the cart
                            },
                            icon:
                                const Icon(Icons.remove, color: Colors.orange),
                          ),
                          Text(
                            itemCount.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              cart.addItem({
                                // 'id': item['id'],
                                'foodname': item['foodname'],
                                'price': item['price'],
                                'quantity': 1,
                                'foodimg': item['foodimg'],
                              });
                            },
                            icon: const Icon(Icons.add, color: Colors.orange),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          cart.addItem({
                            // 'id': item['id'],
                            'foodname': item['foodname'],
                            'price': item['price'],
                            'quantity': 1,
                            'foodimg': item['foodimg'],
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Add'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
