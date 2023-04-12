import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tindog/src/bloc/species/species_bloc.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
import 'package:tindog/src/constants/setting.dart';
import 'package:tindog/src/pages/home/home_page.dart';
import 'package:tindog/src/pages/login/login_page.dart';


class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final speciesSelected = BlocProvider<SpeciesBloc>(create: (create) => SpeciesBloc());
    return MultiBlocProvider(
      providers: [speciesSelected],
      child: MaterialApp(
        routes: custom_route.Route.getAll(),
        title: 'TinDog',
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
