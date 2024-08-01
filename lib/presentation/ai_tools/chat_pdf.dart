import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../service/file_picker_service.dart';
import '../../utils/constants.dart';
import '../widgets/chat_bubble2.dart';

class ChatPdf extends StatefulWidget {
  const ChatPdf({super.key});

  @override
  State<ChatPdf> createState() => _ChatPdfState();
}

class _ChatPdfState extends State<ChatPdf> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'bot', 'message': 'Hello, how may I help you?'}
  ];
  bool _isLoading = false;

  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  Future<void> _initializeAI() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) {
        throw Exception('No \$API_KEY environment variable');
      }
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 10000),
      );
      _chat = _model.startChat(history: [
        Content.text('Hello, how may I help you?'),
      ]);
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'message': 'Error: $e'});
      });
    }
  }

  Future<void> _sendMessage(String message, {bool isVisible = true}) async {
    if (isVisible) {
      setState(() {
        _messages.add({'sender': 'user', 'message': message});
        _isLoading = true;
      });
    }

    try {
      var response = await _chat.sendMessage(Content.text(message));
      setState(() {
        _messages.add({'sender': 'bot', 'message': response.text});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'message': 'Error: $e'});
      });
    } finally {
      if (isVisible) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (isVisible) {
      _controller.clear();
    }
  }

  Future<void> _handleAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      try {
        String extractedText = await FilePickerService.extractText(file);

        if (extractedText.length > 1000000) {
          setState(() {
            _messages.add({'sender': 'bot', 'message': 'Error: File is too large.'});
          });
        } else {
          setState(() {
            _messages.add({
              'sender': 'user',
              'message': '',
              'preview': file.path!,
            });
          });

          // Send the instruction and extracted text to the AI model without displaying them in the chatbox
          await _sendMessage("You are 'FarmBot' a helpful chatbot who answer all the questions related to farmers and farming related questions only, First greet and then answer the follow-up questions.", isVisible: false);
          for (int i = 0; i < extractedText.length; i += 5000) {
            await _sendMessage(
              extractedText.substring(
                i,
                i + 5000 > extractedText.length ? extractedText.length : i + 5000,
              ),
              isVisible: false,
            );
          }
        }
      } catch (e) {
        setState(() {
          _messages.add({'sender': 'bot', 'message': 'Error: $e'});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat with PDF/Images',
              style: TextStyle(
                color: AppColors.darkAppColor300,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'AI may produce wrong answers. Use responsibly.',
              style: TextStyle(
                color: Color(0xFFfc6666),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubblePDF(
                  message: message['message'] ?? '',
                  isUser: message['sender'] == 'user',
                  previewPath: message['preview'],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: AppColors.darkAppColor300,
                        width: 1.0,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 48,
                        maxHeight: 100.0,
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: ' Enter your message...',
                          hintStyle: TextStyle(color: AppColors.lightAppColor600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4,),
                IconButton(
                  icon: const Icon(Icons.attach_file,color: AppColors.darkAppColor300,),
                  onPressed: _handleAttachment,
                ),
                const SizedBox(width: 4,),
                IconButton(
                  icon: const Icon(Icons.send,color: AppColors.darkAppColor300,),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}