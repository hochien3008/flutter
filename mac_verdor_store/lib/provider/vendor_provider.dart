import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_verdor_store/models/vendor.dart';

//StateNotifier: StateNoifier is a class provided by Riverpod package thei helps in
//managing the state, it is also designed to notify listeners about the state changes
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
    : super(
        Vendor(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          role: '',
          password: '',
        ),
      );

  //Geetter Method to extract value from an object
  Vendor? get vendor => state;
  //Method to set vendor user state from json
  //purpose: updates the user state base on json string representation  of the user vendor object
  //so that we can use it within the application
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  //method to clear the vendor user state
  void signOut() {
    state = null;
  }
}

//make the date accisible within the application
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
