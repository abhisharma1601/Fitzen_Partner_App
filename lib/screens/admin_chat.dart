import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class admin_Chat_Screen extends StatefulWidget {
  admin_Chat_Screen({this.uid});
  String uid;
  @override
  _admin_Chat_ScreenState createState() => _admin_Chat_ScreenState();
}

class _admin_Chat_ScreenState extends State<admin_Chat_Screen> {
  @override
  List<Widget> chats = [];
  String chat = "empty!";
  TextEditingController chatcontro = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff155E63),
        title: Text(
          "Answer questions",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Partner_pannel")
                      .doc(widget.uid)
                      .collection("Chats")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      chats = [];
                      final messages = snapshot.data.docs;
                      for (var msg in messages) {
                        if (!msg.data()["sender"]) {
                          chats.add(
                            user_que(que: msg.data()["msg"]),
                          );
                        } else if (msg.data()["sender"]) {
                          chats.add(user_ans(
                            text: msg.data()["msg"],
                          ));
                        }
                      }
                      return Column(
                        children: chats,
                      );
                    }
                    if (!snapshot.hasData) {
                      return Column(
                        children: [],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(
            thickness: 0,
            color: Colors.black,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 8),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: chatcontro,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    onChanged: (text) {
                      chat = text;
                    },
                    decoration: new InputDecoration(
                      hintText: "   Type answer here",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 25,
                    ),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(widget.uid)
                          .collection("Chats")
                          .doc(DateTime.now().toString())
                          .set({"msg": chat, "sender": false});
                      FirebaseFirestore.instance
                          .collection("Partner_pannel")
                          .doc(widget.uid)
                          .collection("Chats")
                          .doc(DateTime.now().toString())
                          .set({"msg": chat, "sender": false});
                      FirebaseFirestore.instance
                          .collection("Partner_pannel")
                          .doc(widget.uid)
                          .set({"uid": widget.uid, "answered": true});
                      FirebaseFirestore.instance
                          .collection("Partner_Users")
                          .doc(cru.getuid())
                          .set({
                        "Data": {"Coins": FieldValue.increment(1)}
                      }, SetOptions(merge: true));
                      chatcontro.clear();
                      Navigator.pop(context);
                      
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class user_que extends StatelessWidget {
  user_que({this.que});
  String que;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: Text(que),
          ),
        )
      ],
    );
  }
}

class user_ans extends StatelessWidget {
  user_ans({this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff155E63),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
