import 'dart:async';
import 'package:flutter/material.dart';

class cronometro extends StatefulWidget {
  @override
  _Cronometro createState() => _Cronometro();
}

class _Cronometro extends State<cronometro> {

  bool _isStart = true;
  String _stopwatchText = '00:00:00';
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);

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

  void _resetButtonPressed(){
    if(_stopWatch.isRunning){
      _startStopButtonPressed();
    }
    setState(() {
     _stopWatch.reset();
     _setStopwatchText(); 
    });
  }

  void _setStopwatchText(){
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2,'0') + ':'+
                     (_stopWatch.elapsed.inMinutes%60).toString().padLeft(2,'0') + ':' +
                     (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2,'0');
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
      ],
    );
  }

}