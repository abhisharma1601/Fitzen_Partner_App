import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';

class Withdrawls extends StatefulWidget {
  @override
  _WithdrawlsState createState() => _WithdrawlsState();
}

class _WithdrawlsState extends State<Withdrawls> {
  Future<void> getwiths() async {
    withboxes = [];
    try {
      var snap = await FirebaseFirestore.instance
          .collection("Partner_Users")
          .doc(cru.getuid())
          .get();
      snap.data()["Withdrawals"].forEach(
            (k, v) => withboxes.add(
              WithBox(
                id: v["Date"],
                amount: v["Amount"],
                status: v["Status"],
                tid: k,
              ),
            ),
          );
    } catch (e) {}

    setState(() {});
  }

  @override
  void initState() {
    getwiths();
    super.initState();
  }

  List<Widget> withboxes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff155E63),
        title: Text(
          "Money Withdrawals",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 1.5.h,
            ),
            Column(
                children: withboxes.reversed.toList().length == 0
                    ? [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                  child: Icon(
                                Icons.warning,
                                size: 35,
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "No Withdrawals !",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : withboxes.reversed.toList())
          ],
        ),
      ),
    );
  }
}

class WithBox extends StatelessWidget {
  WithBox({this.amount, this.id, this.status, this.tid});
  String id, status, tid;
  int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(3.0.w, 0, 3.0.w, 1.5.h),
      height: 11.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade400,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tid,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  id.substring(0, 10),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$amount/-",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  "$status",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
