import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      "sender": "bot",
      "text":
          "Hi! I am OneFinder AI 🤖\nAsk me about donate, receive, category, contact, forms etc.",
    },
  ];

  void sendMessage() {
    final userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({
        "sender": "user",
        "text": userMessage,
      });
    });

    final botReply = getBotReply(userMessage);

    setState(() {
      messages.add({
        "sender": "bot",
        "text": botReply,
      });
    });

    messageController.clear();
  }

  String getBotReply(String message) {
    final text = message.toLowerCase();

    if (text.contains("donate")) {
      return "Go to Donate page, fill name, phone, item details, category, quantity, location and submit.";
    } else if (text.contains("receive")) {
      return "Go to Receive page, fill your need details, phone, quantity and location, then submit request.";
    } else if (text.contains("contact") || text.contains("call")) {
      return "Open the item list and tap the Call button to contact the donor directly.";
    } else if (text.contains("description") || text.contains("item")) {
      return "Write clear item name like Rice, Books, Clothes, Phone, Blanket etc.";
    } else if (text.contains("quantity")) {
      return "Write quantity clearly like 5 books, 10 packets, 2 phones or 50 members.";
    } else if (text.contains("form") || text.contains("submit")) {
      return "Make sure all required fields are filled and phone number is valid 10-digit.";
    } else if (text.contains("category")) {
      return "Choose category based on item: Food, Clothes, Books or Devices.";
    } else if (text.contains("what can i donate") ||
        text.contains("donate items")) {
      return "You can donate food, clothes, books, electronics or any useful items.";
    } else if (text.contains("food")) {
      return "Yes, you can donate food. Make sure it is fresh and mention expiry date.";
    } else if (text.contains("search")) {
      return "Use the search bar on home page to find items or categories.";
    } else if (text.contains("profile") || text.contains("edit")) {
      return "Click profile icon on top right to view or edit your profile.";
    } else if (text.contains("request") || text.contains("see requests")) {
      return "You can see requests or items in category list or dashboard.";
    } else if (text.contains("hi") || text.contains("hello")) {
      return "Hello 👋 I am OneFinder AI. How can I help you?";
    } else {
      return "Try asking:\n- How to donate?\n- How to receive?\n- How to contact donor?\n- Which category to choose?";
    }
  }

  Widget buildMessageBubble(Map<String, String> message) {
    final isUser = message["sender"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF7B1FD3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message["text"] ?? "",
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget buildSuggestionChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: () {
          messageController.text = text;
          sendMessage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FD3),
        title: const Text(
          "OneFinder AI",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              children: [
                buildSuggestionChip("How to donate?"),
                buildSuggestionChip("How to receive?"),
                buildSuggestionChip("How to contact donor?"),
                buildSuggestionChip("Which category to choose?"),
                buildSuggestionChip("What to write in quantity?"),
                buildSuggestionChip("How to edit profile?"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessageBubble(messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF7B1FD3),
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
