import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/cart/domain/model/cart_item.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_state.dart';
import 'package:servzz/features/order/presentation/view_model/order_event.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_state.dart'; // Import your order states
import 'package:servzz/features/order/domain/entity/order_entity.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderViewModel, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          // Remove loading dialog if present
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is OrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')),
          );
          // Optionally clear cart or navigate somewhere
        }

        if (state is OrderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(title: const Text('Your Cart')),
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
                            : () {
                              final orderBloc = context.read<OrderViewModel>();

                              final userId =
                                  'user-id'; // Replace with real user id

                              final products =
                                  state.items
                                      .map((item) => item.toOrderedProduct())
                                      .toList();

                              final total = state.totalPrice;

                              final order = OrderEntity(
                                userId: userId,
                                products: products,
                                total: total,
                                date: DateTime.now(),
                                status: 'pending',
                                orderType: 'takeaway', // Or get from UI
                              );

                              orderBloc.add(CreateOrderEvent(order));
                            },
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
