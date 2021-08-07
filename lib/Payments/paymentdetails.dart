import 'package:admin/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

class Payment_Details extends StatefulWidget {
  @override
  _Payment_DetailsState createState() => _Payment_DetailsState();
}

TextEditingController bankno2 = TextEditingController();
TextEditingController lastname = TextEditingController();
TextEditingController firstname = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController bankno1 = TextEditingController();
TextEditingController ifsc = TextEditingController();
Widget _home;

class _Payment_DetailsState extends State<Payment_Details> {
  @override
  void initState() {
    _home = null;
    verify();
    super.initState();
  }

  Future<void> verify() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("Partner_Users")
          .doc(cru.getuid())
          .get();
      if (!snap.data()["Bank_Details"]) {
        setState(() {
          _home = Pay_false();
        });
      } else if (snap.data()["Bank_Details"]) {
        Navigator.pop(context);
        toast("Payment Details filled !");
      }
    } catch (e) {
      setState(() {
        _home = Pay_false();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff155E63),
          title: Text(
            "Payout Details",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _home);
  }
}

class Pay_false extends StatefulWidget {
  const Pay_false({
    Key key,
  }) : super(key: key);

  @override
  _Pay_falseState createState() => _Pay_falseState();
}

class _Pay_falseState extends State<Pay_false> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(2.0.h),
        child: Column(
          children: [
            SizedBox(height: 1.0.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff155E63)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    height: 7.4.h,
                    child: TextField(
                      controller: firstname,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'First Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.0.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff155E63)),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    height: 7.4.h,
                    child: TextField(
                      controller: lastname,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Lastname',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.5.h,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff155E63)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: 20.0.h,
              child: TextField(
                controller: address,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.multiline,
                maxLines: 12,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Address ...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff155E63)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: 7.4.h,
              child: TextField(
                obscureText: true,
                controller: bankno1,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Bank Account No.',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff155E63)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: 7.4.h,
              child: TextField(
                controller: bankno2,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: 're-enter account No.',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff155E63)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: 7.4.h,
              child: TextField(
                controller: ifsc,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'IFSC Code',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 15.0.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("Partner_Users")
                      .doc(cru.getuid())
                      .set({
                    "Bank_Details": true,
                    "Payout_Details": {
                      "Bank_Holder_name": "${firstname.text} ${lastname.text}",
                      "Address": address.text,
                      "Bank_Number": bankno2.text,
                      "IFSC": ifsc.text,
                    }
                  }, SetOptions(merge: true));
                  Navigator.pop(context);
                  toast("Details Submitted.");
                },
                child: Container(
                  width: 170,
                  height: 46,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff155E63)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Submit Details",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
