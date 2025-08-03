// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:servzz/app/service_locator/service_locator.dart';
// import 'package:servzz/features/banner_slider/presentation/view_model/banner_slider.dart';
// import 'package:servzz/features/product/domain/entity/product_entity.dart';
// import 'package:servzz/features/product/presentation/view/all_products_view.dart';
// import 'package:servzz/features/product/presentation/view_model/product_event.dart';
// import 'package:servzz/features/product/presentation/view_model/product_state.dart';
// import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<ProductBloc>(
//       create:
//           (context) =>
//               serviceLocator<ProductBloc>()..add(FetchProductsEvent(limit: 10)),
//       child: const _DashboardViewBody(),
//     );
//   }
// }

// class _DashboardViewBody extends StatelessWidget {
//   const _DashboardViewBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: const [
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
//                 const SizedBox(height: 20),
//                 // Search bar
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.search),
//                       hintText: "Search",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Banner Slider
//                 const BannerSlider(),
//                 const SizedBox(height: 20),

//                 // Products Section
//                 const Text(
//                   "Featured Products",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),

//                 BlocBuilder<ProductBloc, ProductState>(
//                   builder: (context, state) {
//                     if (state.isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state.error != null) {
//                       return Center(child: Text("Error: ${state.error}"));
//                     } else if (state.products.isEmpty) {
//                       return const Center(child: Text("No products found"));
//                     } else {
//                       return GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: state.products.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 12,
//                               mainAxisSpacing: 12,
//                               childAspectRatio: 1.2,
//                             ),
//                         itemBuilder: (context, index) {
//                           final product = state.products[index];
//                           return _buildProductTile(product);
//                         },
//                       );
//                     }
//                   },
//                 ),

//                 const SizedBox(height: 20),

//                 // Existing Menu Section
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Menu",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const AllProductsView(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "See All",
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),
//                 GridView.count(
//                   crossAxisCount: 2,
//                   shrinkWrap: true,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   physics: const NeverScrollableScrollPhysics(),
//                   childAspectRatio: 1.2,
//                   children: const [
//                     _buildMenuTile(Icons.local_cafe, "Coffee"),
//                     _buildMenuTile(Icons.icecream, "Cold Beverages"),
//                     _buildMenuTile(Icons.cake, "Desserts"),
//                     _buildMenuTile(Icons.restaurant_menu, "Full Menu"),
//                   ],
//                 ),

//                 const SizedBox(height: 5),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Your Orders",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           leading: const CircleAvatar(
//                             backgroundImage: AssetImage(
//                               "assets/image/food_banner.jpg",
//                             ),
//                             radius: 25,
//                           ),
//                           title: Text("Order #${index + 1}"),
//                           onTap: () {},
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

//   Widget _buildProductTile(ProductEntity product) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child:
//                 product.imageUrl != null
//                     ? Image.network(
//                       product.imageUrl!,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     )
//                     : const Icon(
//                       Icons.image_not_supported,
//                       size: 50,
//                       color: Colors.grey,
//                     ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             product.name,
//             style: const TextStyle(fontWeight: FontWeight.w600),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             'Rs ${product.price.toString()}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[600],
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }

// class _buildMenuTile extends StatelessWidget {
//   final IconData icon;
//   final String title;

//   const _buildMenuTile(this.icon, this.title, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 40, color: Colors.black87),
//           const SizedBox(height: 10),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/banner_slider/presentation/view_model/banner_slider.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';
import 'package:servzz/features/order/presentation/view/four_order_view.dart';
import 'package:servzz/features/order/presentation/view/order_history_view.dart';
import 'package:servzz/features/order/presentation/view_model/order_event.dart';
import 'package:servzz/features/order/presentation/view_model/order_state.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
import 'package:servzz/features/product/presentation/view/all_products_view.dart';
import 'package:servzz/features/product/presentation/view_model/product_event.dart';
import 'package:servzz/features/product/presentation/view_model/product_state.dart';
import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create:
              (context) =>
                  serviceLocator<ProductBloc>()
                    ..add(FetchProductsEvent(limit: 10)),
        ),
        BlocProvider<OrderViewModel>(
          create: (context) => serviceLocator<OrderViewModel>(),
        ),
      ],
      child: const _DashboardViewBody(),
    );
  }
}

class _DashboardViewBody extends StatefulWidget {
  const _DashboardViewBody({Key? key}) : super(key: key);

  @override
  State<_DashboardViewBody> createState() => _DashboardViewBodyState();
}

class _DashboardViewBodyState extends State<_DashboardViewBody> {
  String? userId;
  bool hasDispatchedOrdersEvent = false;

  late final TokenSharedPrefs tokenPrefs;

  @override
  void initState() {
    super.initState();

    // Initialize TokenSharedPrefs with shared preferences from service locator or directly
    tokenPrefs = serviceLocator<TokenSharedPrefs>();

    _initUserIdAndLoadOrders();
  }

  Future<void> _initUserIdAndLoadOrders() async {
    final tokenEither = await tokenPrefs.getToken();

    tokenEither.fold(
      (failure) {
        // Handle error fetching token
        print('[ERROR] Failed to get token: ${failure.message}');
      },
      (token) {
        print('[DEBUG] Retrieved token: $token');

        if (token == null || token.isEmpty) {
          print('[DEBUG] Token is null or empty');
          return;
        }

        final extractedUserId = Jwt.parseJwt(token)['_id'] as String?;
        print('[DEBUG] Extracted userId from token: $extractedUserId');

        if (extractedUserId == null) {
          print('[DEBUG] userId extracted from token is null');
          return;
        }

        setState(() {
          userId = extractedUserId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId != null && !hasDispatchedOrdersEvent) {
      context.read<OrderViewModel>().add(LoadUserOrdersEvent(userId: userId!));
      print('[DEBUG] Dispatched LoadUserOrdersEvent for userId: $userId');
      hasDispatchedOrdersEvent = true;
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

              // Menu Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Menu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AllProductsView(),
                        ),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
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

              // Your Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getString('user_id');

                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderHistoryPage(userId: userId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User ID not found')),
                        );
                      }
                    },
                    child: const Text(
                      "See more",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (userId == null)
                const Center(child: CircularProgressIndicator())
              else
                BlocBuilder<OrderViewModel, OrderState>(
                  builder: (context, orderState) {
                    if (orderState is OrderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (orderState is OrderFailure) {
                      return Center(
                        child: Text(
                          'Failed to load orders: ${orderState.message}',
                        ),
                      );
                    } else if (orderState is OrderLoaded) {
                      if (orderState.orders.isEmpty) {
                        return const Center(child: Text('No orders found'));
                      }
                      return FourOrderView(
                        orders: orderState.orders,
                        onTapOrder: (order) {
                          // TODO: handle tap on order
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
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
