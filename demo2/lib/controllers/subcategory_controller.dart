import 'dart:convert';

import 'package:demo2/global_variables.dart';
import 'package:demo2/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<Subcategory>> getSubcategoriesByCategoryName(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/category/$categoryName/subcategories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("Response: $decoded");

        if (decoded is Map && decoded['subcategories'] is List) {
          final List<dynamic> data = decoded['subcategories'];
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("No 'subcategories' key or it's not a list");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return [];
      } else {
        print("Failed to fetch subcategories");
        return [];
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      return [];
    }
  }
}
