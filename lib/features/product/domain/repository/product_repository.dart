import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
import '../entity/product_entity.dart';

abstract class IProductRepository {
  Future<Either<Failure, List<ProductEntity>>> fetchProducts({int limit = 10});
}
