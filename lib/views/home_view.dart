import 'package:flutter/material.dart';
import '../services/ai_services.dart';
import '../services/stt_services.dart';
import '../services/tts_services.dart';
import '../widgets/voice_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final STTService _sttService = STTService();
  final TTSService _ttsService = TTSService();
  late AIService _aiService;

  List<Map<String, String>> _messages = [];
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _aiService = AIService("YOUR_API_KEY_HERE");
  }

  void _startListening() async {
    bool available = await _sttService.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _sttService.startListening((result) {
        setState(() {
          if (!_isListening) {
            _messages.add({"role": "user", "content": result});
          }
        });
      });
    }
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
    });
    _sttService.stopListening();

    if (_messages.isNotEmpty) {
      String userMessage = _messages.last["content"]!;
      String aiResponse = await _aiService.getAIResponse(userMessage);
      setState(() {
        _messages.add({"role": "assistant", "content": aiResponse});
      });
      _ttsService.speak(aiResponse);
    }
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    bool isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message["content"]!,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isListening ? "Listening..." : "Press the mic to speak",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                VoiceButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  isListening: _isListening,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
