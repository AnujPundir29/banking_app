import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'money_transaction.dart';

class Pay extends StatefulWidget {
  final customer;
  Pay({@required this.customer});
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  TextEditingController controller = TextEditingController();
  CollectionReference transaction =
      FirebaseFirestore.instance.collection('transactionList');
  bool isloading = false;

  Widget raisedButton({onPresssed, @required text}) {
    return Container(
      width: Get.width / 2 * .76,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: RaisedButton(
          color: Colors.green[200],
          onPressed: () {
            if (onPresssed != null) validation();
          },
          child: Row(
            children: [
              Icon(
                FlutterIcons.paypal_faw,
                color: Colors.teal,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  text,
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validation() {
    if (controller.text.isNotEmpty) {
    }
    //  else if (controller.text[0] == '-') {
    //   Get.snackbar('Invalid Amount!!',
    //       'Please enter value greater than 0',
    //       snackPosition: SnackPosition.BOTTOM,
    //       margin: EdgeInsets.symmetric(
    //           horizontal: 10, vertical: 10));
    // }
    else {
      Get.snackbar('Empty Field!!', 'Please Enter some amount',
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10));
    }
    addUser(
      customer: widget.customer,
    );
  }

  Future<void> addUser({@required customer}) {
    isloading = true;
    // Call the user's CollectionReference to add a new user
    return transaction
        .add({
          'name': customer['name'], // John Doe
          'transaction': '₹ ' + controller.text, //, 42
          // 'time': "${DateTime.now().hour}:${DateTime.now().minute}",
          'time': Timestamp.now(),
        })
        .then((value) => setState(() {
              isloading = true;
            }))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Future<void> addUser({@required customer}) async {
  //   var documentReference = transaction.doc(customer['name']);
  //   return FirebaseFirestore.instance
  //       .runTransaction((transaction) async {
  //         // Get the document
  //         DocumentSnapshot snapshot = await transaction.get(documentReference);

  //         if (!snapshot.exists) {
  //           // throw Exception("User does not exist!");

  //           var newTransaction = transaction.set(
  //             documentReference,
  //             {
  //               'name': customer['name'], // John Doe// Stokes and Sons
  //               'transfered': int.parse(controller.text) // 42
  //             },
  //           );

  //           return newTransaction;
  //           // .then((value) => print("User Added "));
  //           // .catchError((error) => print("Failed to add user: $error"));
  //         }

  //         // Update the follower count based on the current count
  //         // Note: this could be done without a transaction
  //         // by updating the population using FieldValue.increment()

  //         // int newFollowerCount = snapshot.data()['followers'] + 1;
  //         int newTransaction =
  //             snapshot.data()['transfered'] + int.parse(controller.text);

  //         // Perform an update on the document
  //         transaction.update(documentReference, {'transfered': newTransaction});

  //         // Return the new count
  //         return newTransaction;
  //       })
  //       .then((value) => print("Follower count updated to $value"))
  //       .catchError(
  //           (error) => print("Failed to update user followers: $error"));

  //   // var data = await transaction.get();
  //   // int prev;
  //   // data.docs.map((e) {
  //   //   if (e.id == customer['name']) {
  //   //     setState(() {
  //   //       prev = e.data()['transfered'];
  //   //     });
  //   //   }
  //   // });
  //   // // Call the user's CollectionReference to add a new user
  //   // return transaction
  //   //     .doc(customer['name'])
  //   //     .set({
  //   //       'name': customer['name'], // John Doe// Stokes and Sons
  //   //       // 'prev': int.parse(controller.text),
  //   //       'transfered': int.parse(controller.text) // 42
  //   //     })
  //   //     .then((value) => print("User Added $prev"))
  //   //     .catchError((error) => print("Failed to add user: $error"));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.cyan,
      appBar: AppBar(
        // backgroundColor: Colors.cyan,
        elevation: .2,
        leading: IconButton(
          icon: Icon(FlutterIcons.arrow_back_mdi),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(FlutterIcons.theme_light_dark_mco),
            onPressed: () {
              Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: size.height / 2 * .3, left: size.width / 2 * .245),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: size.height / 2,
              width: size.width / 2 * 1.5,
              color: Colors.teal[600],
              padding: EdgeInsets.only(top: size.height / 2 * .2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(widget.customer['name'],
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ))),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height / 2 * .06),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 3.5),
                        height: 55,
                        width: size.width / 1.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          color: Color(0xffb2deec),
                        ),
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(FlutterIcons.money_faw),
                            hintText: 'Amount',
                            hintStyle: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  (isloading)
                      ? raisedButton(text: 'Paid', onPresssed: null)
                      : raisedButton(text: 'Pay', onPresssed: 1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
