
import 'package:admin/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Login/data_entry.dart';
import 'Login/main_screen.dart';
import 'cubit/fitzen_admin_cubit.dart';
import 'loading2.dart';
import 'main.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> decide() async {
    try {
      print(FirebaseAuth.instance.currentUser.uid);
      var snap = await FirebaseFirestore.instance
          .collection("Partner_Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      var par = await snap.data()["Data"];
      cru = CurrentUser(
          FirebaseAuth.instance.currentUser.uid, par["Login_Parameter"]);
      bool basic = await snap.data()["Basic_Details"];
      print(basic);
      if (basic) {
        BlocProvider.of<FitzenAdminCubit>(context).changescreen(LoadingScreen2());
      } else if (!basic) {
        BlocProvider.of<FitzenAdminCubit>(context)
            .changescreen(DataEntryPage());
      }
    } catch (e) {
      BlocProvider.of<FitzenAdminCubit>(context)
          .changescreen(main_login_screen());
    }
  }

  @override
  void initState() {
    decide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Image(
                height: 280,
                width: 340,
                image: AssetImage("Assets/images/LGW.png"),
              ),
            ),
          ),
          Spacer(),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
