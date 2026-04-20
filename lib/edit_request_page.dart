import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRequestPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditRequestPage({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController quantityController;

  String? selectedCategory;

  final List<String> categories = [
    "Food",
    "Clothes",
    "Books",
    "Devices",
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.data['name'] ?? '');
    phoneController = TextEditingController(text: widget.data['phone'] ?? '');
    descriptionController =
        TextEditingController(text: widget.data['description'] ?? '');
    locationController =
        TextEditingController(text: widget.data['location'] ?? '');
    quantityController =
        TextEditingController(text: widget.data['quantity'] ?? '');

    selectedCategory = widget.data['category'];
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> updateRequest() async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.docId)
        .update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'category': selectedCategory,
      'description': descriptionController.text.trim(),
      'location': locationController.text.trim(),
      'quantity': quantityController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request updated")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Request"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      backgroundColor: const Color(0xFFF6F1FB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: "Phone"),
            ),
            DropdownButtonFormField<String>(
              initialValue: categories.contains(selectedCategory)
                  ? selectedCategory
                  : null,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                });
              },
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(hintText: "Location"),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(hintText: "Quantity"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateRequest,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
