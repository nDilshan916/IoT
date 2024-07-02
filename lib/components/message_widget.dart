import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const MessageWidget({
    Key? key,
    required this.text,
    required this.isFromUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 40;
    return Container(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        constraints: BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isFromUser ? Colors.lightBlue : Colors.lightBlueAccent,
          borderRadius: isFromUser
              ? BorderRadius.only(
              bottomRight: Radius.zero,
              bottomLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
              topLeft: Radius.circular(radius))
              : BorderRadius.only(
              bottomRight: Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
              topLeft: Radius.zero),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: MarkdownBody(
          data: text,
        ),
      ),
    );
  }
}
