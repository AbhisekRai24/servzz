import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entity/order_entity.dart';

class FourOrderView extends StatelessWidget {
  final List<OrderEntity> orders;
  final void Function(OrderEntity order)? onTapOrder;

  const FourOrderView({Key? key, required this.orders, this.onTapOrder})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<OrderEntity> latestOrders = orders.take(4).toList();

    return Column(
      children:
          latestOrders.map((order) => _buildOrderCard(context, order)).toList(),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: color.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onTapOrder?.call(order),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Status and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOrderStatus(order.status),
                  Text(
                    order.date != null
                        ? DateFormat(
                          'MMM dd, yyyy • hh:mm a',
                        ).format(order.date!)
                        : 'Unknown date',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: color.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Order Type
              Row(
                children: [
                  Icon(
                    order.orderType == 'dine-in'
                        ? Icons.restaurant_menu
                        : Icons.takeout_dining_rounded,
                    size: 20,
                    color: color.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.orderType.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Item Count
              Text(
                '${order.products.length} item${order.products.length != 1 ? 's' : ''}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color.onBackground,
                ),
              ),
              const SizedBox(height: 14),

              /// Total Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: Rs ${order.total.toInt()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatus(String? status) {
    late Color color;
    late String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
