import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

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
  final String? categoryId;

  const ProductApiModel({
    this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.categoryId,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      productId: entity.productId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      price: entity.price,
      categoryId: entity.categoryId,
    );
  }

  ProductEntity toEntity() {
    final normalizedImagePath = imageUrl?.replaceAll("\\", "/") ?? '';
    final cleanedBaseUrl =
        ApiEndpoints.baseUrl.endsWith('/')
            ? ApiEndpoints.baseUrl.substring(0, ApiEndpoints.baseUrl.length - 1)
            : ApiEndpoints.baseUrl;

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
      categoryId: categoryId ?? '',
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    description,
    imageUrl,
    price,
    categoryId,
  ];
}
