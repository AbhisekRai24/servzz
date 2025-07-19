import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:servzz/features/product/domain/use_case/product_fetch_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'package:servzz/core/error/failure.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUsecase _fetchProductsUsecase;

  ProductBloc(this._fetchProductsUsecase) : super(const ProductState.initial()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _fetchProductsUsecase.call(
      FetchProductsParams(limit: event.limit),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (products) {
        emit(state.copyWith(isLoading: false, products: products, error: null));
      },
    );
  }
}
