// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:servzz/app/service_locator/service_locator.dart';
// import 'package:servzz/features/product/domain/entity/product_entity.dart';
// import 'package:servzz/features/product/presentation/view/product_detail.dart';
// import 'package:servzz/features/product/presentation/view_model/product_event.dart';
// import 'package:servzz/features/product/presentation/view_model/product_state.dart';
// import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';

// class AllProductsView extends StatelessWidget {
//   const AllProductsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<ProductBloc>(
//       create:
//           (context) =>
//               serviceLocator<ProductBloc>()
//                 ..add(FetchProductsEvent()), // no limit
//       child: const _AllProductsViewBody(),
//     );
//   }
// }

// class _AllProductsViewBody extends StatefulWidget {
//   const _AllProductsViewBody({super.key});

//   @override
//   State<_AllProductsViewBody> createState() => _AllProductsViewBodyState();
// }

// class _AllProductsViewBodyState extends State<_AllProductsViewBody> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();

//   int _page = 1;
//   final int _limit = 10;
//   String? _search;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         // Near bottom, fetch next page
//         _page++;
//         _fetchProducts();
//       }
//     });

//     _searchController.addListener(() {
//       final newSearch = _searchController.text.trim();
//       if (newSearch != _search) {
//         _search = newSearch;
//         _page = 1;
//         _fetchProducts();
//       }
//     });
//   }

//   void _fetchProducts() {
//     context.read<ProductBloc>().add(
//       FetchProductsEvent(limit: _limit, page: _page, search: _search),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("All Products")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search products...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: BlocBuilder<ProductBloc, ProductState>(
//                 builder: (context, state) {
//                   if (state.isLoading && state.products.isEmpty) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state.error != null && state.products.isEmpty) {
//                     return Center(child: Text("Error: ${state.error}"));
//                   } else if (state.products.isEmpty) {
//                     return const Center(child: Text("No products found"));
//                   }

//                   return GridView.builder(
//                     controller: _scrollController,
//                     itemCount: state.products.length + 1,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 12,
//                           crossAxisSpacing: 12,
//                           childAspectRatio: 0.75,
//                         ),
//                     itemBuilder: (context, index) {
//                       if (index == state.products.length) {
//                         return state.isLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : const SizedBox.shrink();
//                       }
//                       final product = state.products[index];
//                       return _ProductCard(product: product);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ProductCard extends StatelessWidget {
//   final ProductEntity product;

//   const _ProductCard({required this.product, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductDetailView(product: product),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.15),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child:
//                     product.imageUrl != null
//                         ? Image.network(
//                           product.imageUrl!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           errorBuilder:
//                               (context, error, stackTrace) =>
//                                   const Icon(Icons.broken_image),
//                           loadingBuilder:
//                               (context, child, loadingProgress) =>
//                                   loadingProgress == null
//                                       ? child
//                                       : const Center(
//                                         child: CircularProgressIndicator(),
//                                       ),
//                         )
//                         : const Icon(
//                           Icons.image_not_supported,
//                           size: 60,
//                           color: Colors.grey,
//                         ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   Text(
//                     product.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     'Rs ${product.price}',
//                     style: TextStyle(
//                       color: Colors.red[400],
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/common/cards/product_card.dart';

import 'package:servzz/features/product/presentation/view_model/product_event.dart';
import 'package:servzz/features/product/presentation/view_model/product_state.dart';
import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';

class AllProductsView extends StatelessWidget {
  const AllProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create:
          (context) => serviceLocator<ProductBloc>()..add(FetchProductsEvent()),
      child: const _AllProductsViewBody(),
    );
  }
}

class _AllProductsViewBody extends StatefulWidget {
  const _AllProductsViewBody({super.key});

  @override
  State<_AllProductsViewBody> createState() => _AllProductsViewBodyState();
}

class _AllProductsViewBodyState extends State<_AllProductsViewBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _page = 1;
  final int _limit = 10;
  String? _search;

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _page++;
        _fetchProducts();
      }
    });

    _searchController.addListener(() {
      final newSearch = _searchController.text.trim();
      if (newSearch != _search) {
        _search = newSearch;
        _page = 1;
        _fetchProducts();
      }
    });
  }

  void _fetchProducts() {
    context.read<ProductBloc>().add(
      FetchProductsEvent(limit: _limit, page: _page, search: _search),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.isLoading && state.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error != null && state.products.isEmpty) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else if (state.products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    itemCount: state.products.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      if (index == state.products.length) {
                        return state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      final product = state.products[index];
                      return ProductCard(product: product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
