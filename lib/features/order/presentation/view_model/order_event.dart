import 'package:equatable/equatable.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrderEvent {
  final OrderEntity order;

  const CreateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}
