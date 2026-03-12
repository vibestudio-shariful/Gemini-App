import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(const GeminiApp());

class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String apiKey = "AIzaSyC6TBcU9Ur6kx4cmF_A5qxUb2R1JPqKo3Y";
  late final GenerativeModel model;
  late final ChatSession chat;
  final TextEditingController _controller = TextEditingController();
  final List<Content> _history = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    chat = model.startChat();
  }

  void _send() async {
    if (_controller.text.isEmpty) return;
    final text = _controller.text;
    setState(() { _history.add(Content.text(text)); _loading = true; });
    _controller.clear();
    final response = await chat.sendMessage(Content.text(text));
    setState(() {
      _history.add(Content.model([TextPart(response.text ?? "Error")]));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gemini AI Pro")),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.all(12),
              child: MarkdownBody(data: _history[i].parts.whereType<TextPart>().map((e)=>e.text).join()),
            ),
          )),
          if (_loading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "Ask Gemini..."))),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
