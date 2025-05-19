import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: Colors.blue[50],
  drawer: Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          child: Row(
            children: [
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
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Spacer(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            

            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
  appBar: AppBar(
    backgroundColor: Colors.grey[200],
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    SizedBox(height:80),
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

                // Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/image/food_banner.jpg", 
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 20),

                // Cafes section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menu",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 12),

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

                SizedBox(height:5),
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
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "assets/image/login_image.jpg", // Replace with actual logo
              height: 100,
            ),
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
              onPressed: () {


                
              },
              child: Text(
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
