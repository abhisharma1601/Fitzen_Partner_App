import 'package:admin/screens/main_screen.dart';
import 'package:admin/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';
import 'data_entry.dart';

class main_login_screen extends StatefulWidget {
  @override
  _main_login_screenState createState() => _main_login_screenState();
}

class _main_login_screenState extends State<main_login_screen> {
  String otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spin,
        opacity: 0.3,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 7.55.h, bottom: 5.125.h),
                child: Image(
                  height: 28.06.h,
                  width: 52.4.w,
                  image: AssetImage("Assets/images/LGW.png"),
                ),
              ),
              Center(
                child: Container(
                  height: 52.78.h,
                  width: 89.0.w,
                  decoration: BoxDecoration(
                    color: Color(0xff155E63),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.475.h),
                        child: Text(
                          "Enter Mobile Number",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 7.875.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.833.w),
                        child: Container(
                          height: 7.34.h,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 10.0.h,
                                width: 76.0.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "+91",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 8.5.w,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (text) {
                                          mobilenumber = text;
                                        },
                                        textAlign: TextAlign.left,
                                        keyboardType: TextInputType.number,
                                        maxLines: null,
                                        decoration: new InputDecoration(
                                          hintText: "Enter Number here",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6.0.h),
                      Text(
                        'By Continuing, you accept our',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            child: Text(
                              'Terms&Conditions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {},
                          ),
                          Text(
                            ' and our ',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          GestureDetector(
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                      SizedBox(height: 6.78.h),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            spin = true;
                          });
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            timeout: Duration(milliseconds: 10000),
                            phoneNumber: "+91$mobilenumber",
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              print("auto");
                              Navigator.of(context).pop();
                              var result = await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              User user = result.user;
                              try {
                                var snap = await FirebaseFirestore.instance
                                    .collection("Partner_Users")
                                    .doc(user.uid)
                                    .get();
                                var par = await snap.data()["Data"];
                                cru = CurrentUser(
                                    FirebaseAuth.instance.currentUser.uid,
                                    par["Login_Parameter"]);
                                bool basic = await snap.data()["Basic_Details"];
                                print(basic);
                                if (basic) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Main_Page(),
                                    ),
                                  );
                                } else if (!basic) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DataEntryPage(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                FirebaseFirestore.instance
                                    .collection("Partner_Users")
                                    .doc(user.uid)
                                    .set({
                                  "Basic_Details": false,
                                  "Data": {
                                    "UserId": user.uid,
                                    "Login_Parameter": mobilenumber
                                  }
                                });
                                cru = CurrentUser(user.uid, mobilenumber);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DataEntryPage()));
                              }
                              setState(() {
                                spin = false;
                              });
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              setState(() {
                                spin = false;
                              });
                              toast("Verfication Failed!");
                            },
                            codeSent: (String verificationId, int resendToken) {
                              setState(() {
                                spin = false;
                              });
                              print("sent");
                              showDialog(
                                  context: context,
                                  builder: (dialogcontext) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Enter OTP",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (text) {
                                                      otp = text;
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                    autofocus: true,
                                                    textAlign: TextAlign.left,
                                                    maxLength: 10,
                                                    cursorColor: Color.fromRGBO(
                                                        121, 97, 247, 1),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: "OTP Here",
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              0xffCBCBCB)),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 6.0),
                                                      counter: Offstage(),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    print(otp);
                                                    PhoneAuthCredential
                                                        credential =
                                                        PhoneAuthProvider
                                                            .credential(
                                                                verificationId:
                                                                    verificationId,
                                                                smsCode: otp);
                                                    UserCredential result =
                                                        await FirebaseAuth
                                                            .instance
                                                            .signInWithCredential(
                                                                credential);
                                                    User user = result.user;
                                                    Navigator.pop(context);
                                                    try {
                                                      var snap =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Partner_Users")
                                                              .doc(user.uid)
                                                              .get();
                                                      var par = await snap
                                                          .data()["Data"];
                                                      cru = CurrentUser(
                                                          FirebaseAuth.instance
                                                              .currentUser.uid,
                                                          par["Login_Parameter"]);
                                                      bool basic =
                                                          await snap.data()[
                                                              "Basic_Details"];
                                                      print(basic);
                                                      if (basic) {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Main_Page(),
                                                          ),
                                                        );
                                                      } else if (!basic) {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DataEntryPage(),
                                                          ),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "Partner_Users")
                                                          .doc(user.uid)
                                                          .set({
                                                        "Basic_Details": false,
                                                        "Data": {
                                                          "UserId": user.uid,
                                                          "Login_Parameter":
                                                              mobilenumber
                                                        }
                                                      });
                                                      cru = CurrentUser(
                                                          user.uid,
                                                          mobilenumber);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DataEntryPage()));
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Icon(
                                                      Icons.forward,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              setState(() {
                                spin = false;
                              });
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(16.49.w, 0, 16.49.w, 0),
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                              child: Text(
                            "Generate OTP",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                        ),
                      ),
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
}
