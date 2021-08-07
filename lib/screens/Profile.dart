import 'dart:io';
import 'package:admin/Login/main_screen.dart';
import 'package:admin/Payments/paymentdetails.dart';
import 'package:admin/Payments/withdrawls.dart';
import 'package:admin/screens/MyData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:photo_view/photo_view.dart';

import 'package:sizer/sizer.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> data() async {
    var snap = await FirebaseFirestore.instance
        .collection("Partner_Users")
        .doc(cru.getuid())
        .get();
    name = snap.data()["Data"]["Name"];
    profilepic = snap.data()["Data"]["Profile_Pic"];
    print(profilepic);
    setState(() {});
  }

  @override
  void initState() {
    data();
    super.initState();
  }

  String name = "";

  String profilepic = "";
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.3,
      color: Colors.black,
      inAsyncCall: spin,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff155E63),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              //height: 22.0.h,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (profilepic ==
                          "https://static.thenounproject.com/png/187803-200.png") {
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);
                        setState(() async {
                          if (pickedFile != null) {
                            _image = File(pickedFile.path);
                            var reference = FirebaseStorage.instance
                                .ref()
                                .child("Admins/ProfilePics/${cru.getuid()}");
                            var uploadTask =
                                reference.putData(_image.readAsBytesSync());
                            String url =
                                await (await uploadTask).ref.getDownloadURL();
                            FirebaseFirestore.instance
                                .collection("Partner_Users")
                                .doc(cru.getuid())
                                .set({
                              "Data": {"Profile_Pic": url}
                            }, SetOptions(merge: true));
                            data();
                          } else {
                            print('No image selected.');
                          }
                        });
                      } else {
                        print("2");
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  height: 310,
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 250,
                                        width: 300,
                                        child: PhotoView(
                                          imageProvider:
                                              NetworkImage(profilepic),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "Partner_Users")
                                                      .doc(cru.getuid())
                                                      .set({
                                                    "Data": {
                                                      "Profile_Pic":
                                                          "https://static.thenounproject.com/png/187803-200.png"
                                                    }
                                                  }, SetOptions(merge: true));
                                                  Navigator.pop(context);
                                                  data();
                                                }),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.replay_circle_filled,
                                                  size: 30,
                                                ),
                                                onPressed: () async {
                                                  final pickedFile =
                                                      await picker.getImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  setState(() async {
                                                    if (pickedFile != null) {
                                                      _image =
                                                          File(pickedFile.path);
                                                      var reference =
                                                          FirebaseStorage
                                                              .instance
                                                              .ref()
                                                              .child(
                                                                  "ProfilePics/${cru.getuid()}");
                                                      var uploadTask = reference
                                                          .putData(_image
                                                              .readAsBytesSync());
                                                      String url =
                                                          await (await uploadTask)
                                                              .ref
                                                              .getDownloadURL();
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "Partner_Users")
                                                          .doc(cru.getuid())
                                                          .set(
                                                              {
                                                            "Data": {
                                                              "Profile_Pic": url
                                                            }
                                                          },
                                                              SetOptions(
                                                                  merge: true));
                                                      data();
                                                      Navigator.pop(context);
                                                    } else {
                                                      print(
                                                          'No image selected.');
                                                    }
                                                  });
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 17.3.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 17.0.w,
                        backgroundImage: NetworkImage(profilepic),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 1.0.h),
                      Text(
                        cru.getpara(),
                        style: TextStyle(fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0.h),
            Container(
              padding: EdgeInsets.all(1.3.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        spin = true;
                      });
                      var snap = await FirebaseFirestore.instance
                          .collection("Partner_Users")
                          .doc(cru.getuid())
                          .get();
                      try {
                        snap.data()["Payout_Details"]["IFSC"];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyData(
                                name: snap.data()["Data"]["Name"],
                                email: snap.data()["Data"]["email_id"],
                                gym: snap.data()["Data"]["Gym Name"],
                                aname: snap.data()["Payout_Details"]
                                    ["Bank_Holder_name"],
                                acno: snap.data()["Payout_Details"]
                                    ["Bank_Number"],
                                ifsc: snap.data()["Payout_Details"]["IFSC"],
                                address: snap.data()["Payout_Details"]
                                    ["Address"],
                              ),
                            ));
                      } catch (e) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyData(
                                name: snap.data()["Data"]["Name"],
                                email: snap.data()["Data"]["email_id"],
                                gym: snap.data()["Data"]["Gym Name"],
                                aname: "Not Filled !",
                                acno: "Not Filled !",
                                ifsc: "Not Filled !",
                                address: "Not Filled !",
                              ),
                            ));
                      }
                      setState(() {
                        spin = false;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Icon(
                          Icons.copy,
                          color: Color(0xff155E63),
                          size: 7.0.w,
                        ),
                        SizedBox(
                          width: 2.0.h,
                        ),
                        Text(
                          "My Data",
                          style: TextStyle(fontSize: 2.5.h),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Payment_Details(),
                          ));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Icon(
                          Icons.monetization_on,
                          color: Color(0xff155E63),
                          size: 7.0.w,
                        ),
                        SizedBox(
                          width: 2.0.h,
                        ),
                        Text(
                          "Payment Details",
                          style: TextStyle(fontSize: 2.5.h),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Withdrawls()));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Icon(
                          Icons.money,
                          color: Color(0xff155E63),
                          size: 7.0.w,
                        ),
                        SizedBox(
                          width: 2.0.h,
                        ),
                        Text(
                          "Withdrawls",
                          style: TextStyle(fontSize: 2.5.h),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 2.0.w,
                      ),
                      Icon(
                        Icons.share,
                        color: Color(0xff155E63),
                        size: 7.0.w,
                      ),
                      SizedBox(
                        width: 2.0.h,
                      ),
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 2.5.h),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => main_login_screen()));
              },
              child: Padding(
                padding: EdgeInsets.all(2.0.h),
                child: Text("Log Out"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
