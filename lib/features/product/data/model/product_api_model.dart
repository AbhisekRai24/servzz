import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/features/category/data/model/category_api_model.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
// import your new category model

// dart run build_runner build -d
part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;

  final String name;
  final String? description;

  @JsonKey(name: 'productImage')
  final String? imageUrl;

  final double price;

  final CategoryApiModel? category; // updated here

  const ProductApiModel({
    this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.category,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    final imageData = json['productImage'];
    String? imageUrl;

    if (imageData is String) {
      imageUrl = imageData;
    } else if (imageData is Map<String, dynamic>) {
      imageUrl = imageData['url'] as String?;
    }

    // parse category as nested object or null
    CategoryApiModel? category;
    if (json['categoryId'] is Map<String, dynamic>) {
      category = CategoryApiModel.fromJson(json['categoryId']);
    }

    return ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] ?? '',
      description: json['description'] as String?,
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: category,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    // You need to update ProductEntity to include CategoryEntity for full mapping.
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
    );
  }

  ProductEntity toEntity() {
    var normalizedImagePath = imageUrl?.replaceAll("\\", "/") ?? '';

    // Remove "/api" prefix if present
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
  ];
}
