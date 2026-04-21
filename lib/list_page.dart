import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ListPage extends StatelessWidget {
  final String category;

  const ListPage({super.key, required this.category});

  Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) return;

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void shareItem(
    String name,
    String description,
    String category,
    String phone,
    String location,
    String quantity,
  ) {
    String text = "OneFinder Donation\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Location: $location\n"
        "Quantity: $quantity\n"
        "Details: $description\n\n"
        "👉 Please contact if available";
    Share.share(text);
  }

  Future<void> openWhatsApp(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
    String location,
    String quantity,
  ) async {
    String message = "OneFinder Donation\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Location: $location\n"
        "Quantity: $quantity\n"
        "Details: $description\n\n"
        "👉 Please contact if available";

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

  Future<void> copyItemDetails(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
    String location,
    String quantity,
  ) async {
    String text = "OneFinder Donation\n\n"
        "Item: $name\n"
        "Category: $category\n"
        "Phone: $phone\n"
        "Location: $location\n"
        "Quantity: $quantity\n"
        "Details: $description\n\n"
        "👉 Please contact if available";

    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied successfully")),
    );
  }

  void showShareOptions(
    BuildContext context,
    String name,
    String description,
    String category,
    String phone,
    String location,
    String quantity,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (bottomContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("Share"),
                onTap: () {
                  Navigator.pop(bottomContext);
                  shareItem(
                    name,
                    description,
                    category,
                    phone,
                    location,
                    quantity,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.green),
                title: const Text("WhatsApp"),
                onTap: () {
                  Navigator.pop(bottomContext);
                  openWhatsApp(
                    context,
                    name,
                    description,
                    category,
                    phone,
                    location,
                    quantity,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy"),
                onTap: () {
                  Navigator.pop(bottomContext);
                  copyItemDetails(
                    context,
                    name,
                    description,
                    category,
                    phone,
                    location,
                    quantity,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendRequest({
    required String donorName,
    required String donorPhone,
    required String itemName,
    required String quantity,
    required String location,
    required String description,
    required String category,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('requests').add({
      'requestedBy': user?.uid ?? '',
      'requestedEmail': user?.email ?? '',
      'donorName': donorName,
      'donorPhone': donorPhone,
      'itemName': itemName,
      'quantity': quantity,
      'location': location,
      'description': description,
      'category': category,
      'status': 'pending',
      'time': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAsCompleted(String docId) async {
    await FirebaseFirestore.instance.collection('donations').doc(docId).update({
      'status': 'completed',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F35C8),
        centerTitle: true,
        title: Text(
          "$category Items",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6F35C8),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No items found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String docId = doc.id;

              final String name = (data['name'] ?? 'No Name').toString();
              final String location =
                  (data['location'] ?? 'No Location').toString();
              final String user = (data['name'] ?? 'Unknown').toString();
              final String description = (data['description'] ?? '').toString();
              final String quantity = (data['quantity'] ?? '').toString();
              final String phone = (data['phone'] ?? '').toString();
              final String status = (data['status'] ?? 'pending').toString();

              final bool isCompleted = status.toLowerCase() == 'completed';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 34,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Color(0xFF6F35C8),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      showShareOptions(
                                        context,
                                        name,
                                        description,
                                        category,
                                        phone,
                                        location,
                                        quantity,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      isCompleted ? "COMPLETED" : "PENDING",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      user,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Qty: $quantity",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      phone.isNotEmpty ? phone : "No phone",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCompleted
                                  ? Colors.grey
                                  : const Color(0xFF6F35C8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(double.infinity, 38),
                              elevation: 0,
                            ),
                            onPressed: isCompleted
                                ? null
                                : () async {
                                    try {
                                      await sendRequest(
                                        donorName: name,
                                        donorPhone: phone,
                                        itemName: name,
                                        quantity: quantity,
                                        location: location,
                                        description: description,
                                        category: category,
                                      );

                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text("Request sent for $name"),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Failed to send request: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: Text(
                              isCompleted ? "Completed" : "Request",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(double.infinity, 38),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (phone.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Phone number not available"),
                                  ),
                                );
                              } else {
                                await makePhoneCall(phone);
                              }
                            },
                            child: const Text("Call"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(double.infinity, 38),
                              elevation: 0,
                            ),
                            onPressed: isCompleted
                                ? null
                                : () async {
                                    try {
                                      await markAsCompleted(docId);

                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Marked as completed"),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Failed to update status: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: const Text("Complete"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6F35C8),
                              side: const BorderSide(
                                color: Color(0xFF6F35C8),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(double.infinity, 38),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(name),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Category: $category"),
                                        Text("Description: $description"),
                                        Text("Location: $location"),
                                        Text("Quantity: $quantity"),
                                        Text("Status: $status"),
                                        Text(
                                          "Phone: ${phone.isNotEmpty ? phone : 'No phone'}",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          if (phone.trim().isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Phone number not available",
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(dialogContext);
                                            await makePhoneCall(phone);
                                          }
                                        },
                                        child: const Text("Call"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("View"),
                          ),
                        ),
                      ],
                    ),
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
