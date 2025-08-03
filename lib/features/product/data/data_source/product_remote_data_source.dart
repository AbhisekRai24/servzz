import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/features/product/data/model/product_api_model.dart';
import '../../domain/entity/product_entity.dart';

import 'package:logging/logging.dart';

final _logger = Logger('ProductRemoteDataSource');

void setupLogging() {
  Logger.root.level = Level.ALL; // capture all logs
  Logger.root.onRecord.listen((record) {
    // You can customize output here (e.g., write to file, etc.)
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> fetchProducts({
    int limit = 10,
    int page = 1,
    String? search,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductEntity>> fetchProducts({
    int limit = 10,
    int page = 1,
    String? search,
  }) async {
    // Build query parameters
    final queryParameters = {
      'limit': limit.toString(),
      'page': page.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final uri = Uri.parse(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.product}',
    ).replace(queryParameters: queryParameters);
    _logger.info('Fetching products from: $uri');

    final response = await client.get(uri);

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

      return allProducts;
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
