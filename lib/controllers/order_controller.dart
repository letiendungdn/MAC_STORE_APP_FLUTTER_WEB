import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/order.dart';
import 'package:http/http.dart' as http;

class OrderController {
  Future<List<Order>> loadOrders() async {
    try {
      // Send an HTTP GET request to fetch all orders.
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Convert raw JSON array into typed Order objects.
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data
            .map((order) => Order.fromJson(order as Map<String, dynamic>))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }
}
