import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsSheet({super.key, required this.order});

  // Define a refined color palette for a sleek look
  static const Color primaryRed = Color(0xFFE92932); // Main accent color
  static const Color darkText = Color(0xFF212121); // Darker text for headings
  static const Color mediumText = Color(
    0xFF616161,
  ); // Medium grey for body text
  static const Color lightGreyBackground = Color(
    0xFFF8F8F8,
  ); // Very light background for cards
  static const Color dividerColor = Color(0xFFEDEDED); // Subtle divider color
  static const Color handleColor = Color(
    0xFFDCDCDC,
  ); // Color for the drag handle

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24), // More pronounced rounded corners
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(
                  0,
                  -4,
                ), // Shadow pointing upwards for a lifted look
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                ), // Slightly more vertical padding
                child: Center(
                  child: Container(
                    width: 50, // Wider handle
                    height: 5, // Slightly thicker handle
                    decoration: BoxDecoration(
                      color: handleColor,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ),
              // Order Details Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24.0,
                  0,
                  24.0,
                  16.0,
                ), // Generous padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 24, // Larger title
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.date != null
                          ? DateFormat(
                            'MMMM dd, yyyy • hh:mm a',
                          ).format(order.date!)
                          : 'Date not available',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: mediumText,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Product List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ), // Consistent horizontal padding
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final product = order.products[index];
                    return _buildProductItem(context, product);
                  },
                ),
              ),
              // Spacer before total amount section
              const SizedBox(height: 20),
              // Total Amount Section
              Divider(
                color: dividerColor,
                thickness: 1.5,
                height: 0,
              ), // Thin, subtle divider
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24.0,
                  20.0,
                  24.0,
                  32.0,
                ), // More padding for bottom section
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Slightly larger total amount text
                      ),
                    ),
                    Text(
                      'Rs. ${order.total.toStringAsFixed(2)}', // Using "Rs." for Nepali Rupees
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primaryRed, // Highlight total with accent color
                        fontWeight: FontWeight.bold,
                        fontSize: 22, // Even larger for prominence
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductItem(BuildContext context, OrderedProductEntity product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Consistent spacing
      decoration: BoxDecoration(
        color: lightGreyBackground, // Light grey background for each item
        borderRadius: BorderRadius.circular(12), // Soft rounded corners
        border: Border.all(color: dividerColor, width: 1), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.03,
            ), // Very subtle shadow for depth
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18), // Increased padding inside the item
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    // Safely handle potentially null product name
                    product.name ?? 'Unknown Product',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Ensure product name stays on one line
                  ),
                ),
                Text(
                  'Rs. ${product.price.toStringAsFixed(0)}', // Using "Rs." for Nepali Rupees
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: ${product.quantity}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mediumText, fontSize: 15),
            ),
            if (product.addons.isNotEmpty) ...[
              const SizedBox(height: 12), // More space before add-ons
              Text(
                'Add-ons:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 6,
              ), // Space between "Add-ons" title and list
              ...product.addons.map(
                (addon) => Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    bottom: 4,
                  ), // Indent add-ons, slight bottom padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // Allow add-on name to take space
                        child: Text(
                          '• ${addon.addonId ?? 'Unknown Add-on'}', // Safely handle potentially null add-on ID
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: mediumText, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '( ${addon.quantity}x) Rs. ${(addon.price * addon.quantity).toStringAsFixed(0)}', // Using "Rs." for Nepali Rupees
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: mediumText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
