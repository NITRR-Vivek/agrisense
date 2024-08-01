import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/constants.dart';

class ChatBubblePDF extends StatelessWidget {
  final String message;
  final bool isUser;
  final String? previewPath;

  const ChatBubblePDF({
    required this.message,
    required this.isUser,
    this.previewPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Icon(isUser ? Icons.person : Icons.face),
                    const SizedBox(width: 5),
                    Text(
                      isUser ? 'User' : 'Chatbot',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (message.isNotEmpty)
                          MarkdownBody(
                            data: message,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        if (previewPath != null)
                          Image.file(File(previewPath!)),
                      ],
                    ),
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
