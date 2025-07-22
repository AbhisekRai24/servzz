import 'package:servzz/features/order/data/data_source/order_datasource.dart';
import 'package:servzz/features/order/data/model/order_api_model.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';
import 'package:servzz/features/order/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createOrder(OrderEntity order) async {
    final orderApiModel = OrderApiModel.fromEntity(order);
    return remoteDataSource.createOrder(orderApiModel);
  }
}
