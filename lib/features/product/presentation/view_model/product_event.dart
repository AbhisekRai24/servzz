import 'package:flutter/material.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

@immutable
sealed class ProductEvent {}

class FetchProductsEvent extends ProductEvent {
  final int? limit;  // optional
  final int? page;   // optional
  final String? search; // optional search query

  FetchProductsEvent({this.limit, this.page, this.search});
}

class NavigateToProductDetailEvent extends ProductEvent {
  final ProductEntity product;

  NavigateToProductDetailEvent(this.product);
}
