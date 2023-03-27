import 'package:flutter/material.dart';
import 'package:tindog/src/constants/api.dart';
import 'package:tindog/src/models/product.dart';
import 'package:tindog/src/utils/format.dart';
import 'package:tindog/src/widgets/image_not_found.dart';

class ProductItem extends StatelessWidget {
  final double maxHeight;

  final Product product;

  final VoidCallback onTap;

  const ProductItem(this.maxHeight, this.product, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildImage(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Stack _buildImage() {
    final height = maxHeight * 0.7;
    final productImage = product.image;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: productImage != null && productImage.isNotEmpty
              ? Image.network('${API.IMAGE_URL}/$productImage')
              : ImageNotFound(),
        ),
        //if (product.stock! <= 0) _buildOutOfStock(),
      ],
    );
  }

  Expanded _buildInfo() => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product.age} years',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.detail,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );

  Positioned _buildOutOfStock() => Positioned(
    top: 2,
    right: 2,
    child: Card(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'out of stock',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}
