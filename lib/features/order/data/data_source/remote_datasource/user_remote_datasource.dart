import 'package:dio/dio.dart';
import 'package:servzz/features/order/data/data_source/order_datasource.dart';
import 'package:servzz/features/order/data/model/order_api_model.dart';
import 'package:servzz/app/constant/api_endpoints.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createOrder(OrderApiModel order) async {
    await dio.post(ApiEndpoints.createOrder, data: order.toJson());
  }

  @override
  Future<List<OrderApiModel>> getUserOrders(String userId) async {
    try {
      final url = '${ApiEndpoints.getUserOrders}/$userId';
      print('[OrderRemoteDataSource] GET $url');
      final response = await dio.get(url);
      print('[OrderRemoteDataSource] Status code: ${response.statusCode}');
      print('[OrderRemoteDataSource] Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = response.data;
        return ordersJson
            .map((orderJson) => OrderApiModel.fromJson(orderJson))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch orders, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[OrderRemoteDataSource] Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }
}
