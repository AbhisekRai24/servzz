import 'package:servzz/features/order/data/model/order_api_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> createOrder(OrderApiModel order);
}
