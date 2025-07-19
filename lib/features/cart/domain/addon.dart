// lib/features/cart/domain/models/addon.dart
class Addon {
  final String addonId;
  final String name;
  final double price;
  final int quantity;

  Addon({
    required this.addonId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Addon copyWith({int? quantity}) {
    return Addon(
      addonId: addonId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
