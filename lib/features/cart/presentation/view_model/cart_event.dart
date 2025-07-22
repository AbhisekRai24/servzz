import 'package:equatable/equatable.dart';
import 'package:servzz/features/cart/domain/model/addon.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final ProductEntity product;
  final int quantity;
  final List<Addon> addons;

  AddToCart({required this.product, this.quantity = 1, this.addons = const []});

  @override
  List<Object?> get props => [product.productId, quantity, addons];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  UpdateQuantity({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}
