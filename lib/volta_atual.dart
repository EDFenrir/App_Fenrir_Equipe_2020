import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class cronometro extends StatefulWidget {
  @override
  _cronometroState createState() => _cronometroState();
}

class _cronometroState extends State<cronometro> {
  @override
  bool _isStart = true;
  String _stopwatchText = '00:00.000';
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(milliseconds: 2);

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _isStart = true;
        _stopWatch.stop();
      } else {
        _isStart = false;
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inMinutes.toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              _stopwatchText,
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Icon(_isStart ? Icons.play_arrow : Icons.stop),
                    onPressed: _startStopButtonPressed,
                    color: Colors.yellow,
                  ),
                  RaisedButton(
                    child: Text('Reset'),
                    onPressed: _resetButtonPressed,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
