import 'dart:async';
import 'package:flutter/material.dart';

class TextWriting extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;

  const TextWriting({
    super.key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 60),
  });

  @override
  State<TextWriting> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TextWriting> {
  String _visibleText = "";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_index];
          _index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visibleText,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
