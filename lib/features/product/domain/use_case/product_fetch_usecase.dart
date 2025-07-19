import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repository.dart';

class FetchProductsParams extends Equatable {
  final int limit;

  const FetchProductsParams({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class FetchProductsUsecase implements UsecaseWithParams<List<ProductEntity>, FetchProductsParams> {
  final IProductRepository _productRepository;

  FetchProductsUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(FetchProductsParams params) async {
    final result = await _productRepository.fetchProducts(limit: params.limit);
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products),
    );
  }
}
