import 'package:equatable/equatable.dart';
import 'package:servzz/features/category/domain/entity/category_entity.dart';
import 'package:servzz/features/product/domain/entity/add_on_entity.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final CategoryEntity? category;
  final String? sellerId; // add sellerId
  final List<AddonEntity>? addons; // add addons

  const ProductEntity({
    this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.category,
    this.sellerId,
    this.addons,
  });

  @override
  List<Object?> get props => [
    productId,
    name,
    description,
    imageUrl,
    price,
    category,
    sellerId,
    addons,
  ];
}
