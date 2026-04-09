import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final String category;

  const ListPage({
    super.key,
    required this.category,
  });

  List<Map<String, String>> getItems() {
    final allItems = [
      {
        "category": "Food",
        "name": "Rice Pack",
        "location": "2 km away",
        "user": "Rahul",
        "time": "1 hour ago",
        "image": "assets/images/food.png",
      },
      {
        "category": "Food",
        "name": "Vegetable Box",
        "location": "1.5 km away",
        "user": "Anjali",
        "time": "30 mins ago",
        "image": "assets/images/food.png",
      },
      {
        "category": "Clothes",
        "name": "Winter Jacket",
        "location": "3 km away",
        "user": "Sneha",
        "time": "2 hours ago",
        "image": "assets/images/clothes.png",
      },
      {
        "category": "Clothes",
        "name": "Kids Dress",
        "location": "4 km away",
        "user": "Aman",
        "time": "45 mins ago",
        "image": "assets/images/clothes.png",
      },
      {
        "category": "Books",
        "name": "School Books",
        "location": "1 km away",
        "user": "Priya",
        "time": "20 mins ago",
        "image": "assets/images/books.png",
      },
      {
        "category": "Books",
        "name": "Story Books",
        "location": "2.5 km away",
        "user": "Kiran",
        "time": "3 hours ago",
        "image": "assets/images/books.png",
      },
      {
        "category": "Electronics",
        "name": "Table Lamp",
        "location": "5 km away",
        "user": "Vikas",
        "time": "1 day ago",
        "image": "assets/images/electronics.png",
      },
      {
        "category": "Electronics",
        "name": "Old Mobile",
        "location": "2 km away",
        "user": "Deepa",
        "time": "4 hours ago",
        "image": "assets/images/electronics.png",
      },
    ];

    return allItems.where((item) => item["category"] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = getItems();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "$category Items",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "No items available",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE7F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item["image"]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"]!,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "📍 ${item["location"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "👤 ${item["user"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "⏰ ${item["time"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Requested ${item["name"]}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Request"),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.deepPurple,
                                        side: const BorderSide(
                                          color: Colors.deepPurple,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Viewing ${item["name"]}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("View"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}