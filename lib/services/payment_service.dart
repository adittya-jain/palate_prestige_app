import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  // Define the API endpoint URL
  final String createOrderUrl = "https://afosfr-server.onrender.com/api/order";

  late String orderId;
  late String paymentSessionId;
  Future<void> createOrder({
    required String restaurantId,
    required double orderAmount,
    required String custId,
    required String custName,
    required String custEmail,
    required String custPhone,
  }) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> orderDetails = {
        'restaurant_id': restaurantId,
        'order_amount': orderAmount,
        'cust_id': custId,
        'cust_name': custName,
        'cust_email': custEmail,
        'cust_phone': custPhone,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(createOrderUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderDetails),
      );

      // Check for successful response
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract order_id and payment_session_id
        orderId = responseData['order_id'];
        paymentSessionId = responseData['payment_session_id'];
        
      } else {
        print('Failed to create order. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while creating order: $error');
    }
  }
}
