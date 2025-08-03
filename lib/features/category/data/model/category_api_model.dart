import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/features/category/domain/entity/category_entity.dart'; // import entity

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;

  final String? name;

  const CategoryApiModel({this.categoryId, this.name});

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // Add this method:
  CategoryEntity toEntity() {
    return CategoryEntity(categoryId: categoryId, name: name);
  }

  @override
  List<Object?> get props => [categoryId, name];
}
