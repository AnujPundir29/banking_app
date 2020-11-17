import 'package:banking_app/screens/customer_information.dart';
import 'package:banking_app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarCustom(
              title: 'Customers',
              color: Colors.cyan[300],
              goto: 'back',
            ),
            CustomerInformation(),
          ],
        ),
      ),
    );
  }
}
