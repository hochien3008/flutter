import 'dart:convert';

import 'package:demo2/global_variables.dart';
import 'package:demo2/models/order.dart';
import 'package:demo2/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class OrderController {
  //function to upload orders
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
  }) async {
    try {
      final Order order = Order(
        id: id,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'You have placed an order');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Method to GET Orders by buyer id

  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      final url = Uri.parse('$uri/api/orders/$buyerId');
      print("Fetching orders from: $url");

      http.Response response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      }

      throw Exception(
        "Failed to load orders: ${response.statusCode}, ${response.body}",
      );
    } catch (e) {
      print("Exception in loadOrders: $e");
      throw Exception('Error loading orders: $e');
    }
  }
}
