import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/cart/domain/model/addon.dart' as cart_addon;
import 'package:servzz/features/cart/presentation/view/mycart_view.dart';

import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_state.dart'; // Import CartState

class ProductDetailView extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailView({required this.product, super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  Map<String, cart_addon.Addon> selectedAddons = {};
  // Removed _instructionsController as the text area is no longer needed
  // final TextEditingController _instructionsController = TextEditingController();

  // Define a consistent color palette based on your HTML/CSS
  static const Color primaryRed = Color(0xFFE92932);
  static const Color darkText = Color(0xFF181111);
  static const Color lightGreyBackground = Color(0xFFF4F0F0);
  static const Color borderColor = Color(0xFFE5DCDC);
  // Removed placeholderTextColor as the text area is no longer needed
  // static const Color placeholderTextColor = Color(0xFF886364);

  @override
  void dispose() {
    // Removed dispose for _instructionsController
    // _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white, // Overall background is white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: darkText,
            size: 28,
          ), // 'X' icon from HTML
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<CartViewModel, CartState>(
            builder: (context, state) {
              final totalItems = state.items.fold<int>(
                0,
                (sum, item) => sum + item.quantity,
              );
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: darkText,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartView()),
                      );
                    },
                    tooltip: 'View Cart',
                  ),
                  if (totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primaryRed.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ), // Equivalent to @[480px]:px-4 @[480px]:py-3
              child: Container(
                width: double.infinity,
                height: 218, // min-h-[218px]
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // @[480px]:rounded-xl
                  color: Colors.white, // Fallback if no image
                  image:
                      product.imageUrl != null && product.imageUrl!.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(product.imageUrl!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    product.imageUrl == null || product.imageUrl!.isEmpty
                        ? Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                        )
                        : null, // Image is set via DecorationImage
              ),
            ),

            // Product Name
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                12,
              ), // pb-3 pt-5 px-4
              child: Text(
                product.name,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700, // font-bold
                  height: 1.2, // leading-tight
                  letterSpacing: -0.015 * 22, // tracking-[-0.015em]
                ),
              ),
            ),

            // Product Description
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                12,
              ), // pb-3 pt-1 px-4
              child: Text(
                product.description ?? 'No description available.',
                style: const TextStyle(
                  color: darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400, // font-normal
                  height: 1.5, // leading-normal
                ),
              ),
            ),

            // Add-ons Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                12,
              ), // pb-3 pt-5 px-4
              child: Text(
                "Add-ons",
                style: const TextStyle(
                  color: darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.015 * 22,
                ),
              ),
            ),
            if (product.addons != null && product.addons!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // px-4
                child: Column(
                  children:
                      product.addons!
                          .map(
                            (addon) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                              ), // py-3
                              child: Row(
                                children: [
                                  Container(
                                    width: 20, // h-5 w-5
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          selectedAddons.containsKey(addon.name)
                                              ? primaryRed
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ), // rounded
                                      border: Border.all(
                                        color:
                                            selectedAddons.containsKey(
                                                  addon.name,
                                                )
                                                ? primaryRed
                                                : borderColor, // border-[#e5dcdc]
                                        width: 2, // border-2
                                      ),
                                    ),
                                    child: Checkbox(
                                      value: selectedAddons.containsKey(
                                        addon.name,
                                      ),
                                      onChanged: (bool? checked) {
                                        setState(() {
                                          if (checked ?? false) {
                                            selectedAddons[addon
                                                .name] = cart_addon.Addon(
                                              name: addon.name,
                                              price: addon.price,
                                              quantity: 1,
                                            );
                                          } else {
                                            selectedAddons.remove(addon.name);
                                          }
                                        });
                                      },
                                      activeColor:
                                          Colors
                                              .transparent, // Handled by container decoration
                                      checkColor:
                                          Colors
                                              .white, // checked:bg-[image:--checkbox-tick-svg] implies white tick
                                      materialTapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap, // To make the tap area smaller
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ), // gap-x-3 (approximately)
                                  Expanded(
                                    child: Text(
                                      addon.name,
                                      style: const TextStyle(
                                        color: darkText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "No additional options available for this item.",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              ),

            const SizedBox(height: 20), // Spacing before the bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color:
            Colors
                .white, // h-5 bg-white at the bottom implies a white background
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          20,
        ), // px-4 py-3 for the row, plus some bottom padding
        child: SafeArea(
          // Ensures content is not obscured by system UI (e.g., home indicator)
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // justify-between
            children: [
              // Quantity Control Button
              Expanded(
                child: Container(
                  height: 48, // h-12
                  decoration: BoxDecoration(
                    color: lightGreyBackground, // bg-[#f4f0f0]
                    borderRadius: BorderRadius.circular(999), // rounded-full
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.remove, color: darkText, size: 24),
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700, // font-bold
                          height: 1.5, // leading-normal
                          letterSpacing: 0.015 * 16, // tracking-[0.015em]
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.add, color: darkText, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16), // gap-3 (approximate)
              // Add to Cart Button
              Expanded(
                child: SizedBox(
                  height: 48, // h-12
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed, // bg-[#e92932]
                      foregroundColor: Colors.white, // text-white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          999,
                        ), // rounded-full
                      ),
                      elevation: 0, // No shadow by default
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // px-5
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700, // font-bold
                        height: 1.5,
                        letterSpacing: 0.015 * 16,
                      ),
                    ),
                    onPressed: () {
                      final addonsList = selectedAddons.values.toList();
                      context.read<CartViewModel>().add(
                        AddToCart(
                          product: product,
                          quantity: quantity,
                          addons: addonsList,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green[600],
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      'Add to Cart',
                    ), // Truncate not needed with Expanded
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
