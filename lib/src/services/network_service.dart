import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bangkaew/src/constants/api.dart';
import 'package:bangkaew/src/models/product.dart';
import 'dart:io';
import 'package:bangkaew/src/models/post.dart';
import 'package:http_parser/http_parser.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;
  static final _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = API.BASE_URL;
          //options.connectTimeout = 5000;
          //options.receiveTimeout = 3000;
          print(options.baseUrl + options.path);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          return handler.next(e);
        },
      ),
    );

  Future<List<Product>> getAllProduct() async {
    final url = API.PRODUCT;
    final Response response = await _dio.get(url);
    if (response.statusCode == 200) {
      return productFromJson(jsonEncode(response.data));
    }
    throw Exception('Network failed');
  }

  Future<String> addProduct(Product product, {required File imageFile}) async {
    final url = API.PRODUCT;

    FormData data = FormData.fromMap({
      'name': product.name,
      'detail': product.detail,
      'age': product.age,
      if (imageFile != null)
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          contentType: MediaType('image', 'jpg'),
        )
    });

    final Response response = await _dio.post(url, data: data);
    if (response.statusCode == 201) {
      return 'Add Successfully';
    }
    throw Exception('Network failed');
  }

  Future<String> editProduct(Product product, {File? imageFile}) async {
    final url = '${API.PRODUCT}/${product.id}';

    FormData data = FormData.fromMap({
      'name': product.name,
      'detail': product.detail,
      'age': product.age,
      if (imageFile != null)
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          contentType: MediaType('image', 'jpg'),
        )
    });

    final Response response = await _dio.put(url, data: data);
    if (response.statusCode == 200) {
      return 'Edit Successfully';
    }
    throw Exception('Network failed');
  }

  Future<String> deleteProduct(int productId) async {
    final url = '${API.PRODUCT}/$productId';

    final Response response = await _dio.delete(url);
    if (response.statusCode == 204) {
      return 'Delete Successfully';
    }
    throw Exception('Network failed');
  }

  Future<List<Post>> fetchPosts(int startIndex, {int limit = 10}) async {
    final url =
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit';
    final Response response = await _dio.get(url);
    if (response.statusCode == 200) {
      return postFromJson(jsonEncode(response.data));
    }
    throw Exception('Network failed');
  }
}
