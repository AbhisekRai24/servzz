// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
// import 'package:servzz/features/cart/presentation/view_model/cart_state.dart';
// import 'package:servzz/features/order/data/model/order_api_model.dart';
// import 'package:servzz/features/order/domain/model/order_model.dart';
// import 'package:servzz/features/order/presentation/view_model/order_event.dart';
// import 'package:servzz/features/order/presentation/view_model/order_state.dart';
// import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';

// class CheckoutView extends StatelessWidget {
//   const CheckoutView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<OrderViewModel, OrderState>(
//       listener: (context, state) {
//         if (state is OrderSuccessState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Order placed successfully!")),
//           );
//           Navigator.popUntil(context, ModalRoute.withName('/home'));
//         } else if (state is OrderErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error: ${state.message}")),
//           );
//         }
//       },
//       builder: (context, orderState) {
//         return Scaffold(
//           appBar: AppBar(title: const Text('Checkout')),
//           body: BlocBuilder<CartViewModel, CartState>(
//             builder: (context, cartState) {
//               final cartItems = cartState.items;

//               if (cartItems.isEmpty) {
//                 return const Center(child: Text("Your cart is empty."));
//               }

//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.separated(
//                         itemCount: cartItems.length,
//                         separatorBuilder: (_, __) => const Divider(),
//                         itemBuilder: (context, index) {
//                           final item = cartItems[index];
//                           return ListTile(
//                             leading: item.product.imageUrl != null
//                                 ? Image.network(
//                                     item.product.imageUrl!,
//                                     width: 50,
//                                     height: 50,
//                                     errorBuilder: (_, __, ___) =>
//                                         const Icon(Icons.broken_image),
//                                   )
//                                 : const Icon(Icons.image_not_supported),
//                             title: Text(item.product.name),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Quantity: ${item.quantity}"),
//                                 if (item.addons.isNotEmpty)
//                                   ...item.addons.map((addon) => Text(
//                                       '${addon.name} x${addon.quantity}')),
//                               ],
//                             ),
//                             trailing: Text("Rs ${item.totalPrice.toInt()}"),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Total: Rs ${cartState.totalPrice.toInt()}',
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: orderState is OrderLoadingState
//                           ? null
//                           : () {
//                               final order = OrderApiModel.fromCart(cartItems);
//                               context
//                                   .read<OrderViewModel>()
//                                   .add(PlaceOrderEvent(order));
//                             },
//                       child: orderState is OrderLoadingState
//                           ? const CircularProgressIndicator()
//                           : const Text(
//                               'Confirm Order',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
