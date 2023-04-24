import 'package:bangkaew/src/provider/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangkaew/src/bloc/species/species_bloc.dart';
import 'package:bangkaew/src/config/route.dart' as custom_route;
import 'package:bangkaew/src/constants/setting.dart';
import 'package:bangkaew/src/pages/home/home_page.dart';
import 'package:bangkaew/src/pages/login/login_page.dart';


class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final speciesSelected = BlocProvider<SpeciesBloc>(create: (create) => SpeciesBloc());
    return MultiBlocProvider(
      providers: [speciesSelected],
      child: MaterialApp(
          routes: custom_route.Route.getAll(),
          title: 'bangkaew',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            )
          ),

          // home: HomePage(),
          home: FutureBuilder<DocumentSnapshot<Object?>>(
            future: FirebaseFirestore.instance.collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data?.data() != null) {
                  return HomePage();
                } else {
                  return LoginPage();
                }
              }
              return SizedBox();
            },
          ),
        ),

    );
  }
}
