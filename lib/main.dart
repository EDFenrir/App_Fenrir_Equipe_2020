import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './getData.dart';

/*Future<Post> fetchPost() async {
  final response = await http.get('http://35.194.6.143/FenrirApi/newest');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Falha ao carregar um post');
  }
}

class Post {
  final data;
  final lap;
  final lat;
  final lon;
  final vel;
  final datetime;
  Post({this.data, this.lap, this.lat, this.lon, this.vel, this.datetime});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      data: json['data'],
      lap: json['data']['lap'],
      vel: json['data']['vel'],
      datetime: json['data']['datetime'],
    );
  }
}

Future<Post> post;

Post oldSnapshot = null;

var previous = null;
var current = null;
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Fenrir Equipe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, post}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  bool _isStart = true;
  String _stopwatchText = '00:00.000';
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(milliseconds: 1);

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

  void _startButtonPressed() {
    setState(() {
      _isStart = false;
      _stopWatch.start();
      _startTimeout();
    });
  }

  void _stopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _isStart = true;
        _stopWatch.stop();
      }
    });
  }

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _stopButtonPressed();
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
        '.' +
        (_stopWatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0');
  }

  final ScrollController controller = ScrollController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              child: Image(
                image: AssetImage('assets/images/fenrir_completo.png'),
                fit: BoxFit.contain,
              ),
              /*Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                ),
              ),*/
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
              onTap: () {
                _startButtonPressed();
              },
            ),
            ListTile(
              leading: Icon(Icons.pause),
              title: Text('Pause'),
              onTap: () {
                _stopButtonPressed();
              },
            ),
            ListTile(
              onTap: () {
                showAlertDialog(context);
              },
              leading: Icon(Icons.refresh),
              title: Text('Reset'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Stack(children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fenrir.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment(0.0, -0.5),
                  ),
                ),
              ),
            ),
            Column(children: <Widget>[
              Expanded(
                flex: 10,
                child: Center(
                  child: Column(
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
                  ),
                ),
              ),
              Expanded(
                flex: 25,
                child: Center(
                  child: Text(
                    "\n \n 20 km/h",
                    style: TextStyle(fontSize: 55, color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                  flex: 20,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "\n \n Volta Atual ",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        Text(
                          "00:46:00",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          textColor: Colors.black,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.yellow,
                                  Color(0xFFFFFF00),
                                  Color(0xFFFFFF80),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text(
                              '    START    ',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 35,
                child: Center(
                  child: ListView(
                    children: <Widget>[getData()],),
                  
                  /*ListView(
                   children: <Widget>[
                     FutureBuilder<Post>(
                    
                    future: fetchPost(),
                    builder: (context, snapshot) {
                      current = snapshot.data.datetime.toString();
                      if (snapshot.data != null && current!= previous)  {
                        previous = snapshot.data.datetime.toString(); 
                        return ListTile(title: Text('Volta :' +
                              snapshot.data.lap.toString()));
                                              
                      } else if (snapshot.hasError) {
                        //print("estou aqui 3");
                        return Text("${snapshot.error}");
                      }
                      //print("estou aqui 2");
                      return CircularProgressIndicator();
                    },
                  ),]
 
                  )*/
                                  ),
              ),
            ])
          ]),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
          color: Color(0xFFFF0000),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text(
        "Continar",
        style: TextStyle(
          color: Color(0xFF008000),
        ),
      ),
      onPressed: () {
        _resetButtonPressed();
        Navigator.pop(context);
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("RESET"),
      content: Text("Você está absolutamente certo disso ?"),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
