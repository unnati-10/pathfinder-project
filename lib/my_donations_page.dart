import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_donation_page.dart';

class MyDonationsPage extends StatelessWidget {
  const MyDonationsPage({super.key});

  Future<void> deleteDonation(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Donation"),
          content: const Text("Are you sure you want to delete this donation?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(docId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Donation deleted successfully"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Donations"),
          backgroundColor: const Color(0xFF7B1FD3),
        ),
        body: const Center(
          child: Text("No user logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donations"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      backgroundColor: const Color(0xFFF6F1FB),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No donations yet"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF7B1FD3),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditDonationPage(
                                  docId: doc.id,
                                  data: data,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF7B1FD3),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteDonation(context, doc.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Phone: ${data['phone'] ?? ''}"),
                    Text("Category: ${data['category'] ?? ''}"),
                    Text("Description: ${data['description'] ?? ''}"),
                    Text("Location: ${data['location'] ?? ''}"),
                    Text("Quantity: ${data['quantity'] ?? ''}"),
                    Text("Condition: ${data['condition'] ?? ''}"),
                    Text("Expiry Date: ${data['expiryDate'] ?? ''}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
