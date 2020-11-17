import 'package:banking_app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionList extends StatelessWidget {
  final customer;

  TransactionList({Key key, this.customer}) : super(key: key);

  final TextStyle textStyle = GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('transaction');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarCustom(
              title: "Transactions",
              color: Colors.red[300],
              goto: "back",
            ),
            StreamBuilder<QuerySnapshot>(
              stream: (customer == null)
                  ? users.snapshots()
                  : users
                      .where('sender', isEqualTo: customer['name'])
                      .snapshots(),
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
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(document.data()['sender'][0],
                            style: textStyle),
                      ),
                      title: Row(
                        children: [
                          Text(document.data()['sender'], style: textStyle),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(FlutterIcons.transfer_right_mco),
                          ),
                          Text(document.data()['receiver'], style: textStyle),
                        ],
                      ),
                      subtitle:
                          Text('Paid', style: TextStyle(color: Colors.green)),
                      trailing: Text(
                        "₹ ${document.data()['transaction']}",
                        style: textStyle,
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
