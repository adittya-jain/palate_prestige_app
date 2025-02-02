import 'package:flutter/material.dart';
import 'package:palate_prestige/models/orders_model.dart';

import '../widgets/rating_star.dart';

class OrderTrackingScreen extends StatefulWidget {
  final List<OrderItem> orderItems; // Added properties
  final double amount;
  final String orderID;
  const OrderTrackingScreen({
    super.key,
    required this.orderItems,
    required this.amount,
    required this.orderID,
  });

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _selectedRating = 0;
  bool _isRatingSubmitted = false;

  // Tracking order state
  final bool _isOrderPlaced = true; // Initially true when order is placed
  bool _isBeingPrepared = false; // Update this dynamically
  bool _isPrepared = false; // Update this dynamically

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        _isBeingPrepared = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.amber[800],
                size: 80,
              ),
            ),
            const Center(
              child: Text(
                'Order Successfully Placed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Thanks for ordering with us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: const Color.fromARGB(255, 88, 88, 88),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.amber[800]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Your Order Details',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Order ID:'),
                            Text(widget.orderID),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Date:'),
                            Text(
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount:'),
                            Text(widget.amount.toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: const Color.fromARGB(255, 88, 88, 88),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.amber[800]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.done,
                                size: 50,
                                color: (_isOrderPlaced)
                                    ? Colors.amber[800]
                                    : Colors.grey[100],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Order Placed',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: (_isOrderPlaced)
                                        ? Colors.amber[800]
                                        : Colors.grey[100],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 25,
                              width: 2,
                              color: (_isOrderPlaced)
                                  ? Colors.amber[800]
                                  : Colors.grey[100],
                              margin: const EdgeInsets.only(left: 33),
                            ),
                            Container(
                              height: 25,
                              width: 2,
                              color: (_isBeingPrepared)
                                  ? Colors.amber[800]
                                  : Colors.grey[100],
                              margin: const EdgeInsets.only(left: 33),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.outdoor_grill,
                                size: 50,
                                color: (_isBeingPrepared)
                                    ? Colors.amber[800]
                                    : Colors.grey[100],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Order is being prepared',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: (_isBeingPrepared)
                                        ? Colors.amber[800]
                                        : Colors.grey[100],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 25,
                              width: 2,
                              color: (_isBeingPrepared)
                                  ? Colors.amber[800]
                                  : Colors.grey[100],
                              margin: const EdgeInsets.only(left: 33),
                            ),
                            Container(
                              height: 25,
                              width: 2,
                              color: (_isPrepared)
                                  ? Colors.amber[800]
                                  : Colors.grey[100],
                              margin: const EdgeInsets.only(left: 33),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 50,
                                color: (_isPrepared)
                                    ? Colors.amber[800]
                                    : Colors.grey[100],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Order Prepared 🤩',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: (_isPrepared)
                                        ? Colors.amber[800]
                                        : Colors.grey[100],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                color: const Color.fromARGB(255, 88, 88, 88),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.amber[800]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: widget.orderItems.map((item) {
                    return Card(
                      color: const Color.fromARGB(255, 88, 88, 88),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.itemName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                color: const Color.fromARGB(255, 88, 88, 88),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.amber[800]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Rate Your Experience",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        StarRating(
                          initialRating: _selectedRating, // Default to 3 stars
                          onRatingChanged: _isRatingSubmitted
                              ? (_) {} // Disable interaction after submission
                              : (rating) {
                                  setState(() {
                                    _selectedRating = rating;
                                  });
                                },
                          starSize: 50.0, // Customize star size
                          filledStarColor: Colors.amber,
                          unfilledStarColor: Colors.grey[300]!,
                        ),
                        const SizedBox(height: 20),
                        // Button or Text
                        _isRatingSubmitted
                            ? const Text(
                                'Thank you for your feedback!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.amber[800],
                                  backgroundColor: Colors.grey[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (_selectedRating > 0) {
                                    setState(() {
                                      _isRatingSubmitted = true;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please select a rating first!'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Submit Rating'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
