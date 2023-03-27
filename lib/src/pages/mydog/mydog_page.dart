// import 'package:flutter/material.dart';
//
// class Dog {
//   final String name;
//   final String breed;
//   final int age;
//   final String image;
//
//   Dog({
//     required this.name,
//     required this.breed,
//     required this.age,
//     required this.image,
//   });
// }
//
// final List<Dog> dogs = [
//   Dog(
//     name: 'Buddy',
//     breed: 'Beagle',
//     age: 5,
//     image: 'assets/images/beagle.jpeg',
//   ),
//   Dog(
//     name: 'Max',
//     breed: 'German Shepherd',
//     age: 3,
//     image: 'assets/images/pitbull.jpeg',
//   ),
//   Dog(
//     name: 'Lucy',
//     breed: 'Beagle',
//     age: 2,
//     image: 'assets/images/beagle.jpeg',
//   ),
//   Dog(
//     name: 'Daisy',
//     breed: 'Golden Retriever',
//     age: 4,
//     image: 'assets/images/pitbull.jpeg',
//   ),
//   Dog(
//     name: 'Charlie',
//     breed: 'Pitbull',
//     age: 7,
//     image: 'assets/images/pitbull.jpeg',
//   ),
//   Dog(
//     name: 'Rocky',
//     breed: 'Siberian Husky',
//     age: 6,
//     image: 'assets/images/pitbull.jpeg',
//   ),
// ];
//
// class DogGrid extends StatelessWidget {
//   const DogGrid({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Dog')),
//       body: GridView.builder(
//         itemCount: dogs.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8,
//           mainAxisSpacing: 8,
//         ),
//         itemBuilder: (context, index) {
//           final dog = dogs[index];
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Image.asset(dog.image, height: 100),
//                 Text(dog.name),
//                 Text(dog.breed),
//                 Text('${dog.age} years old'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/models/product.dart';
import 'package:tindog/src/pages/home/widgets/ProductItem.dart';
import 'package:tindog/src/services/network_service.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
class AllDog extends StatefulWidget {
  const AllDog({Key? key}) : super(key: key);

  @override
  State<AllDog> createState() => _AllDogState();
}

class _AllDogState extends State<AllDog> {
  final _spacing = 4.0;

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
