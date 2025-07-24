import 'package:equatable/equatable.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

// abstract class OrderEvent extends Equatable {
//   const OrderEvent();

//   @override
//   List<Object?> get props => [];
// }

// class CreateOrderEvent extends OrderEvent {
//   final OrderEntity order;

//   const CreateOrderEvent(this.order);

//   @override
//   List<Object?> get props => [order];
// }

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

class LoadUserOrdersEvent extends OrderEvent {
  final String userId;

  const LoadUserOrdersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshUserOrdersEvent extends OrderEvent {
  final String userId;

  const RefreshUserOrdersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
