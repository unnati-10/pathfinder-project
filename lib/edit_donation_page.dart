import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDonationPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditDonationPage({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditDonationPage> createState() => _EditDonationPageState();
}

class _EditDonationPageState extends State<EditDonationPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController quantityController;
  late TextEditingController expiryDateController;

  String? selectedCategory;
  String? selectedCondition;

  final List<String> categories = [
    "Food",
    "Clothes",
    "Books",
    "Devices",
  ];

  final List<String> conditions = [
    "New",
    "Good",
    "Used",
  ];

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.data['name']?.toString() ?? '');
    phoneController =
        TextEditingController(text: widget.data['phone']?.toString() ?? '');
    descriptionController = TextEditingController(
        text: widget.data['description']?.toString() ?? '');
    locationController =
        TextEditingController(text: widget.data['location']?.toString() ?? '');
    quantityController =
        TextEditingController(text: widget.data['quantity']?.toString() ?? '');
    expiryDateController = TextEditingController(
        text: widget.data['expiryDate']?.toString() ?? '');

    selectedCategory = widget.data['category']?.toString();
    selectedCondition = widget.data['condition']?.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    quantityController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  Future<void> updateDonation() async {
    await FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.docId)
        .update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'category': selectedCategory ?? '',
      'description': descriptionController.text.trim(),
      'location': locationController.text.trim(),
      'quantity': quantityController.text.trim(),
      'condition': selectedCondition ?? '',
      'expiryDate': expiryDateController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      appBar: AppBar(
        title: const Text("Edit Donation"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField(nameController, "Name"),
            const SizedBox(height: 12),
            _buildField(phoneController, "Phone"),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: categories.contains(selectedCategory)
                  ? selectedCategory
                  : null,
              decoration: _inputDecoration("Category"),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildField(descriptionController, "Description"),
            const SizedBox(height: 12),
            _buildField(locationController, "Location"),
            const SizedBox(height: 12),
            _buildField(quantityController, "Quantity"),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: conditions.contains(selectedCondition)
                  ? selectedCondition
                  : null,
              decoration: _inputDecoration("Condition"),
              items: conditions.map((condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCondition = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildField(expiryDateController, "Expiry Date"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FD3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Update Donation",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
