import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:banking_app/screens/transaction_list.dart';
import 'package:banking_app/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerDetail extends StatefulWidget {
  final customer;

  const CustomerDetail({Key key, @required this.customer}) : super(key: key);

  @override
  _CustomerDetailState createState() => _CustomerDetailState(customer);
}

class _CustomerDetailState extends State<CustomerDetail> {
  var customer;
  _CustomerDetailState(this.customer);
  var textStyle =
      TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);

  bool isTransfered = false;

//ANCHOR custom raised button
  Widget raisedButton({onPresssed, @required text, @required icon}) {
    return Container(
      height: Get.height / 2 * .11,
      width: Get.width / 2 * .87,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: RaisedButton(
          color: Colors.green[200],
          onPressed: () {
            if (onPresssed == "send") {
              setState(() {
                _isSelected = true;
              });
            } else if (onPresssed == "cancel") {
              setState(() {
                _isSelected = false;
              });
            } else if (onPresssed == "nothing") {
              Get.to(TransactionList(customer: customer));
            } else {
              addUser();
              setState(() {
                isTransfered = true;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.teal,
                  size: 22,
                ),
                SizedBox(width: Get.width / 2 * .01),
                Text(
                  text,
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: Colors.black,
                      // letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController controller = TextEditingController();
  CollectionReference transaction =
      FirebaseFirestore.instance.collection('transaction');

  var _currentSelectedValue;
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    var newUser = transaction
        .add({
          'receiver': _currentSelectedValue,
          'sender': customer['name'],
          'transaction': int.parse(controller.text), //, 42
          // 'time': "${DateTime.now().hour}:${DateTime.now().minute}",
          // 'time': Timestamp.now(),
        })
        .then((value) => print('user added'))
        .catchError((error) => print("Failed to add user: $error"));

    updateReceiver(receiver: _currentSelectedValue);
    updateSender();
    return newUser;
  }

  Future<void> updateReceiver({@required receiver}) async {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('customers').doc(receiver);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          int newBalance =
              snapshot.data()['balance'] + int.parse(controller.text);

          // Perform an update on the document
          transaction.update(documentReference, {'balance': newBalance});

          // Return the new count
          return newBalance;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  Future<void> updateSender() async {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('customers')
        .doc(customer['name']);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          int newBalance =
              snapshot.data()['balance'] - int.parse(controller.text);

          // Perform an update on the document
          transaction.update(documentReference, {'balance': newBalance});

          // Return the new count
          return newBalance;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  var _person = [
    "Anuj",
    "Dhoni",
    "Manoj",
    "Messi",
    "Ronaldo",
    "Saurabh",
    "Shivam",
    "Sumeet",
    "Sunny",
    "Virat"
  ];

  bool _isSelected = false;

//ANCHOR Send money button
  Widget sendMoney() {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: Get.height / 2 * .9,
          width: Get.width / 2 * 1.5,
          color: Colors.teal[600],
          padding: EdgeInsets.only(top: Get.height / 2 * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text('Send Money',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ))),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height / 2 * .06),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 3.5),
                        height: 55,
                        width: Get.width / 1.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          color: Color(0xffb2deec),
                        ),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            // Text('a');
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Receiver',
                                border: InputBorder.none,
                              ),
                              isEmpty: _currentSelectedValue == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedValue,
                                  // isDense: true,
                                  onChanged: (String newValue) {
                                    if (newValue == widget.customer['name']) {
                                      Get.snackbar("Not Applicable",
                                          "You cannot select your name..",
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                    setState(() {
                                      _currentSelectedValue = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _person.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Get.height / 2 * .03),
                        padding: EdgeInsets.only(left: 20, top: 3.5),
                        height: 55,
                        width: Get.width / 1.6,
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
                      SizedBox(
                        height: Get.height / 2 * .03,
                      ),
                      raisedButton(
                          text: 'Transfer',
                          icon: FlutterIcons.paypal_ent,
                          onPresssed: "transaction"),
                      SizedBox(
                        height: Get.height / 2 * .03,
                      ),
                      raisedButton(
                          text: 'Cancel',
                          icon: FlutterIcons.cancel_mdi,
                          onPresssed: "cancel")
                    ],
                  ),
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
          //ANCHOR custom app bar
          AppBarCustom(
            title: 'Customer Detail',
            color: Colors.red[400],
            goto: "back",
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.height / 2 * .18),
                    //ANCHOR bottom clippath
                    child: ClipPath(
                      clipper: RoundedDiagonalPathClipper(),
                      child: Container(
                        height: Get.height / 2 * .8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0)),
                          color: Colors.teal,
                        ),
                        child: Center(
                          child: (_isSelected == false)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Get.height / 2 * .4,
                                          bottom: Get.height / 2 * .1),
                                      child: raisedButton(
                                          text: "Send Money",
                                          icon: FlutterIcons.bank_mco,
                                          onPresssed: "send"),
                                    ),
                                    raisedButton(
                                      text: "Transaction",
                                      icon: FlutterIcons.payment_mdi,
                                      onPresssed: "nothing",
                                    ),
                                  ],
                                )
                              : (isTransfered == false)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: Get.height / 2 * .17),
                                      child: sendMoney(),
                                    )
                                  : AlertDialog(
                                      title: Text('Transaction Successful'),
                                      content: SingleChildScrollView(
                                        child: AutoSizeText(
                                          'Successfully transfered ₹ ${controller.text} from ${customer['name']} to $_currentSelectedValue',
                                          maxLines: 2,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            setState(() {
                                              isTransfered = false;
                                              _isSelected = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
                //ANCHOR card detail
                Padding(
                  padding: EdgeInsets.only(top: Get.height / 2 * .05),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: Get.height / 2 * .4,
                        width: Get.width / 2 * 1.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment
                                .bottomRight, // 10% of the width, so there are ten blinds.
                            colors: [
                              Color(0xff4568dc),
                              Color(0xffb06ab3)
                            ], // red to yellow
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: Get.height / 2 * .08,
                              left: Get.width / 2 * .1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Name:  ${widget.customer['name']}',
                                style:
                                    GoogleFonts.poppins(textStyle: textStyle),
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                'Email:  ${widget.customer['email']}',
                                style:
                                    GoogleFonts.poppins(textStyle: textStyle),
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Age:  ${widget.customer['age']}',
                                style:
                                    GoogleFonts.poppins(textStyle: textStyle),
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                'Credit:  ₹ ${widget.customer['balance']}',
                                style:
                                    GoogleFonts.poppins(textStyle: textStyle),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
