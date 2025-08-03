import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/features/cart/domain/model/cart_item.dart';
import 'package:servzz/features/cart/presentation/view/order_type.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_state.dart';
import 'package:servzz/features/order/data/model/order_api_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_event.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_state.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  Future<void> _showOrderTypeDialog(
    BuildContext context,
    CartState cartState,
  ) async {
    final orderType = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return OrderTypeDialog(
          onOrderTypeSelected: (String selectedOrderType) {
            Navigator.of(dialogContext).pop(selectedOrderType);
          },
        );
      },
    );

    if (orderType == null) {
      // User canceled dialog
      return;
    }

    final tokenPrefs = serviceLocator<TokenSharedPrefs>();
    final orderBloc = context.read<OrderViewModel>();

    // Await userId from shared prefs
    final userIdResult = await tokenPrefs.getToken();

    userIdResult.fold(
      (failure) {
        // Show error if failed to get userId/token
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get user ID: ${failure.message}')),
        );
      },
      (userId) {
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User ID is missing. Please log in again.'),
            ),
          );
          return;
        }

        final products =
            cartState.items.map((item) => item.toOrderedProduct()).toList();
        final total = cartState.totalPrice;

        final order = OrderEntity(
          userId: userId,
          products: products,
          total: total,
          date: DateTime.now(),
          status: 'pending',
          orderType: orderType,
        );
        final orderApiModel = OrderApiModel.fromEntity(order);
        print(
          'Dispatching CreateOrderEvent with order: ${orderApiModel.toJson()}',
        );
        orderBloc.add(CreateOrderEvent(order));
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String orderType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Order Placed!'),
            ],
          ),
          content: Text(
            'Your ${orderType == 'dine-in' ? 'Dine In' : 'Takeaway'} order has been placed successfully.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate back to home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Order Failed'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderViewModel, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Placing your order...'),
                    ],
                  ),
                ),
          );
        } else {
          // Remove loading dialog if present
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state is OrderSuccess) {
          print('Order successful: ${state.order?.orderType}');
          _showSuccessDialog(context, state.order?.orderType ?? 'your');

          // Clear cart after successful order (add ClearCart event to your cart_event.dart if not exists)
          context.read<CartViewModel>().add(ClearCart());
        }

        if (state is OrderFailure) {
          print('Order failed: ${state.message}');
          _showErrorDialog(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        body: BlocBuilder<CartViewModel, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final CartItem item = state.items[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.product.imageUrl != null &&
                            item.product.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 80),
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.addons.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  "Addons:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                for (var addon in item.addons)
                                  Text(
                                    '${addon.name} x${addon.quantity} - Rs ${addon.price.toInt()}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Total: Rs ${item.totalPrice.toInt()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        context.read<CartViewModel>().add(
                                          UpdateQuantity(
                                            productId: item.product.productId!,
                                            quantity: item.quantity - 1,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      context.read<CartViewModel>().add(
                                        UpdateQuantity(
                                          productId: item.product.productId!,
                                          quantity: item.quantity + 1,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            context.read<CartViewModel>().add(
                              RemoveFromCart(item.product.productId!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item.product.name} removed from cart',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CartViewModel, CartState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    offset: const Offset(0, -1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total: Rs ${state.totalPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed:
                        state.items.isEmpty
                            ? null
                            : () => _showOrderTypeDialog(context, state),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
