import 'package:admin/screens/main_screen.dart';
import 'package:admin/screens/not_verified.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'cubit/fitzen_admin_cubit.dart';
import 'main.dart';

class LoadingScreen2 extends StatefulWidget {
  LoadingScreen2({Key key}) : super(key: key);

  @override
  _LoadingScreen2State createState() => _LoadingScreen2State();
}

class _LoadingScreen2State extends State<LoadingScreen2> {
  Future<void> decide() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("Partner_Users")
          .doc(cru.getuid())
          .get();
      var ver = snap.data()["Verified"];
      if (ver) {
        BlocProvider.of<FitzenAdminCubit>(context).changescreen(Main_Page());
      } else if (!ver) {
        BlocProvider.of<FitzenAdminCubit>(context).changescreen(Not_verified());
      }
    } catch (e) {
      BlocProvider.of<FitzenAdminCubit>(context).changescreen(Not_verified());
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
