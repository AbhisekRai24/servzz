import 'package:equatable/equatable.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

// abstract class OrderState extends Equatable {
//   const OrderState();

//   @override
//   List<Object?> get props => [];
// }

// class OrderInitial extends OrderState {}

// class OrderLoading extends OrderState {}

// class OrderSuccess extends OrderState {
//   final OrderEntity order;

//   const OrderSuccess(this.order);

//   @override
//   List<Object?> get props => [order];
// }

// class OrderFailure extends OrderState {
//   final String message;

//   const OrderFailure(this.message);

//   @override
//   List<Object?> get props => [message];
// }
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderEntity order;

  const OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderListSuccess extends OrderState {
  final List<OrderEntity> orders;

  const OrderListSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}
class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}
class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);

  @override
  List<Object?> get props => [message];
}