import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/common/app_drawer.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.views.isEmpty) {
            // Show loading or fallback UI until views are ready
            return const Center(child: CircularProgressIndicator());
          }
          return state.views[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.views.isEmpty) {
            // Prevents errors before views are initialized
            return const SizedBox.shrink();
          }
          return BottomNavigationBar(
            backgroundColor: Colors.black, // Dark color for the nav bar
            selectedItemColor: Colors.redAccent, // Active item color
            unselectedItemColor: Colors.blue[900], // Inactive item color
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'My Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Orders',
              ),
            ],
            currentIndex: state.selectedIndex,
            // selectedItemColor: const Color.fromARGB(255, 218, 145, 145),
            onTap: (index) {
              context.read<HomeViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
