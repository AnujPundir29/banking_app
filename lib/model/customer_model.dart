import 'package:flutter/foundation.dart';

class Customer {
  final String name;
  final balance;
  final String email;
  final int age;

  Customer(
      {@required this.name,
      @required this.balance,
      @required this.email,
      @required this.age});
}
