import 'package:banking_app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customer_detail.dart';

class CustomerInformation extends StatelessWidget {
  final TextStyle textStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('customers');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarCustom(
              title: 'Customers',
              color: Colors.cyan[300],
              goto: 'back',
            ),
            StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  controller: ScrollController(keepScrollOffset: false),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return GestureDetector(
                      onTap: () => Get.to(CustomerDetail(
                        customer: document,
                      )),
                      child: ListTile(
                        leading: Icon(
                          FlutterIcons.person_outline_mdi,
                          size: 33,
                        ),
                        title: Text(
                          document.data()['name'],
                          style: textStyle,
                        ),
                        subtitle: Text(document.data()['email']),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
