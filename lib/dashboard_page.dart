import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';

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
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FD3),
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
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
                radius: 18,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF7B1FD3),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, int>>(
        future: getCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7B1FD3),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final donated = snapshot.data?['donated'] ?? 0;
          final received = snapshot.data?['received'] ?? 0;
          final users = snapshot.data?['users'] ?? 0;
          final total = donated + received;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        donated.toString(),
                        "Total Donated",
                        Icons.volunteer_activism,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _statCard(
                        received.toString(),
                        "Total Received",
                        Icons.inventory_2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        total.toString(),
                        "Total Activity",
                        Icons.bar_chart,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _statCard(
                        users.toString(),
                        "Total Users",
                        Icons.people,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Recent Donations",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F1A46),
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('donations')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, donationSnapshot) {
                    if (donationSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Color(0xFF7B1FD3),
                          ),
                        ),
                      );
                    }

                    if (donationSnapshot.hasError) {
                      return const Text("Error loading donations");
                    }

                    if (!donationSnapshot.hasData ||
                        donationSnapshot.data!.docs.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "No donations found",
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }

                    final docs = donationSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B1FD3),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Phone: ${data['phone'] ?? ''}"),
                              Text("Category: ${data['category'] ?? ''}"),
                              Text("Description: ${data['description'] ?? ''}"),
                              Text("Location: ${data['location'] ?? ''}"),
                              Text("Quantity: ${data['quantity'] ?? ''}"),
                              Text("Condition: ${data['condition'] ?? ''}"),
                              if ((data['expiryDate'] ?? '')
                                  .toString()
                                  .isNotEmpty)
                                Text("Expiry Date: ${data['expiryDate']}"),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String number, String label, IconData icon) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF7B1FD3),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            number,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7B1FD3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2F1A46),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
