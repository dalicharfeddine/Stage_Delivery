import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user.dart';
import '../Res/AppColors.dart';

class LoginViewModel extends ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> login(String email, String password) async {
    print(email);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data.containsKey('status') && data['status'] == true && data.containsKey('token') && data['token'] != null) {
          final token = data['token'];
          print('Token: $token');

          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('token', token);

          if (data.containsKey('user')) {
            final user = User(
              id: data['user']['id'],
              name: data['user']['name'],
              userName: data['user']['username'],
              password: data['user']['password'],
              email: data['user']['email'],
              image: data['user']['image'],
              phone: data['user']['phone'],
              address: data['user']['address'],
              type: data['user']['type'],
              status: data['user']['status'],
              staffId: data['user']['staff_id'],
              plateNo: data['user']['plate_no'],
              bankStatement: data['user']['bank_statement'],
              hubId: data['user']['HUB_ID'],
              carId: data['user']['car_id'],
              cinCopy: data['user']['CIN_copy'],
              cin: data['user']['CIN'],
            );
            // Perform any other operations with the 'user' object if needed
          }

          return true;
        } else {
          print('Login failed. Invalid data format in the response.');
          return false;
        }
      } else {
        print('Login failed. Server returned status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Login error: $error');
      return false;
    }
  }
}
