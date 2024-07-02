import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:iot/components/message_widget.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _isTyping = false;
  List<Content> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  void _initializeModel() {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      _showError('API Key not found');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1.0,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.text(
          "Welcome to SHEMS (Smart Home Energy Management System)!..."
      ),
    );
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _messages.length) {
                    return _buildTypingIndicator();
                  }
                  final Content content = _messages[index];
                  final text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return MessageWidget(
                    text: text,
                    isFromUser: content.role == 'user',
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration(),
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _sendChatMessage(_textController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Text("typing "),
          TypingIndicator(),
        ],
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    final userMessage = Content(
      'user',
      [TextPart(message)],
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
      _scrollDown();
    });
    _textController.clear();
    _textFieldFocus.requestFocus();

    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      final text = response.text;
      if (text == null) {
        _showError('No response from API');
        return;
      } else {
        final aiMessage = Content(
          'assistant',
          [TextPart(text)],
        );
        setState(() {
          _messages.add(aiMessage);
          _isTyping = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void _showError(String message) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: SingleChildScrollView(
              child: SelectableText(message),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }
}
