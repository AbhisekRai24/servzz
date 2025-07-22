import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/features/order/data/model/ordered_addon_api_model.dart';

import '../../domain/entity/order_entity.dart';

part 'ordered_product_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderedProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final int quantity;
  final double price;
  final List<OrderedAddonApiModel> addons;

  const OrderedProductApiModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.addons,
  });

  factory OrderedProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderedProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedProductApiModelToJson(this);

  factory OrderedProductApiModel.fromEntity(OrderedProductEntity entity) {
    return OrderedProductApiModel(
      id: entity.id,
      quantity: entity.quantity,
      price: entity.price,
      addons:
          entity.addons.map((addon) => OrderedAddonApiModel.fromEntity(addon)).toList(),
    );
  }

  OrderedProductEntity toEntity() {
    return OrderedProductEntity(
      id: id,
      quantity: quantity,
      price: price,
      addons: addons.map((a) => a.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [id, quantity, price, addons];
}
