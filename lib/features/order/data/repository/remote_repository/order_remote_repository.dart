import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
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
   @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId) async {
  try {
    final orderModels = await remoteDataSource.getUserOrders(userId);
    final orderEntities = orderModels.map((model) => model.toEntity()).toList();
    return Right(orderEntities);
  } catch (e) {
    return Left(ServerFailure(message: 'Failed to load orders'));
  }
}
}
