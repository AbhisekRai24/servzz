import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/features/cart/domain/model/cart_item.dart';
import 'package:servzz/features/cart/presentation/view/order_type.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_state.dart';
import 'package:servzz/features/order/data/model/order_api_model.dart'; // Ensure this import is correct if used
import 'package:servzz/features/order/presentation/view_model/order_event.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_state.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  // Define a primary red color and a complementary darker shade
  static const Color primaryRed = Color(0xFFE53935); // A vibrant red
  static const Color darkGrey = Color(0xFF333333); // A dark, almost black, grey

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
        if (userId == null || userId.isEmpty) {
          // Added check for empty userId
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Order Placed!',
                style: TextStyle(color: darkGrey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Your ${orderType == 'dine-in' ? 'Dine In' : 'Takeaway'} order has been placed successfully.',
            style: const TextStyle(fontSize: 16, color: darkGrey),
          ),
          actions: [
            TextButton(
              // Changed to TextButton for a flatter look
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryRed, // Use our primary red
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('OKAY'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.error, color: primaryRed, size: 30), // Use primaryRed
              SizedBox(width: 10),
              Text(
                'Order Failed',
                style: TextStyle(color: darkGrey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(message, style: const TextStyle(color: darkGrey)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: primaryRed, // Use our primary red
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('DISMISS'),
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(
                        color: primaryRed,
                      ), // Use primaryRed
                      SizedBox(width: 20),
                      Text(
                        'Placing your order...',
                        style: TextStyle(color: darkGrey),
                      ),
                    ],
                  ),
                ),
          );
        } else {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state is OrderSuccess) {
          print('Order successful: ${state.order?.orderType}');
          _showSuccessDialog(context, state.order?.orderType ?? 'your');
          context.read<CartViewModel>().add(ClearCart());
        }

        if (state is OrderFailure) {
          print('Order failed: ${state.message}');
          _showErrorDialog(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor:
            Colors.grey[50], // Lighter background for better contrast

        body: BlocBuilder<CartViewModel, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding delicious items!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ), // Increased padding
              itemCount: state.items.length,
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(height: 12), // More space between items
              itemBuilder: (context, index) {
                final CartItem item = state.items[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Slightly more rounded
                  ),
                  elevation: 4, // Increased elevation for a richer look
                  shadowColor: Colors.black.withOpacity(
                    0.1,
                  ), // Softer shadow color
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ), // Increased padding inside card
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .center, // Center items vertically in row
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Rounded image corners
                          child:
                              item.product.imageUrl != null &&
                                      item.product.imageUrl!.isNotEmpty
                                  ? Image.network(
                                    item.product.imageUrl!,
                                    width: 90, // Slightly larger image
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          width: 90,
                                          height: 90,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  )
                                  : Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
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
                                  color: darkGrey, // Use darkGrey for text
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.addons.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  "Add-ons:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: darkGrey,
                                    fontSize: 13,
                                  ),
                                ),
                                for (var addon in item.addons)
                                  Text(
                                    '${addon.name} x${addon.quantity} - Rs ${addon.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Rs ${item.totalPrice.toInt()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800, // Extra bold
                                  fontSize: 17,
                                  color:
                                      primaryRed, // Highlight total with primary red
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: primaryRed,
                                size: 28,
                              ), // Larger, filled icon
                              onPressed: () {
                                context.read<CartViewModel>().add(
                                  UpdateQuantity(
                                    productId: item.product.productId!,
                                    quantity: item.quantity + 1,
                                  ),
                                );
                              },
                              visualDensity:
                                  VisualDensity.compact, // Reduce padding
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkGrey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.grey,
                                size: 28,
                              ), // Larger, filled icon, subtle color
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartViewModel>().add(
                                    UpdateQuantity(
                                      productId: item.product.productId!,
                                      quantity: item.quantity - 1,
                                    ),
                                  );
                                } else {
                                  // Optionally show a dialog before removing last item
                                  _showRemoveConfirmationDialog(context, item);
                                }
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8), // Added some spacing
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever, // Stronger delete icon
                            color:
                                Colors
                                    .redAccent, // A slightly different red for delete
                            size: 28,
                          ),
                          onPressed: () {
                            _showRemoveConfirmationDialog(context, item);
                          },
                          visualDensity: VisualDensity.compact,
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
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                20,
              ), // More vertical padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ), // Rounded top corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(
                      0.15,
                    ), // Stronger, yet soft shadow
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: darkGrey,
                        ),
                      ),
                      Text(
                        'Rs ${state.totalPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 26, // Larger total price
                          fontWeight: FontWeight.w900, // Extra heavy
                          color: primaryRed, // Highlight with primary red
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // More space before button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ), // Taller button
                      backgroundColor: primaryRed, // Use primary red
                      foregroundColor: Colors.white, // White text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // More rounded button
                      ),
                      elevation: 5, // Add elevation to button
                    ),
                    onPressed:
                        state.items.isEmpty
                            ? null // Disable if cart is empty
                            : () => _showOrderTypeDialog(context, state),
                    child: const Text(
                      'Proceed to Checkout', // More descriptive text
                      style: TextStyle(
                        fontSize: 19, // Larger text
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8, // Slight letter spacing
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

  void _showRemoveConfirmationDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Remove Item?', style: TextStyle(color: darkGrey)),
          content: Text(
            'Are you sure you want to remove ${item.product.name} from your cart?',
            style: const TextStyle(color: darkGrey),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'REMOVE',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                context.read<CartViewModel>().add(
                  RemoveFromCart(item.product.productId!),
                );
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.product.name} removed from cart.'),
                    backgroundColor: Colors.red[400],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
