import 'package:servzz/features/order/domain/entity/order_entity.dart';
import 'package:servzz/features/order/domain/repository/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call(OrderEntity order) async {
    return repository.createOrder(order);
  }
}
