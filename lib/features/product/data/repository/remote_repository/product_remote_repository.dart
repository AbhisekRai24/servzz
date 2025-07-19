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
  }) async {
    try {
      final products = await _productRemoteDataSource.fetchProducts();

      // Slice the list here according to the 'limit'
      final slicedProducts =
          products.length > limit ? products.sublist(0, limit) : products;

      return Right(slicedProducts);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
