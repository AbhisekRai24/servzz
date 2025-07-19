import 'package:flutter/material.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

class ProductDetailView extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailView({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
              Image.network(product.imageUrl!),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Rs ${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              product.description ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (product.addons != null && product.addons!.isNotEmpty) ...[
              const Text(
                "Addons",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (product.addons != null)
                ...product.addons!.map(
                  (addon) => ListTile(
                    title: Text(addon.name),
                    trailing: Text("Rs ${addon.price.toStringAsFixed(2)}"),
                  ),
                ),
            ] else
              const Text(
                "No addons available",
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
