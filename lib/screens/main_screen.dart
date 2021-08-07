import 'dart:math';
import 'package:admin/Payments/paymentdetails.dart';
import 'package:admin/cubit/fitzen_admin_cubit.dart';
import 'package:admin/screens/Profile.dart';
import 'package:admin/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import '../main.dart';
import 'admin_chat.dart';

class Main_Page extends StatefulWidget {
  @override
  _Main_PageState createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  Future<void> getques() async {
    var snap =
        FirebaseFirestore.instance.collection("Partner_pannel").snapshots();
    await for (var i in snap) {
      ques = [];
      for (var j in i.docs) {
        if (!j.data()["answered"]) {
          ques.add(
            Question_wid(
              uid: j.data()["uid"],
            ),
          );
        }
        getcoins();
        BlocProvider.of<FitzenAdminCubit>(context).changelist(ques);
      }
    }
  }

  Future<void> getcoins() async {
    var snap = await FirebaseFirestore.instance
        .collection("Partner_Users")
        .doc(cru.getuid())
        .get();
    coins = snap.data()["Data"]["Coins"];
    BlocProvider.of<FitzenAdminCubit>(context)
        .changecoins(snap.data()["Data"]["Coins"]);
  }

  @override
  void initState() {
    getques();
    getcoins();
    tid = Random().nextInt(1000000);
    super.initState();
  }

  List<Widget> ques = [];
  int coins = 0;
  int tid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitzenAdminCubit, FitzenAdminState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: 305,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              "Coins Wallet",
                              style: TextStyle(
                                  color: Color(0xff155E63),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: Column(
                              children: [
                                new ListTile(
                                  leading: Icon(
                                    Icons.fiber_manual_record,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  title: new Text(
                                    'Number is showing coins you have earned.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                new ListTile(
                                  leading: Icon(Icons.fiber_manual_record,
                                      color: Colors.black, size: 18),
                                  title: new Text(
                                    'Each Coin is equal to ₹1, Real Money.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                new ListTile(
                                  leading: Icon(Icons.fiber_manual_record,
                                      color: Colors.black, size: 18),
                                  title: new Text(
                                    'You can withdraw these coins to you bank account as real money.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SwipingButton(
                                    text: "Withdraw Money",
                                    onSwipeCallback: () async {
                                      if (coins >= 30) {
                                        try {
                                          var snap = await FirebaseFirestore
                                              .instance
                                              .collection("Partner_Users")
                                              .doc(cru.getuid())
                                              .get();
                                          if (snap.data()["Bank_Details"]) {
                                            toast(
                                                "Withdraw Inititated for ₹$coins");
                                            FirebaseFirestore.instance
                                                .collection("Partner_Users")
                                                .doc(cru.getuid())
                                                .set({
                                              "Data": {"Coins": 0}
                                            }, SetOptions(merge: true));
                                            FirebaseFirestore.instance
                                                .collection("Partner_Users")
                                                .doc(cru.getuid())
                                                .set({
                                              "Withdrawals": {
                                                tid.toString(): {
                                                  "Amount": coins,
                                                  "Date": DateTime.now()
                                                      .toIso8601String(),
                                                  "Status": "Pending!"
                                                }
                                              }
                                            }, SetOptions(merge: true));
                                            FirebaseFirestore.instance
                                                .collection("Partner_Payments")
                                                .doc(tid.toString())
                                                .set({
                                              "Withdrawals_Status": false,
                                              "Amount": coins,
                                              "Bank_No":
                                                  snap.data()["Payout_Details"]
                                                      ["Bank_Number"],
                                              "IFSC":
                                                  snap.data()["Payout_Details"]
                                                      ["IFSC"],
                                              "uid": cru.getuid(),
                                              "Tid": tid.toString()
                                            }, SetOptions(merge: true));
                                            BlocProvider.of<FitzenAdminCubit>(
                                                    context)
                                                .changecoins(0);
                                            coins = 0;
                                          }
                                        } catch (e) {
                                          toast(
                                              "Enter payment Details to withdraw");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Payment_Details()));
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        toast("Minimum Withdraw limit is ₹30");
                                      }
                                    },
                                    height: 40,
                                    swipeButtonColor: Colors.green,
                                    backgroundColor: Colors.green.shade900,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: CircleAvatar(
              backgroundColor: Color(0xff155E63),
              child: Center(
                  child: Text(
                BlocProvider.of<FitzenAdminCubit>(context)
                    .state
                    .coins
                    .toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color(0xff155E63),
            title: Text(
              "Fitzen Partner",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Icon(
                  Icons.account_box,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: BlocProvider.of<FitzenAdminCubit>(context)
                            .state
                            .queslist
                            .length ==
                        0
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
                                  "No Questions left !",
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
                    : BlocProvider.of<FitzenAdminCubit>(context).state.queslist,
              ),
            ],
          )),
        );
      },
    );
  }
}

class Question_wid extends StatelessWidget {
  Question_wid({this.uid});
  String uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => admin_Chat_Screen(
                      uid: uid,
                    )));
      },
      child: Column(
        children: [
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              "Question From \n$uid",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
