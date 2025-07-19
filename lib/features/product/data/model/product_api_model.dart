import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/features/category/data/model/category_api_model.dart';
import 'package:servzz/features/product/data/model/add_on_api_model.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

import 'package:logging/logging.dart';

// dart run build_runner build -d
part 'product_api_model.g.dart';

final _logger = Logger('ProductRemoteDataSource');

void setupLogging() {
  Logger.root.level = Level.ALL; // capture all logs
  Logger.root.onRecord.listen((record) {
    // You can customize output here (e.g., write to file, etc.)
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;

  final String name;
  final String? description;

  @JsonKey(name: 'productImage')
  final String? imageUrl;

  final double price;

  final CategoryApiModel? category;

  final String? sellerId; // new

  final List<AddonApiModel> addons; // new

  const ProductApiModel({
    this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.category,
    this.sellerId,
    this.addons = const [], // default empty array
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    _logger.info('DEBUG: Raw Product JSON: $json');

    // Handle image
    final imageData = json['productImage'];
    String? imageUrl;
    if (imageData is String) {
      imageUrl = imageData;
    } else if (imageData is Map<String, dynamic>) {
      imageUrl = imageData['url'] as String?;
    }

    // Handle category
    CategoryApiModel? category;
    if (json['categoryId'] is Map<String, dynamic>) {
      category = CategoryApiModel.fromJson(json['categoryId']);
    }

    // Handle sellerId (string or map)
    String? sellerId;
    final seller = json['sellerId'];
    if (seller is String) {
      sellerId = seller;
    } else if (seller is Map<String, dynamic>) {
      sellerId = seller['_id'] as String?;
    }

    // Handle addons
    List<AddonApiModel> addons = [];
    if (json['addons'] is List) {
      addons =
          (json['addons'] as List)
              .map((e) => AddonApiModel.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    return ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] ?? '',
      description: json['description'] as String?,
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: category,
      sellerId: sellerId,
      addons: addons,
    );
  }
  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      productId: entity.productId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      price: entity.price,
      category:
          entity.category != null
              ? CategoryApiModel(
                categoryId: entity.category!.categoryId,
                name: entity.category!.name,
              )
              : null,
      sellerId: entity.sellerId,
      addons:
          entity.addons
              ?.map(
                (addon) => AddonApiModel(name: addon.name, price: addon.price),
              )
              .toList() ??
          [],
    );
  }

  ProductEntity toEntity() {
    var normalizedImagePath = imageUrl?.replaceAll("\\", "/") ?? '';

    if (normalizedImagePath.startsWith('/api/')) {
      normalizedImagePath = normalizedImagePath.replaceFirst('/api', '');
    }

    final cleanedBaseUrl =
        ApiEndpoints.baseImgUrl.endsWith('/')
            ? ApiEndpoints.baseImgUrl.substring(
              0,
              ApiEndpoints.baseImgUrl.length - 1,
            )
            : ApiEndpoints.baseImgUrl;

    final fullImageUrl =
        normalizedImagePath.startsWith('/')
            ? '$cleanedBaseUrl$normalizedImagePath'
            : '$cleanedBaseUrl/$normalizedImagePath';

    return ProductEntity(
      productId: productId,
      name: name,
      description: description ?? '',
      imageUrl: fullImageUrl,
      price: price,
      category: category?.toEntity(),
      sellerId: sellerId,
      addons: addons.map((a) => a.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    description,
    imageUrl,
    price,
    category,
    sellerId,
    addons,
  ];
}
