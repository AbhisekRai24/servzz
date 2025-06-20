import 'package:flutter/material.dart';
import 'package:servzz/common/app_drawer.dart';
import 'package:servzz/features/home/presentation/view_model/banner_slider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      // drawer: AppDrawer(),
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                SizedBox(height: 20),

                // Search bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // // Banner
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(20),
                //   child: Image.asset(
                //     "assets/image/food_banner.jpg",
                //     fit: BoxFit.cover,
                //     height: 180,
                //     width: double.infinity,
                //   ),
                // ),
                // SizedBox(height: 20),

                // Rotating Banner
                // SizedBox(
                //   height: 180,
                //   child: PageView.builder(
                //     itemCount: 4, // Total images
                //     controller: PageController(viewportFraction: 0.95),
                //     itemBuilder: (context, index) {
                //       final imageList = [
                //         "assets/image/food_banner.jpg",
                //         "assets/image/offer_banner_1.jpg",
                //         "assets/image/offer_banner_2.jpg",
                //         "assets/image/offer_banner_3.jpg",
                //       ];

                //       return Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.asset(
                //             imageList[index],
                //             fit: BoxFit.cover,
                //             width: double.infinity,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                const BannerSlider(),
                SizedBox(height: 20),

                // Cafes section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                SizedBox(height: 12),
                // Browse Menu Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  children: [
                    _buildMenuTile(Icons.local_cafe, "Coffee"),
                    _buildMenuTile(Icons.icecream, "Cold Beverages"),
                    _buildMenuTile(Icons.cake, "Desserts"),
                    _buildMenuTile(Icons.restaurant_menu, "Full Menu"),
                  ],
                ),

                // Cafe cards (updated)
                // Wrap(
                //       spacing: 12,
                //       runSpacing: 12,
                //       children: List.generate(10, (index) =>
                //         SizedBox(
                //           width: (MediaQuery.of(context).size.width - 44) / 2,
                //           child: CafeCard(),
                //         ),
                //       ),
                //     ),
                SizedBox(height: 5),
                SizedBox(height: 20),
                Text(
                  "Your Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4, // Update this count as needed
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/image/food_sample.jpg",
                            ), // Use your own image path
                            radius: 25,
                          ),
                          title: Text("Order #${index + 1}"),
                          onTap: () {
                            // Add tap logic here later if needed
                          },
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
}

class CafeCard extends StatelessWidget {
  const CafeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset("assets/image/login_image.jpg", height: 100),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFA62123),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: TextButton(
              onPressed: () {},
              child: Text("View", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMenuTile(IconData icon, String title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
