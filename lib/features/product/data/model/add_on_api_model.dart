import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/features/product/domain/entity/add_on_entity.dart';

// dart run build_runner build -d
part 'add_on_api_model.g.dart'; // Add this

@JsonSerializable()
class AddonApiModel extends Equatable {
  final String name;
  final double price;

  const AddonApiModel({required this.name, required this.price});

  factory AddonApiModel.fromJson(Map<String, dynamic> json) =>
      _$AddonApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddonApiModelToJson(this);

  AddonEntity toEntity() {
    return AddonEntity(name: name, price: price);
  }

  @override
  List<Object> get props => [name, price];
}
