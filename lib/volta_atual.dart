import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

bool isStart2 = true;
String stopwatchText2 = '00:00.000';
final stopWatch2 = new Stopwatch();
final timeout2 = const Duration(milliseconds: 1);
bool flag2 = true;
List<String> listaTempos = List<String>();
int voltaAnterior = 1;
List<int> tempoVolta = List<int>();

void startTimeout2() {
  new Timer(timeout2, handleTimeout2);
}

void handleTimeout2() {
  if (stopWatch2.isRunning) {
    startTimeout2();
  }
    setStopwatchText2();
}

void startButtonPressed2() {
    isStart2 = false;
    stopWatch2.start();
    startTimeout2();
}

void resetStartButtonPressed2() {
    stopWatch2.reset();
}

void stopButtonPressed2() {
    if (stopWatch2.isRunning) {
      isStart2 = true;
      stopWatch2.stop();
    }
}

void resetButtonPressed2() {
  if (stopWatch2.isRunning) {
    stopButtonPressed2();
  }
    stopWatch2.reset();
    setStopwatchText2();
}

void setStopwatchText2() {
  stopwatchText2 = stopWatch2.elapsed.inMinutes.toString().padLeft(2, '0') +
      ':' +
      (stopWatch2.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
      ':' +
      (stopWatch2.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0');
}


class cronometro extends StatefulWidget {
  @override
  _cronometroState createState() => _cronometroState();
}

class _cronometroState extends State<cronometro> {
  @override

  Timer timer;
  //Atualização dos setores
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 1), (Timer t) => setState(() {}));
  }


  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              stopwatchText2,
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
                    child: Icon(
                        flag2
                            ? Icons.play_arrow
                            : Icons.refresh),
                    onPressed:(){
                      setState(() {
                        if(flag2 == true){
                          startButtonPressed2();
                          flag2 = false;
                        }
                        else{
                          listaTempos.add("Volta " + voltaAnterior.toString() + "        " + stopwatchText2);
                          tempoVolta.add(stopWatch2.elapsedMilliseconds);
                          resetStartButtonPressed2();
                          voltaAnterior++;
                        }
                      });
                  } ,
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


//Inicio cronometro
bool isStart = true;
String stopwatchText = '00:00.000';
final stopWatch = new Stopwatch();
final timeout = const Duration(milliseconds: 1);

void startTimeout() {
  new Timer(timeout, handleTimeout);
}

void handleTimeout() {
  if (stopWatch.isRunning) {
    startTimeout();
  }
    setStopwatchText();
}

void startButtonPressed() {
    isStart = false;
    stopWatch.start();
    startTimeout();
}

void stopButtonPressed() {
    if (stopWatch.isRunning) {
      isStart = true;
      stopWatch.stop();
    }
}

void resetButtonPressed() {
  if (stopWatch.isRunning) {
    stopButtonPressed();
  }
    stopWatch.reset();
    setStopwatchText();
}

void setStopwatchText() {
  stopwatchText = stopWatch.elapsed.inMinutes.toString().padLeft(2, '0') +
      ':' +
      (stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
      '.' +
      (stopWatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0');
}
//Cronometro final


class displayCronometro extends StatefulWidget {
  @override
  _displayCronometroState createState() => _displayCronometroState();
}

class _displayCronometroState extends State<displayCronometro> {
  Timer timer;
  //Atualização dos setores
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 1), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.none,
      child: Text(
        stopwatchText,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}


class tempos extends StatefulWidget {
  @override
  _temposState createState() => _temposState();
}

class _temposState extends State<tempos> {

  Timer timer;

  //Atualização dos setores
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (listaTempos != null) {
          if (listaTempos.length != 0) {
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: Colors.black),
              itemCount: listaTempos.length,
              itemBuilder: (context, index) {
                return Container(
                  color: tempoVolta[index] <= 5000
                      ? Colors.red
                      : Colors.green,
                  child: ListTile(
                    title: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(listaTempos[index])),
                  ),
                );
              },
            );
          } else {
            return Container(
                child: Stack(children: <Widget>[
                  Opacity(
                    opacity: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/semafaro.jpg'),
                          fit: BoxFit.contain,
                          alignment: Alignment(0.0, -0.5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text("Volta não iniciada",
                      style: TextStyle(fontSize: 40, color: Colors.black),),
                    alignment: Alignment(0, -1),
                  ),
                ]));
          }
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        //barra de progresso
        return CircularProgressIndicator();
      },
    );
  }
}