import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/features/product/data/model/product_api_model.dart';
import '../../domain/entity/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductEntity>> fetchProducts() async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.product}');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final allProducts =
          data
              .map(
                (json) =>
                    ProductApiModel.fromJson(
                      json as Map<String, dynamic>,
                    ).toEntity(),
              )
              .toList();

      // Slice to get first 10 products or fewer if less than 10 available
      final slicedProducts =
          allProducts.length > 10 ? allProducts.sublist(0, 10) : allProducts;

      return slicedProducts;
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
