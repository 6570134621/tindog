
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangkaew/src/models/product.dart';
import 'package:bangkaew/src/pages/home/widgets/ProductItem.dart';
import 'package:bangkaew/src/services/network_service.dart';
import 'package:bangkaew/src/config/route.dart' as custom_route;
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
class AllDog extends StatefulWidget {
  const AllDog({Key? key}) : super(key: key);

  @override
  State<AllDog> createState() => _AllDogState();
}

class _AllDogState extends State<AllDog> {
  final _spacing = 4.0;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future<QuerySnapshot> getUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('My Dogs'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    ),
      body: _buildNetwork(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, custom_route.Route.management)
              .then((value) {
            setState(() {});
          });
        },
        child: FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  FutureBuilder<List<Product>> _buildNetwork() {
    return FutureBuilder<List<Product>>(
      future: NetworkService().getAllProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product>? product = snapshot.data;
          if (product == null || product.isEmpty) {
            return Container(
              margin: EdgeInsets.only(top: 22),
              alignment: Alignment.topCenter,
              child: Text('No data'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: _buildProductGridView(product),
          );
        }
        if (snapshot.hasError) {
          return Container(
            margin: EdgeInsets.only(top: 22),
            alignment: Alignment.topCenter,
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  GridView _buildProductGridView(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
        top: _spacing,
        bottom: 150,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: _spacing,
        mainAxisSpacing: _spacing,
      ),
      itemBuilder: (context, index) => LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          final product = products[index];
          return ProductItem(
            constraints.maxHeight,
            product,
            onTap: () {
              Navigator.pushNamed(
                context,
                custom_route.Route.management,
                arguments: product,
              ).then((value) {
                setState(() {});
              });
            },
          );
        },
      ),
      itemCount: products.length,
    );
  }
}
