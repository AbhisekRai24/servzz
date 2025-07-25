import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/common/app_drawer.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final viewModel = context.read<HomeViewModel>();
    final userId = await viewModel.getUserIdFromToken(); // call exposed method

    if (userId != null) {
      viewModel.initializeSocket(userId); // initialize socket connection
      viewModel.emitInitialState(userId); // emit HomeState.initial
    } else {
      viewModel.emitErrorState(); // emit error state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.views.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return state.views[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.views.isEmpty) {
            return const SizedBox.shrink();
          }
          return BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.blue[900],
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
            onTap: (index) {
              context.read<HomeViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
