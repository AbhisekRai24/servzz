import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/cart/domain/model/addon.dart';
import 'package:servzz/features/cart/domain/model/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartViewModel extends Bloc<CartEvent, CartState> {
  CartViewModel() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    bool addonsEqual(List<Addon> a, List<Addon> b) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (a[i].name != b[i].name || a[i].quantity != b[i].quantity) {
          return false;
        }
      }
      return true;
    }

    final index = items.indexWhere((item) =>
        item.product.productId == event.product.productId &&
        addonsEqual(item.addons, event.addons));

    if (index >= 0) {
      final existingItem = items[index];
      items[index] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      items.add(CartItem(
        product: event.product,
        quantity: event.quantity,
        addons: event.addons,
      ));
    }
    emit(state.copyWith(items: items));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items =
        state.items.where((item) => item.product.productId != event.productId).toList();
    emit(state.copyWith(items: items));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final items = state.items.map((item) {
      if (item.product.productId == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: items));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
