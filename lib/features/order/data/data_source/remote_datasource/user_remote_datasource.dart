import 'package:dio/dio.dart';
import 'package:servzz/features/order/data/data_source/order_datasource.dart';
import 'package:servzz/features/order/data/model/order_api_model.dart';
import 'package:servzz/app/constant/api_endpoints.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createOrder(OrderApiModel order) async {
    await dio.post(
      ApiEndpoints.createOrder,
      data: order.toJson(),
    );
  }
}
