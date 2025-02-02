import 'dart:math';

String generateOrderId(String str) {
  // Get the current date and time
  DateTime now = DateTime.now();

  // Format the date and time components
  String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}';
  String time = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

  // Get the last 4 digits of the mobile number
  String lastFourDigits = str.substring(max(0, str.length - 4));

  // Construct the order ID
  String orderId = 'PP$date$time$lastFourDigits';

  return orderId;
}


