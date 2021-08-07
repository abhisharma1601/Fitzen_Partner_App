import 'package:admin/Login/data_entry.dart';
import 'package:admin/Login/main_screen.dart';
import 'package:admin/cubit/fitzen_admin_cubit.dart';
import 'package:admin/screens/main_screen.dart';
import 'package:admin/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

String mobilenumber;
String uid;
bool spin = false;
CurrentUser cru;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return BlocProvider(
          create: (context) => FitzenAdminCubit(),
          child: BlocBuilder<FitzenAdminCubit, FitzenAdminState>(
            builder: (context, state) {
              return MaterialApp(
                theme: ThemeData(
                    fontFamily: "OpenSans",
                    primaryColor: Colors.black,
                    accentColor: Colors.white),
                initialRoute: 'Home',
                routes: {
                  'Home': (context) =>
                      BlocProvider.of<FitzenAdminCubit>(context).state.screen,
                },
              );
            },
          ),
        );
      });
    });
  }
}
