import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  String selectedCategory = 'Food';
  String selectedCondition = 'Good';

  bool isLoading = false;

  final List<String> categories = ['Food', 'Clothes', 'Books', 'Electronics'];
  final List<String> conditions = ['New', 'Good', 'Used'];

  Future<void> saveDonation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'category': selectedCategory,
        'description': itemNameController.text.trim(),
        'location': locationController.text.trim(),
        'quantity': quantityController.text.trim(),
        "status": "pending",
        'condition': selectedCondition,
        'expiryDate': expiryController.text.trim(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'time': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      nameController.clear();
      phoneController.clear();
      itemNameController.clear();
      quantityController.clear();
      locationController.clear();
      expiryController.clear();

      setState(() {
        selectedCategory = 'Food';
        selectedCondition = 'Good';
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation submitted successfully")),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    locationController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1FA),
        elevation: 0,
        title: const Text(
          "Donate",
          style: TextStyle(
            color: Color(0xFF2D1B46),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D1B46)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Donate an Item",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1B46),
                  ),
                ),
                const SizedBox(height: 18),
                _buildLabel("Name"),
                _buildTextField(
                  controller: nameController,
                  hint: "Eg: Kailash",
                ),
                _buildLabel("Phone"),
                _buildTextField(
                  controller: phoneController,
                  hint: "Eg: 9000011122",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                      return "Enter valid 10-digit number";
                    }
                    return null;
                  },
                ),
                _buildLabel("Item Description"),
                _buildTextField(
                  controller: itemNameController,
                  hint: "Eg: Rice / Clothes / Books",
                ),
                _buildLabel("Category"),
                _buildDropdown(
                  value: selectedCategory,
                  items: categories,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                _buildLabel("Quantity"),
                _buildTextField(
                  controller: quantityController,
                  hint: "Eg: 10 packets",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                _buildLabel("Condition"),
                _buildDropdown(
                  value: selectedCondition,
                  items: conditions,
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value!;
                    });
                  },
                ),
                _buildLabel("Location"),
                _buildTextField(
                  controller: locationController,
                  hint: "Eg: Hyderabad",
                ),
                _buildLabel("Expiry Date (for food)"),
                _buildTextField(
                  controller: expiryController,
                  hint: "Eg: 15 Apr 2026",
                ),
                const SizedBox(height: 22),
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
                    onPressed: isLoading ? null : saveDonation,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Donate Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D1B46),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "This field is required";
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F4FB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F4FB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}
