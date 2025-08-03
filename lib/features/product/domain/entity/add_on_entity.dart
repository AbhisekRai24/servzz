
import 'package:equatable/equatable.dart';

class AddonEntity extends Equatable {
  final String name;
  final double price;

  const AddonEntity({
    required this.name,
    required this.price,
  });

  @override
  List<Object> get props => [name, price];
}
