import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/common/app_drawer.dart';
import 'package:servzz/core/common/my_snackbar.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),

      appBar: AppBar(
        // title: const Text('Home'),
        // centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       // Logout code
        //       showMySnackBar(
        //         context: context,
        //         message: 'Logging out...',
        //         color: Colors.red,
        //       );

        //       context.read<HomeViewModel>().logout(context);
        //     },
        //   ),
        // ],
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return state.views.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Course'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Batch'),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 218, 145, 145),
            onTap: (index) {
              context.read<HomeViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
