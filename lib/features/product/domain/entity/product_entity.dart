import 'package:equatable/equatable.dart';


class ProductEntity extends Equatable {
  final String? productId;
  final String name;
  final String? description;  // Nullable now
  final String? imageUrl;     // Nullable now
  final double price;
  final String? categoryId;   // Nullable now

  const ProductEntity({
    this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
        productId,
        name,
        description,
        imageUrl,
        price,
        categoryId,
      ];
}
