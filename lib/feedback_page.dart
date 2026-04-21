import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();

  int rating = 0;
  bool isLoading = false;

  Future<void> submitFeedback() async {
    if (feedbackController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'message': feedbackController.text.trim(),
        'rating': rating,
        'userId': FirebaseAuth.instance.currentUser?.uid ?? '',
        'time': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        feedbackController.clear();
        rating = 0;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted")),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
      ),
      onPressed: () {
        setState(() {
          rating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FA),
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: const Color(0xFF7B1FD3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Feedback",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // ⭐ Rating
              Row(
                children: List.generate(5, (index) => buildStar(index + 1)),
              ),

              const SizedBox(height: 10),

              // 📝 Text field
              TextField(
                controller: feedbackController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Write your feedback...",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FD3),
                  ),
                  onPressed: isLoading ? null : submitFeedback,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
