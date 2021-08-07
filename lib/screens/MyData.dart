import 'package:admin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyData extends StatefulWidget {
  MyData(
      {this.name,
      this.email,
      this.gym,
      this.aname,
      this.acno,
      this.ifsc,
      this.address});
  String name, email, gym, aname, acno, ifsc, address;
  @override
  _MyDataState createState() => _MyDataState();
}

bool _show = false;

class _MyDataState extends State<MyData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff155E63),
        title: Text(
          "Account Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(2.0.h),
              //constraints: BoxConstraints(maxHeight: 42.0.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Name",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.name),
                  ),
                  ListTile(
                    title: Text(
                      "Mobile Number",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(cru.getpara()),
                  ),
                  ListTile(
                    title: Text(
                      "Email Id",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.email),
                  ),
                  ListTile(
                    title: Text(
                      "Gym Name",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.gym),
                  ),
                  ListTile(
                    title: Text(
                      "User Id",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(cru.getuid()),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2.0.h, 0, 2.0.h, 2.0.h),
              //constraints: BoxConstraints(maxHeight: 42.0.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Account Holder Name",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.aname),
                  ),
                  ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            if (_show) {
                              _show = false;
                            } else {
                              _show = true;
                            }
                          });
                        },
                        icon: Icon(Icons.remove_red_eye)),
                    title: Text(
                      "Bank Account Number",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      _show == true
                          ? widget.acno
                          : '${widget.acno.replaceAll(RegExp(r"."), "*")}',
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "IFSC Code",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.ifsc),
                  ),
                  ListTile(
                    title: Text(
                      "Address",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(widget.address),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
