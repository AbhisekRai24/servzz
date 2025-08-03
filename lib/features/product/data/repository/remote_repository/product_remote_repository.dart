import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/product/data/data_source/product_remote_data_source.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
import 'package:servzz/features/product/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRemoteRepository({
    required ProductRemoteDataSource productRemoteDataSource,
  }) : _productRemoteDataSource = productRemoteDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProducts({
    int limit = 10,
    int page = 1,
    String? search,
  }) async {
    try {
      final products = await _productRemoteDataSource.fetchProducts(
        limit: limit,
        page: page,
        search: search,
      );

      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
