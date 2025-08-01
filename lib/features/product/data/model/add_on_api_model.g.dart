// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_on_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddonApiModel _$AddonApiModelFromJson(Map<String, dynamic> json) =>
    AddonApiModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$AddonApiModelToJson(AddonApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };
