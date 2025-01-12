import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isListening;

  const VoiceButton({super.key, required this.onPressed, required this.isListening});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(isListening ? Icons.mic : Icons.mic_none),
    );
  }
}
