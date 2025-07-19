// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['productImage'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] == null
          ? null
          : CategoryApiModel.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'description': instance.description,
      'productImage': instance.imageUrl,
      'price': instance.price,
      'category': instance.category,
    };
