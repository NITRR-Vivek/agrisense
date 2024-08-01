import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../utils/constants.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isUser;
  final String userName;
  final IconData userIcon;
  final String botName;
  final IconData botIcon;

  const ChatBubble({
    required this.message,
    required this.isUser,
    required this.userName,
    required this.userIcon,
    required this.botName,
    required this.botIcon,
    super.key,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  Future<void> _speak(String message) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(message);
    setState(() {
      _isSpeaking = true;
    });
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.isUser ? widget.userName : widget.botName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Icon(widget.isUser ? widget.userIcon : widget.botIcon,),
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    if (_isSpeaking) {
                      _stop();
                    } else {
                      _speak(widget.message);
                    }
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.isUser ? AppColors.darkAppColor200 : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: widget.message,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: widget.isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.volume_up,
                              size: 16,
                              color: widget.isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
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
