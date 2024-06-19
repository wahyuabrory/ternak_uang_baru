import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _userInput = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  static const apiKey =
      "AIzaSyCXgodaVJUHVOePhVbQTbshDa8WuI5Ffus"; // Ganti dengan API key Anda
  final model = GenerativeModel(model: 'gemini-1.5-pro-latest', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userInput.text;

    if (message.isEmpty) return;

    final userMessage =
        Message(isUser: true, message: message, date: DateTime.now());
    _addMessage(userMessage);

    _userInput.clear();

    final content = [Content.text(message)];

    try {
      final response = await model.generateContent(content);
      final botMessage = Message(
        isUser: false,
        message: response.text ?? "No response",
        date: DateTime.now(),
      );
      _addMessage(botMessage);
    } catch (e) {
      final errorMessage = Message(
        isUser: false,
        message: "Error: $e",
        date: DateTime.now(),
      );
      _addMessage(errorMessage);
    }
  }

  void _addMessage(Message message) {
    _messages.add(message);
    _listKey.currentState?.insertItem(_messages.length - 1);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 52, 127, 255), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AnimatedList(
                key: _listKey,
                controller: _scrollController,
                initialItemCount: _messages.length,
                itemBuilder: (context, index, animation) {
                  final message = _messages[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Messages(
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date),
                      animationDuration: message.isUser
                          ? const Duration(milliseconds: 0)
                          : const Duration(milliseconds: 100),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              controller: _userInput,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ask anything',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              onFieldSubmitted: (value) => sendMessage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    padding: const EdgeInsets.all(12),
                    iconSize: 30,
                    color: Colors.blueAccent,
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatefulWidget {
  final bool isUser;
  final String message;
  final String date;
  final Duration animationDuration;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
    required this.animationDuration,
  });

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCountAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _charCountAnimation = IntTween(begin: 0, end: widget.message.length)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5).copyWith(
        left: widget.isUser ? 100 : 10,
        right: widget.isUser ? 10 : 100,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.isUser
                    ? const Color.fromARGB(255, 52, 127, 255)
                    : const Color.fromARGB(255, 224, 224, 224),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  bottomLeft:
                      widget.isUser ? const Radius.circular(22) : Radius.zero,
                  topRight: const Radius.circular(22),
                  bottomRight:
                      widget.isUser ? Radius.zero : const Radius.circular(22),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: MarkdownBody(
                data: widget.message.substring(0, _charCountAnimation.value),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                      fontSize: 16,
                      color: widget.isUser ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.date,
              style: TextStyle(
                  fontSize: 10,
                  color: widget.isUser ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
