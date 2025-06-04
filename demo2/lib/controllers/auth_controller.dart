import 'package:demo2/models/user.dart';
import 'package:demo2/provider/user_provider.dart';
import 'package:demo2/services/manage_http_response.dart';
import 'package:demo2/views/screens/authentication_screens/login_screen.dart';
import 'package:demo2/views/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:demo2/global_variables.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Make sure that LoginScreen is defined as a class in login_screen.dart and exported.

final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),

        //Covert the user Object to Json for the request body
        headers: <String, String>{
          //Set the Headers for the request
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          showSnackBar(context, 'Account has been Created for you');
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  //signin users function
  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () async {
          //Access sharedPreferences for token and user date storage
          SharedPreferences preferences = await SharedPreferences.getInstance();
          //Extract the authentication token from the response body
          String token = jsonDecode(response.body)['token'];

          //Store the authentication token securely in SharedPreferences

          await preferences.setString('auth_token', token);

          //Encode the user data recived from the backend as json
          final userJson = jsonEncode(jsonDecode(response.body)['user']);

          //update the application state  with the user data using Riverpod
          providerContainer.read(userProvider.notifier).setUser(userJson);

          //store the data in sharePreference for future use

          await preferences.setString('user', userJson);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Logged In');
        },
      );
    } catch (e) {}
  }

  //Signout

  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //clear the token and user from sharedPreference
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //clear the user state
      providerContainer.read(userProvider.notifier).signOut();
      //navigate the user back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
        (route) => false,
      );

      showSnackBar(context, ' singout successfully');
    } catch (e) {
      showSnackBar(context, 'error signing out');
    }
  }

  //Update user's state, city and locality
  Future<void> updateUserLocation({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
  }) async {
    try {
      print('Calling API to update user location...');
      final http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () async {
          final updateUser = jsonDecode(response.body);
          final userJson = jsonEncode(updateUser);

          print('Decoded user data: $updateUser');

          SharedPreferences preferences = await SharedPreferences.getInstance();
          providerContainer.read(userProvider.notifier).setUser(userJson);
          await preferences.setString('user', userJson);

          showSnackBar(context, 'Address updated successfully!');
        },
      );
    } catch (e) {
      print('Error in updateUserLocation: $e');
      showSnackBar(context, 'Error updating location');
    }
  }
}
