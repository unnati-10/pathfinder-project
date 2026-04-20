import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donate_page.dart';
import 'receive_page.dart';
import 'form_page.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'ai_chat_page.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {"title": "Food", "icon": Icons.fastfood_outlined},
    {"title": "Clothes", "icon": Icons.checkroom_outlined},
    {"title": "Books", "icon": Icons.menu_book_outlined},
    {"title": "Devices", "icon": Icons.devices_outlined},
  ];

  String searchText = '';

  List<Map<String, dynamic>> get filteredCategories {
    if (searchText.trim().isEmpty) return categories;

    return categories.where((item) {
      final title = item["title"].toString().toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredQuickActions {
    final actions = [
      {
        "title": "Donate",
        "icon": Icons.volunteer_activism_outlined,
        "page": const DonatePage(),
      },
      {
        "title": "Receive",
        "icon": Icons.inventory_2_outlined,
        "page": const ReceivePage(),
      },
    ];

    if (searchText.trim().isEmpty) return actions;

    return actions.where((item) {
      final title = item["title"].toString().toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredManageItems {
    final items = [
      {
        "title": "Dashboard",
        "icon": Icons.dashboard_outlined,
        "page": const DashboardPage(),
      },
      {
        "title": "Form",
        "icon": Icons.description_outlined,
        "page": const FormPage(),
      },
      {
        "title": "AI Help",
        "icon": Icons.smart_toy_outlined,
        "page": const AiChatPage(),
      },
    ];

    if (searchText.trim().isEmpty) return items;

    return items.where((item) {
      final title = item["title"].toString().toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  bool get hasSearchResults {
    return filteredQuickActions.isNotEmpty ||
        filteredCategories.isNotEmpty ||
        filteredManageItems.isNotEmpty;
  }

  Future<String> getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return "User";
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return data['username']?.toString() ??
            data['name']?.toString() ??
            "User";
      }

      return user.displayName ?? "User";
    } catch (e) {
      return "User";
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    const Text(
                      "OneFinder",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Donate • Receive • Connect",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FutureBuilder<String>(
                            future: getUserName(),
                            builder: (context, snapshot) {
                              final userName = snapshot.data ?? "User";

                              return Text(
                                "Hello, $userName 👋",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF7B1FD3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search here...",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: searchText.trim().isNotEmpty && !hasSearchResults
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "No results found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (filteredQuickActions.isNotEmpty) ...[
                            const Text(
                              "Quick Actions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: filteredQuickActions.map((item) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: item == filteredQuickActions.last
                                          ? 0
                                          : 10,
                                    ),
                                    child: _mainActionCard(
                                      title: item["title"] as String,
                                      icon: item["icon"] as IconData,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                item["page"] as Widget,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                          if (filteredCategories.isNotEmpty) ...[
                            const Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredCategories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                final item = filteredCategories[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ListPage(
                                          category: item["title"] as String,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _categoryCard(
                                    title: item["title"] as String,
                                    icon: item["icon"] as IconData,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                          if (filteredManageItems.isNotEmpty) ...[
                            const Text(
                              "Manage",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: filteredManageItems.map((item) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: item == filteredManageItems.last
                                          ? 0
                                          : 10,
                                    ),
                                    child: _smallCard(
                                      title: item["title"] as String,
                                      icon: item["icon"] as IconData,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                item["page"] as Widget,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

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
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _smallCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
