import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  //Seriallization: Covert User object to a Map
  //Map : A Map is a collecttion of key-value pairs
  //Why: Coverting to a map is an inintermediate step that makes its easier to serialize
  //the object to formates like json for storage transmission

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "email": email,
      "state": state,
      "city": city,
      "locality": locality,
      "password": password,
      'token': token,
    };
  }

  //Serialization: Covert Map to a Json String
  //This method directly encodes the data from the Map into a Json String

  //The json.encode() function converts a Dart object (such as map or List)\
  //between different systems

  //Deserialization: Convert a Json String to a Map to a User Object
  //purpose - Manipulation and user : Once the data is coverted to a User object,
  //it can be easily manipulated and  used in the application. For example,
  //we might want to display the user's full name,email etc on the Ui. or we might
  //want to save the data loclly

  //the factory contructor takes a Map(Usually obtained from a json object)
  //and coverts it into a User object.if a foeld is not present in the map,
  //it defaults to an empty string

  //fromMap: This is constructor take a Map <String, dynamic> and converts into a User object
  //. its usefull when you already have the data in map format

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }
  String toJson() => json.encode(toMap());
  //fromJson: This factory constructor takes a Json String , and decodes it into a Map<String, dynamic>
  //and then uses fromMap to convert that Map into a User object
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
