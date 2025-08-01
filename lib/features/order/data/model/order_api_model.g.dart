// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      userId: json['userId'] as String,
      products: (json['products'] as List<dynamic>)
          .map(
              (e) => OrderedProductApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      orderType: json['orderType'] as String,
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'date': instance.date?.toIso8601String(),
      'status': instance.status,
      'orderType': instance.orderType,
    };
