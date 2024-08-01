import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../service/api_service.dart';
import '../../utils/constants.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'message': 'Hello, how may I help you?'}
  ];
  bool _isLoading = false;
  final Map<String, String> _languageMap = {
    'English': 'en_US',
    'Hindi': 'hi_IN',
    'Bengali': 'bn_IN',
    'Kannada': 'kn_IN',
    'Gujarati': 'gu_IN',
    'Malayalam': 'ml_IN',
    'Marathi': 'mr_IN',
    'Tamil': 'ta_IN',
    'Telugu': 'te_IN',
    'Urdu': 'ur_IN',
  };
  String _selectedLanguage = 'English';
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({'sender': 'user', 'message': message});
      _isLoading = true;
    });

    try {
      String response = await ApiService.sendMessage(message);
      setState(() {
        _messages.add({'sender': 'bot', 'message': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'message': 'Error: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
          localeId: _languageMap[_selectedLanguage]!,
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'FarmBot',
              style: TextStyle(
                color: AppColors.darkAppColor300,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Powered by Gemini',
              style: TextStyle(
                color: AppColors.darkAppColor300,
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            icon: const Icon(Icons.language, color: AppColors.darkAppColor300),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: _languageMap.keys.map<DropdownMenuItem<String>>((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(key,style: const TextStyle(color: AppColors.darkAppColor300),),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message['message']!,
                  isUser: message['sender'] == 'user',
                  userName: 'User',
                  userIcon: Icons.person,
                  botName: 'Chatbot',
                  botIcon: Icons.face,
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
                        decoration: const InputDecoration(
                          hintText: 'Enter your message...',
                          hintStyle: TextStyle(color: AppColors.lightAppColor600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: _startListening,
                  onLongPressEnd: (details) => _stopListening(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? AppColors.primaryColor.withOpacity(0.3) : Colors.transparent,
                        ),
                      ),
                      Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? AppColors.primaryColor : AppColors.darkAppColor300,
                      ),
                    ],
                  ),
                ),
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
