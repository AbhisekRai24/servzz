// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordered_addon_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderedAddonApiModel _$OrderedAddonApiModelFromJson(
        Map<String, dynamic> json) =>
    OrderedAddonApiModel(
      addonId: json['addonId'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$OrderedAddonApiModelToJson(
        OrderedAddonApiModel instance) =>
    <String, dynamic>{
      'addonId': instance.addonId,
      'price': instance.price,
      'quantity': instance.quantity,
    };
