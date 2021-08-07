import 'dart:io';
import 'package:admin/cubit/fitzen_admin_cubit.dart';
import 'package:admin/screens/not_verified.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';

class DataEntryPage extends StatefulWidget {
  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  File _image;
  final picker = ImagePicker();
  String name, dataentered, gymname, url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 4.0.h, 0, 1.0.h),
                child: Image(
                  height: 17.59.h,
                  width: 60.38.w,
                  image: AssetImage("Assets/images/LGWS.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0.w, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10.0.h, 0),
                    child: Container(
                      child: TextFormField(
                        onChanged: (text) {
                          name = text;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 6.0),
                          counter: Offstage(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0.h),
                  Text(
                    "Email ID",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10.0.h, 0),
                    child: Container(
                      child: TextFormField(
                        onChanged: (text) {
                          dataentered = text;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 6.0),
                          counter: Offstage(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0.h),
                  Text(
                    "Gym Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10.0.h, 0),
                    child: Container(
                      child: TextFormField(
                        onChanged: (text) {
                          gymname = text;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 6.0),
                          counter: Offstage(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0.h),
                ],
              ),
            ),
            SizedBox(
              height: 1.0.w,
            ),
            BlocBuilder<FitzenAdminCubit, FitzenAdminState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                      var reference = FirebaseStorage.instance
                          .ref()
                          .child("Aadhars/${cru.getuid()}");
                      var uploadTask =
                          reference.putData(_image.readAsBytesSync());
                      url = await (await uploadTask).ref.getDownloadURL();
                      BlocProvider.of<FitzenAdminCubit>(context).changeimg(url);
                    } else {
                      print('No image selected.');
                    }
                  },
                  child: Container(
                    height: 140,
                    margin: EdgeInsets.fromLTRB(6.5.w, 0, 6.5.w, 4.0.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      image: DecorationImage(
                          image: NetworkImage(
                              BlocProvider.of<FitzenAdminCubit>(context)
                                  .state
                                  .img),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("Partner_Users")
                    .doc(cru.getuid())
                    .set({
                  "Verified": false,
                  "Data": {
                    "email_id": dataentered,
                    "Name": name,
                    "Gym Name": gymname,
                    "Adhar_link": url,
                    "Coins": 0,
                    "Profile_Pic":
                        "https://static.thenounproject.com/png/187803-200.png"
                  }
                }, SetOptions(merge: true));
                FirebaseFirestore.instance
                    .collection("Partner_Users")
                    .doc(cru.getuid())
                    .update({"Basic_Details": true});
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Not_verified()));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(110, 4.0.h, 110, 0),
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xff155E63),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                    child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
