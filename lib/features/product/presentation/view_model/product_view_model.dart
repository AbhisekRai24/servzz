import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/product/domain/use_case/product_fetch_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUsecase _fetchProductsUsecase;

  ProductBloc(this._fetchProductsUsecase)
    : super(const ProductState.initial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<NavigateToProductDetailEvent>(_onNavigateToDetail);
  }
  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _fetchProductsUsecase.call(
      FetchProductsParams(
        limit: event.limit ?? 10,
        page: event.page ?? 1,
        search: event.search,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (products) {
        // Append or replace products based on page
        List<ProductEntity> updatedProducts;
        if ((event.page ?? 1) > 1) {
          updatedProducts = List.of(state.products)..addAll(products);
        } else {
          updatedProducts = products;
        }

        emit(
          state.copyWith(
            isLoading: false,
            products: updatedProducts,
            error: null,
          ),
        );
      },
    );
  }

  void _onNavigateToDetail(
    NavigateToProductDetailEvent event,
    Emitter<ProductState> emit,
  ) {
    // Navigation logic usually done in UI layer
  }
}
