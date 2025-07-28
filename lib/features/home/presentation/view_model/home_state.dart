import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/cart/presentation/view/mycart_view.dart';
import 'package:servzz/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:servzz/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:servzz/features/order/presentation/view/order_history_view.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  // Initial state
  static HomeState initial(String userId) {
    return HomeState(
      selectedIndex: 0,
      views: [
        DashboardView(),
        CartView(),

        OrderHistoryPage(userId: userId),

        AccountView(),
      ],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}
