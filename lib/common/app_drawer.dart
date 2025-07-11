import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/common/my_snack_bar.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFA62123)),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/image/markk.jpg"),
                ),
                SizedBox(width: 12),
                Text(
                  'Mark',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded),
            title: const Text('Menu'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/menu');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/setting');
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Navigator.pop(context);

              // Show snackbar message
              showMySnackBar(
                context: context,
                message: 'Logging out...',
                color: Colors.red,
              );

              // Call logout method from HomeViewModel
              context.read<HomeViewModel>().logout(context);
            },
          ),
        ],
      ),
    );
  }
}
