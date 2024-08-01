// message_model.dart
class Message {
  late final String text;
  final bool isUserMessage;
  final String icon;

  Message({required this.text, required this.isUserMessage})
      : icon = isUserMessage ? 'assets/images/user_icon.png' : 'assets/images/bot_icon.png';
}
