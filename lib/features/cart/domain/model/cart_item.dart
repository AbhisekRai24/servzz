// lib/features/cart/domain/models/cart_item.dart
import 'package:servzz/features/cart/domain/model/addon.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';
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

  // Add this method:
  OrderedProductEntity toOrderedProduct() {
    return OrderedProductEntity(
      id: product.productId!, // your product ID
      name: product.name,

      quantity: quantity,
      price: product.price, // price per unit (without addons)
      addons:
          addons
              .map(
                (addon) => AddonEntity(
                  addonId:
                      addon
                          .name, // assuming your Addon class has addonId field, else use addon name or another id
                  price: addon.price,
                  quantity: addon.quantity,
                ),
              )
              .toList(),
    );
  }
}
