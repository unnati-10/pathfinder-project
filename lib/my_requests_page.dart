import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_request_page.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  // normal share
  void shareItem(
      String name, String description, String category, String phone) {
    String text = "OneFinder Request\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Details: $description";
    Share.share(text);
  }

  // ✅ DIRECT WHATSAPP OPEN
  Future<void> openWhatsApp(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
  ) async {
    String message = "OneFinder Request\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Details: $description";

    String url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp not installed")),
      );
    }
  }

  // copy
  Future<void> copyRequest(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
  ) async {
    String text = "OneFinder Request\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Details: $description";
    "👉 Please contact if available";

    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied successfully")),
    );
  }

  Future<void> deleteRequest(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Request"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
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
          .collection('requests')
          .doc(docId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deleted successfully")),
      );
    }
  }

  // bottom sheet
  void showShareOptions(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("Share"),
                onTap: () {
                  Navigator.pop(context);
                  shareItem(name, description, category, phone);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.green),
                title: const Text("WhatsApp"),
                onTap: () {
                  Navigator.pop(context);
                  openWhatsApp(context, name, description, category, phone);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy"),
                onTap: () {
                  Navigator.pop(context);
                  copyRequest(context, name, description, category, phone);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      backgroundColor: const Color(0xFFF6F1FB),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No requests yet"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data['name'] ?? '';
              final description = data['description'] ?? '';
              final category = data['category'] ?? '';
              final phone = data['phone'] ?? '';

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
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF7B1FD3),
                            ),
                          ),
                        ),

                        // share button
                        IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          onPressed: () {
                            showShareOptions(
                                context, name, description, category, phone);
                          },
                        ),

                        // edit
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF7B1FD3)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditRequestPage(
                                  docId: doc.id,
                                  data: data,
                                ),
                              ),
                            );
                          },
                        ),

                        // delete
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteRequest(context, doc.id);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Phone: $phone"),
                    Text("Category: $category"),
                    Text("Description: $description"),
                    Text("Location: ${data['location'] ?? ''}"),
                    Text("Quantity: ${data['quantity'] ?? ''}"),
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
