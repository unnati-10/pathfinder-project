import 'package:flutter/material.dart';
import 'donate_page.dart';
import 'receive_page.dart';
import 'form_page.dart';
import 'list_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  /// 🔥 CATEGORIES WITH ICONS (NO IMAGE ISSUE)
  final List<Map<String, dynamic>> categories = [
    {
      "title": "Food",
      "icon": Icons.fastfood_outlined,
    },
    {
      "title": "Clothes",
      "icon": Icons.checkroom_outlined,
    },
    {
      "title": "Books",
      "icon": Icons.menu_book_outlined,
    },
    {
      "title": "Devices",
      "icon": Icons.devices_outlined,
    },
  ];

  final List<Map<String, String>> recentActivities = [
    {
      "title": "Food donation added",
      "subtitle": "2 mins ago",
    },
    {
      "title": "New receive request",
      "subtitle": "10 mins ago",
    },
    {
      "title": "Books pickup completed",
      "subtitle": "1 hour ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔥 TOP SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7B1FD3),
                      Color(0xFF9B51E0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Hello, Unnati 👋",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.person, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// SEARCH BAR
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.black45),
                          SizedBox(width: 8),
                          Text("Search...", style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// BODY
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 QUICK ACTIONS
                    const Text(
                      "Quick Actions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _mainActionCard(
                            title: "Donate",
                            icon: Icons.volunteer_activism_outlined,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const DonatePage()));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _mainActionCard(
                            title: "Receive",
                            icon: Icons.inventory_2_outlined,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const ReceivePage()));
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 CATEGORIES
                    const Text(
                      "Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final item = categories[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListPage(category: item["title"]),
                              ),
                            );
                          },
                          child: _categoryCard(
                            title: item["title"],
                            icon: item["icon"],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 MANAGE
                    const Text(
                      "Manage",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _smallCard(
                            title: "Dashboard",
                            icon: Icons.dashboard_outlined,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const DashboardPage()));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _smallCard(
                            title: "Form",
                            icon: Icons.description_outlined,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const FormPage()));
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 RECENT
                    const Text(
                      "Recent Activity",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    ...recentActivities.map(
                      (item) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(item["title"]!),
                        subtitle: Text(item["subtitle"]!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 MAIN CARD
  Widget _mainActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF7B1FD3)),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }

  /// 🔥 CATEGORY CARD
  Widget _categoryCard({
    required String title,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: const Color(0xFF7B1FD3)),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }

  /// 🔥 SMALL CARD
  Widget _smallCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7B1FD3)),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}