import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/cart/domain/model/addon.dart' as cart_addon;
import 'package:servzz/features/cart/presentation/view/mycart_view.dart';

import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

class ProductDetailView extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailView({required this.product, super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  Map<String, cart_addon.Addon> selectedAddons = {};

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          BlocBuilder<CartViewModel, dynamic>(
            builder: (context, state) {
              final totalItems = state.totalItems ?? 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartView()),
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
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.6),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with subtle shadow & rounded corners
            if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.black26,
                  child: Image.network(
                    product.imageUrl!,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        height: 240,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 240,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 80),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 24),

            Text(
              product.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "Rs ${product.price.toInt()}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              product.description ?? '',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),

            const SizedBox(height: 24),

            if (product.addons != null && product.addons!.isNotEmpty) ...[
              Text(
                "Available Addons",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...product.addons!.map(
                (addon) => CheckboxListTile(
                  activeColor: Colors.redAccent,
                  contentPadding: EdgeInsets.zero,
                  title: Text(addon.name),
                  subtitle: Text("Rs ${addon.price.toInt()}"),
                  value: selectedAddons.containsKey(addon.name),
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked ?? false) {
                        selectedAddons[addon.name] = cart_addon.Addon(
                          name: addon.name,
                          price: addon.price,
                          quantity: 1,
                        );
                      } else {
                        selectedAddons.remove(addon.name);
                      }
                    });
                  },
                ),
              ),
            ] else
              Text(
                "No addons available",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 32),

            Row(
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                ClipOval(
                  child: Material(
                    color: Colors.redAccent, // button color
                    child: InkWell(
                      splashColor: Colors.red[200],
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.redAccent,
                    child: InkWell(
                      splashColor: Colors.red[200],
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.redAccent.withOpacity(0.4),
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
                    const SnackBar(
                      content: Text('Added to cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
