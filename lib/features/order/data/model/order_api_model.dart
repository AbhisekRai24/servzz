import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/features/order/data/model/ordered_product_api_model.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';


// dart run build_runner build -d
part 'order_api_model.g.dart'; 

@JsonSerializable(explicitToJson: true)
class OrderApiModel extends Equatable {
  final String userId;
  final List<OrderedProductApiModel> products;
  final double total;
  final DateTime? date;
  final String status; // e.g., "pending", "completed"
  final String orderType; // e.g., "dine-in", "takeaway"

  const OrderApiModel({
    required this.userId,
    required this.products,
    required this.total,
    this.date,
    required this.status,
    required this.orderType,
  });

  /// From JSON
  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  /// Convert from Entity to ApiModel
  factory OrderApiModel.fromEntity(OrderEntity entity) {
    return OrderApiModel(
      userId: entity.userId,
      products: entity.products
          .map((product) => OrderedProductApiModel.fromEntity(product))
          .toList(),
      total: entity.total,
      date: entity.date,
      status: entity.status,
      orderType: entity.orderType,
    );
  }

  /// Convert ApiModel to Entity
  OrderEntity toEntity() {
    return OrderEntity(
      userId: userId,
      products: products.map((product) => product.toEntity()).toList(),
      total: total,
      date: date,
      status: status,
      orderType: orderType,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        products,
        total,
        date,
        status,
        orderType,
      ];
}
