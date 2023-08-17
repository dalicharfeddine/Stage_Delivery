import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Orders.dart';
class OrdersViewModel extends ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Order>> fetchOrders() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? ''; // Provide a default empty string value if token is null
      print('olalala : $token');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/list/in_progress'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic>? responseData = responseBody['orders'];

        if (responseData != null && responseData is List) {
          final List<Order> orders = responseData.map((json) => Order.fromJson(json)).toList();
          return orders;
        } else {
          print('Invalid response data format or empty "orders" array.');
          return [];
        }
      } else {
        print('Failed to fetch delivered orders. Server returned status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error while fetching delivered orders: $error');
      return [];
    }
  }
}