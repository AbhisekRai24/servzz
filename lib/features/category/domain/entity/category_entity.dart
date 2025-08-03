import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String? name;

  const CategoryEntity({
    this.categoryId,
    this.name,
  });

  @override
  List<Object?> get props => [
        categoryId,
        name,
      ];
}
