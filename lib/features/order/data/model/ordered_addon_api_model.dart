import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/order_entity.dart';

part 'ordered_addon_api_model.g.dart';

@JsonSerializable()
class OrderedAddonApiModel extends Equatable {
  final String addonId;
  final double price;
  final int quantity;

  const OrderedAddonApiModel({
    required this.addonId,
    required this.price,
    required this.quantity,
  });

  factory OrderedAddonApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderedAddonApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedAddonApiModelToJson(this);

  factory OrderedAddonApiModel.fromEntity(AddonEntity entity) {
    return OrderedAddonApiModel(
      addonId: entity.addonId,
      price: entity.price,
      quantity: entity.quantity,
    );
  }

  AddonEntity toEntity() {
    return AddonEntity(
      addonId: addonId,
      price: price,
      quantity: quantity,
    );
  }

  @override
  List<Object?> get props => [addonId, price, quantity];
}
