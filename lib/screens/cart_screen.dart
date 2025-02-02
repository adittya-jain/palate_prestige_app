import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:provider/provider.dart';
import '../models/models.dart' as app_models;
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import '../services/websocket_service.dart';
import '../widgets/components.dart';
import 'order_screen.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

class CartScreen extends StatefulWidget {
  final String restaurantId;
  const CartScreen({super.key, required this.restaurantId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final SocketMethods _socketMethods = SocketMethods();
  String? customerId;
  String? userName;
  String? userPhone;
  String? userEmail;
  late String orderID;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }

      final String userId = currentUser.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          customerId = userId;
          userName = userDoc['name'];
          userPhone = userDoc['phone'];
          userEmail = userDoc['email'];
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Center(
              child: Text(
                  "Payment was not successful please try again. \n Any deducted amount will be refunded in 2-5 days.\n Thank You!!!")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _initiateOrder(double amount, List<app_models.OrderItem> orderItems) {
    orderID = generateOrderId(userPhone!);
    app_models.Order order = app_models.Order(
      orderId: orderID,
      shopId: widget.restaurantId,
      refId: 'CASH',
      name: userName!,
      contact: userPhone!,
      orders: orderItems,
      amount: amount,
    );

    Map<String, dynamic> orderJson = order.toJson();
    _socketMethods.newOrder(orderJson);
  }

  void initiatePayment(BuildContext context, double amount,
      List<app_models.OrderItem> orderItems) async {
    final paymentService = PaymentService();

    try {
      await paymentService.createOrder(
        restaurantId: widget.restaurantId,
        orderAmount: amount, // Example amount
        custId: customerId!,
        custName: userName!,
        custEmail: userEmail!,
        custPhone: userPhone!,
      );

      print(paymentService.orderId);
      print(paymentService.paymentSessionId);

      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(paymentService.orderId)
          .setPaymentSessionId(paymentService.paymentSessionId)
          .build();

      print("session created");

      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session).build();
      var cfPaymentGateway = CFPaymentGatewayService();
      print("gateway se pehle");
      cfPaymentGateway.setCallback(
        (orderId) {
          // Payment successful
          // Order krdo aur navigate to order screen
          _initiateOrder(amount, orderItems);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(orderItems: orderItems, amount: amount, orderID: orderID,),
            ),
          );
        },
        (vr, e) {
          print(vr.getMessage());
          print("error in callback");
          // print();
          showAlert(context);
        },
      );
      cfPaymentGateway.doPayment(cfWebCheckout);
    }on CFErrorResponse catch (e) {
      print("Error creating order: ${e.getMessage()}");
    } catch (e) {
      print("Error creating order blah: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart (${cart.items.length} items)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item['foodimg'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['foodname'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => cart
                                      .decreaseItemQuantity(item['foodname']),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(item['quantity'].toString()),
                                IconButton(
                                  onPressed: () => cart.addItem({
                                    // 'id': item['id'],
                                    'foodname': item['foodname'],
                                    'price': item['price'],
                                    'quantity': 1,
                                    'foodimg': item['foodimg'],
                                  }),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '₹${int.parse(item['price'].toString()) * int.parse(item['quantity'].toString())}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', cart.totalPrice),
                _buildSummaryRow('Tax @5.00%', cart.totalPrice * 0.05),
                _buildSummaryRow('Platform Fee', 0.00),
                const Divider(),
                _buildSummaryRow('Total', cart.totalPrice * 1.05,
                    isTotal: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: userName != null && userPhone != null
                  ? () {
                      List<app_models.OrderItem> orderItems = cart.items
                          .map((item) => app_models.OrderItem(
                                itemName: item['foodname'],
                                quantity: item['quantity'],
                              ))
                          .toList();
                      initiatePayment(
                          context, (cart.totalPrice * 1.05), orderItems);
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Proceed to Checkout (₹${(cart.totalPrice * 1.05).toStringAsFixed(2)})',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
