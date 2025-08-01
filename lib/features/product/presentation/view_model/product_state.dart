import 'package:equatable/equatable.dart';
import '../../domain/entity/product_entity.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> products;
  final String? error;

  const ProductState({
    required this.isLoading,
    required this.products,
    this.error,
  });

  const ProductState.initial()
      : isLoading = false,
        products = const [],
        error = null;

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, products, error];
}
