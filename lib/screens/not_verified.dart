import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';

class Not_verified extends StatefulWidget {
  @override
  _Not_verifiedState createState() => _Not_verifiedState();
}

class _Not_verifiedState extends State<Not_verified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
          Text(
            cru.getuid(),
            
            style: TextStyle(
                color: Color(0xff155E63),
                fontSize: 20,
                textBaseline: TextBaseline.ideographic,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: Text(
              "Your id is under review. It will take 1-2 days to get verified.\n Thank you for registering",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
