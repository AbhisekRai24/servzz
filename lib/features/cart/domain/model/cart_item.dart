// lib/features/cart/domain/models/cart_item.dart
import 'package:servzz/features/cart/domain/addon.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

class CartItem {
  final ProductEntity product;
  final int quantity;
  final List<Addon> addons;

  CartItem({required this.product, this.quantity = 1, this.addons = const []});

  CartItem copyWith({int? quantity, List<Addon>? addons}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      addons: addons ?? this.addons,
    );
  }

  double get totalPrice {
    final addonsTotal = addons.fold(
      0.0,
      (sum, a) => sum + a.price * a.quantity,
    );
    return product.price * quantity + addonsTotal;
  }
}
