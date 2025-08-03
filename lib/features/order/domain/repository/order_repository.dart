import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

abstract class OrderRepository {
  Future<void> createOrder(OrderEntity order);
 Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId);
}
