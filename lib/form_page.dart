import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String selectedType = "Donate";
  String selectedCategory = "Food";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  void submitForm() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        itemController.text.isEmpty ||
        quantityController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          selectedType == "Donate"
              ? "Donation Submitted ✅"
              : "Request Submitted ✅",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FD3),
        elevation: 0,
        title: const Text(
          "Form",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fill Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),

              /// TYPE
              DropdownButtonFormField(
                value: selectedType,
                decoration: _inputDecoration("Select Type"),
                items: const [
                  DropdownMenuItem(value: "Donate", child: Text("Donate")),
                  DropdownMenuItem(value: "Receive", child: Text("Receive")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

              const SizedBox(height: 14),

              /// NAME
              TextField(
                controller: nameController,
                decoration: _inputDecoration("Full Name"),
              ),

              const SizedBox(height: 14),

              /// PHONE
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Phone Number"),
              ),

              const SizedBox(height: 14),

              /// CATEGORY
              DropdownButtonFormField(
                value: selectedCategory,
                decoration: _inputDecoration("Category"),
                items: const [
                  DropdownMenuItem(value: "Food", child: Text("Food")),
                  DropdownMenuItem(value: "Clothes", child: Text("Clothes")),
                  DropdownMenuItem(value: "Books", child: Text("Books")),
                  DropdownMenuItem(value: "Devices", child: Text("Devices")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 14),

              /// ITEM NAME
              TextField(
                controller: itemController,
                decoration: _inputDecoration("Item Name"),
              ),

              const SizedBox(height: 14),

              /// QUANTITY
              TextField(
                controller: quantityController,
                decoration: _inputDecoration("Quantity"),
              ),

              const SizedBox(height: 14),

              /// LOCATION
              TextField(
                controller: locationController,
                decoration: _inputDecoration("Location"),
              ),

              const SizedBox(height: 14),

              /// DESCRIPTION
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputDecoration("Description (optional)"),
              ),

              const SizedBox(height: 22),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FD3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: submitForm,
                  child: Text(
                    selectedType == "Donate"
                        ? "Submit Donation"
                        : "Submit Request",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F4FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}