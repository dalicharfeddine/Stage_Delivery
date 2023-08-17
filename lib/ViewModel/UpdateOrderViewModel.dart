import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateOrderViewModel {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> updateOrder(int orderId, String driverMessage, String pendingStatus) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print('olalala : $token');

      final Map<String, String> requestData = {
        'driver_message': driverMessage,
        'pending_status': pendingStatus,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders/update/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestData,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final bool success = responseBody['success'] ?? false;
        return success;
      } else {
        print('Failed to update the order. Server returned status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error while updating the order: $error');
      return false;
    }
  }
}
