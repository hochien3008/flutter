import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mac_verdor_store/global_variables.dart';
import 'package:mac_verdor_store/models/vendor.dart';
import 'package:mac_verdor_store/provider/vendor_provider.dart';
import 'package:mac_verdor_store/services/manage_http_response.dart';
import 'package:mac_verdor_store/views/screens/authentication/login_screen.dart';
import 'package:mac_verdor_store/views/screens/main_vendor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: 'vendor',
        password: password,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signup"),
        body:
            vendor
                .toJson(), //Covert the Vendor user object to json for the request body
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      //managehttp response to handle http response base o their status code
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          showSnackBar(context, 'Vendor Account Created');
        },
      );
    } catch (e) {}
  }

  //funcition to consume the backend vendor signin api
  Future<void> signInVendor({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      //managehttp response to handle http response base o their status code
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          //Extract the authentication token from the response body
          String token = jsonDecode(response.body)['token'];
          //Strore the authentication token securely in the shared preferences
          await preferences.setString('auth_token', token);
          //Encode the user data recived from the backend as json
          final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

          //update the application state with the user data using riverpod
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);
          //store the data in SharedPreferences
          await preferences.setString('vendor', vendorJson);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainVendorScreen();
              },
            ),
            (route) => false,
          );
          showSnackBar(context, 'Logged in Successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }
}
