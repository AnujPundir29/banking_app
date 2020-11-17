import 'package:banking_app/screens/customer_information.dart';
import 'package:banking_app/screens/transaction_list.dart';
import 'package:banking_app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_page.dart';

class HomePage extends StatelessWidget {
  //ANCHOR widget for card showing customers and transactions

  Widget raisedButton(
      {@required icon, @required text, @required goto, @required color}) {
    return GestureDetector(
      onTap: () => Get.to(goto),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.grey,
        color: color,
        child: Container(
          height: Get.height / 2 * .37,
          width: Get.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 17.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AppBarCustom(
          color: Colors.deepPurple,
          title: "Banking App",
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width / 2 * .3, vertical: Get.height / 2 * .17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              raisedButton(
                  icon: FlutterIcons.person_oct,
                  text: 'View Customers',
                  goto: CustomerInformation(),
                  color: Colors.cyan[300]),
              SizedBox(
                height: Get.height / 2 * .06,
              ),
              raisedButton(
                  icon: FlutterIcons.payment_mdi,
                  text: 'All Transactions',
                  goto: TransactionList(),
                  color: Colors.red[300]),
            ],
          ),
        ),
      ],
    ));
  }
}
