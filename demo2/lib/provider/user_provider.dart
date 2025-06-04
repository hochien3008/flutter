import 'package:demo2/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  // Contructore initializing with default user Object
  //purpose: mange the state of the user object allowing updates
  UserProvider()
    : super(
        User(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          password: '',
          token: '',
        ),
      );

  //getter methed to extract value from an object

  User? get user => state;

  // methed to set user state from Json
  // purpose : udates he user state base on Json String respresentation of user Object

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  //Method to clear user state
  void signOut() {
    state = null;
  }

  //Method to Recreate the user state
  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id, //preserver the existing user id
        fullName: this.state!.fullName, //preserve the existing user fullname
        email: this.state!.email, //preserve the existing user email
        state: state,
        city: city,
        locality: locality,
        password: this.state!.password, //preserve the existing user paassword
        token: this.state!.token, //preserve the existing user token
      );
    }
  }
}

//make the data accisible within the application
final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
