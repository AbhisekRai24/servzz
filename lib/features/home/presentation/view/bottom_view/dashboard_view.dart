// import 'package:flutter/material.dart';
// import 'package:servzz/common/app_drawer.dart';
// import 'package:servzz/features/home/presentation/view_model/banner_slider.dart';

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       // drawer: AppDrawer(),
//       // appBar: AppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(height: 80),
//                     CircleAvatar(
//                       radius: 25,
//                       backgroundImage: AssetImage("assets/image/markk.jpg"),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Hello! Welcome to Servzz",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),

//                 // Search bar
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.search),
//                       hintText: "Search",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 const BannerSlider(),
//                 SizedBox(height: 20),

//                 // Cafes section
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Menu",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "See All",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 // Browse Menu Grid
//                 GridView.count(
//                   crossAxisCount: 2,
//                   shrinkWrap: true,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   physics: NeverScrollableScrollPhysics(),
//                   childAspectRatio: 1.2,
//                   children: [
//                     _buildMenuTile(Icons.local_cafe, "Coffee"),
//                     _buildMenuTile(Icons.icecream, "Cold Beverages"),
//                     _buildMenuTile(Icons.cake, "Desserts"),
//                     _buildMenuTile(Icons.restaurant_menu, "Full Menu"),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 SizedBox(height: 20),
//                 Text(
//                   "Your Orders",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: 4, // Update this count as needed
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: AssetImage(
//                               "assets/image/food_banner.jpg",
//                             ), // Use your own image path
//                             radius: 25,
//                           ),
//                           title: Text("Order #${index + 1}"),
//                           onTap: () {
//                             // Add tap logic here later if needed
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CafeCard extends StatelessWidget {
//   const CafeCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Image.asset("assets/image/login_image.jpg", height: 100),
//           ),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Color(0xFFA62123),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//             ),
//             child: TextButton(
//               onPressed: () {},
//               child: Text("View", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget _buildMenuTile(IconData icon, String title) {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           blurRadius: 4,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: 40, color: Colors.black87),
//         SizedBox(height: 10),
//         Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/features/home/presentation/view_model/banner_slider.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
import 'package:servzz/features/product/presentation/view_model/product_event.dart';
import 'package:servzz/features/product/presentation/view_model/product_state.dart';
import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';


class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create:
          (context) =>
              serviceLocator<ProductBloc>()..add(FetchProductsEvent(limit: 10)),
      child: const _DashboardViewBody(),
    );
  }
}

class _DashboardViewBody extends StatelessWidget {
  const _DashboardViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    SizedBox(height: 80),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/image/markk.jpg"),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Hello! Welcome to Servzz",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Banner Slider
                const BannerSlider(),
                const SizedBox(height: 20),

                // Products Section
                const Text(
                  "Featured Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.error != null) {
                      return Center(child: Text("Error: ${state.error}"));
                    } else if (state.products.isEmpty) {
                      return const Center(child: Text("No products found"));
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return _buildProductTile(product);
                        },
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Existing Menu Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  children: const [
                    _buildMenuTile(Icons.local_cafe, "Coffee"),
                    _buildMenuTile(Icons.icecream, "Cold Beverages"),
                    _buildMenuTile(Icons.cake, "Desserts"),
                    _buildMenuTile(Icons.restaurant_menu, "Full Menu"),
                  ],
                ),

                const SizedBox(height: 5),
                const SizedBox(height: 20),
                const Text(
                  "Your Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/image/food_banner.jpg",
                            ),
                            radius: 25,
                          ),
                          title: Text("Order #${index + 1}"),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductTile(ProductEntity product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                product.imageUrl != null
                    ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                    : const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Rs ${product.price.toString()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _buildMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _buildMenuTile(this.icon, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
