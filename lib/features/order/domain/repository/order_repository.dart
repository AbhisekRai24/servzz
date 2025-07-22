import 'package:servzz/features/order/domain/entity/order_entity.dart';

abstract class OrderRepository {
  Future<void> createOrder(OrderEntity order);
}
