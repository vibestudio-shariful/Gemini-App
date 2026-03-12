import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const GeminiWebApp());

class GeminiWebApp extends StatelessWidget {
  const GeminiWebApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const GeminiWebView(),
    );
  }
}

class GeminiWebView extends StatefulWidget {
  const GeminiWebView({super.key});
  @override
  State<GeminiWebView> createState() => _GeminiWebViewState();
}

class _GeminiWebViewState extends State<GeminiWebView> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF131314))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://gemini.google.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // নিচের AppBar টি আপনি চাইলে সরিয়ে দিতে পারেন একদম ফুল স্ক্রিন ফিল পেতে
      appBar: AppBar(
        title: const Text("Gemini AI", style: TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF131314),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.reload()),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
