import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<Map<String, int>> getCounts() async {
    final donationSnapshot =
        await FirebaseFirestore.instance.collection('donations').get();

    final requestSnapshot =
        await FirebaseFirestore.instance.collection('requests').get();

    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return {
      "donated": donationSnapshot.docs.length,
      "received": requestSnapshot.docs.length,
      "users": userSnapshot.docs.length,
      "activity": donationSnapshot.docs.length + requestSnapshot.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: getCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No dashboard data"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _card("Total Donated", data["donated"]!, Icons.favorite),
                      const SizedBox(width: 10),
                      _card(
                          "Total Received", data["received"]!, Icons.inventory),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _card(
                          "Total Activity", data["activity"]!, Icons.bar_chart),
                      const SizedBox(width: 10),
                      _card("Total Users", data["users"]!, Icons.people),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Recent Donations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D1B4E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('donations')
                        .orderBy('time', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, donationSnapshot) {
                      if (donationSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!donationSnapshot.hasData ||
                          donationSnapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "No recent donations yet",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      final docs = donationSnapshot.data!.docs;

                      return Column(
                        children: docs.map((doc) {
                          final item = doc.data() as Map<String, dynamic>;

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? "No Name",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7B1FD3),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Phone: ${item['phone'] ?? ''}"),
                                Text("Category: ${item['category'] ?? ''}"),
                                Text(
                                    "Description: ${item['description'] ?? ''}"),
                                Text("Location: ${item['location'] ?? ''}"),
                                Text("Quantity: ${item['quantity'] ?? ''}"),
                                Text("Condition: ${item['condition'] ?? ''}"),
                                Text(
                                    "Expiry Date: ${item['expiryDate'] ?? ''}"),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Recent Requests",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D1B4E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .orderBy('time', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, requestSnapshot) {
                      if (requestSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!requestSnapshot.hasData ||
                          requestSnapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "No recent requests yet",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      final docs = requestSnapshot.data!.docs;

                      return Column(
                        children: docs.map((doc) {
                          final item = doc.data() as Map<String, dynamic>;

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? "No Name",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7B1FD3),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Phone: ${item['phone'] ?? ''}"),
                                Text("Category: ${item['category'] ?? ''}"),
                                Text(
                                    "Description: ${item['description'] ?? ''}"),
                                Text("Location: ${item['location'] ?? ''}"),
                                Text(
                                    "Quantity Needed: ${item['quantity'] ?? ''}"),
                                Text("Status: ${item['status'] ?? ''}"),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, int value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7B1FD3), size: 30),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7B1FD3),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D1B4E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
