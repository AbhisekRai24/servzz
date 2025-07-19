import 'package:flutter/material.dart';

@immutable
sealed class ProductEvent {}

class FetchProductsEvent extends ProductEvent {
  final int limit;

  FetchProductsEvent({this.limit = 10});
}
