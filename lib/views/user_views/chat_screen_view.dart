import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage:
          "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("AI Therapy Chat"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    _generateResponse(chatMessage.text);
  }

  Future<void> _generateResponse(String question) async {
    String apiKey = 'AIzaSyAuBwAkhTxcmKUtUCrw4pF8bzD3ZeZEoNA';
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro-001:generateContent?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};

    // Mevcut konuşmanın bağlamını eklemek için messages listesini kullan
    List<Map<String, dynamic>> conversationParts = messages.map((message) {
      return {"text": "${message.user.firstName}: ${message.text}"};
    }).toList();

    // Yeni kullanıcı mesajını ekle
    conversationParts.add({"text": "${currentUser.firstName}: $question"});

    String requestBody = jsonEncode({
      "contents": [
        {
          "parts": conversationParts,
        }
      ],
      "generationConfig": {
        "temperature": 0.9,
        "topK": 1,
        "topP": 1,
        "maxOutputTokens": 2048,
        "stopSequences": []
      },
      "safetySettings": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
      ]
    });

    http.Response response =
        await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      print("İstek başarılı bir şekilde gönderildi");
      final responseJson = jsonDecode(response.body);
      final generatedText = responseJson['candidates'][0]['content'];

      // Gemini cevabını ekle
      ChatMessage message = ChatMessage(
          user: geminiUser, createdAt: DateTime.now(), text: generatedText);
      setState(() {
        messages = [message, ...messages];
      });
    } else {
      print("İstek başarısız oldu: ${response.statusCode}");
    }
  }
}
