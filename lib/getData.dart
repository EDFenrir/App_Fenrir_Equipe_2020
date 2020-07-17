import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Comunicação com o servidor
//Future is a core Dart class for working with async operations.
//A Future object represents a potential value or error that will
//be available at some time in the future.
Future<Post> fetchPost() async {
  final response = await http.get('http://35.194.6.143/FenrirApi/newest');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Falha ao carregar um post');
  }
}

//Conteúdo do Post (dados que são utilizados)
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
List<String> dados = List<String>();
List<double> referencia = List<double>();
List<double> novo = List<double>();
Post oldSnapshot = null;

String previous = null;
String current = null;

class getData extends StatefulWidget {
  getData({Key key, this.title, post}) : super(key: key);
  final String title;

  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<getData> {
  Timer timer;
  //Atualização dos setores
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));
  }

  Widget build(BuildContext context) {
    //resultado da requisição de dados
    return FutureBuilder<Post>(
      future: fetchPost(),
      builder: (context, snapshot) {
        current = snapshot.data.lap.toString();
        if (snapshot.data != null) {
          //verificação de dados novos
          if (previous != current) {
            dados.add(' Volta: ' +
                snapshot.data.lap.toString() +
                ' Setor: ' +
                snapshot.data.lap.toString() +
                '\n Tempo: ' /*+ snapshot.data.datetime.toString()*/ +
                ' Velocidade: ' +
                snapshot.data.vel.toString() +
                ' km/h');
            referencia.add(snapshot.data.vel);
          }
          previous = snapshot.data.lap.toString();
          //tipo de lista
          if (dados.length != 0) {
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: Colors.black),
              itemCount: dados.length,
              itemBuilder: (context, index) {
                if (referencia[index] <= 10.0) {
                  return Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(dados[index])),
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.green,
                    child: ListTile(
                      title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(dados[index])),
                    ),
                  );
                }
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
                child: Text("Volta não iniciada",style: TextStyle(fontSize: 40, color: Colors.black),),
                alignment: Alignment(0, -1),
              ),
            ]));
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        //barra de progresso
        return CircularProgressIndicator();
      },
    );
  }
}

void cleanList() {
  dados.clear();
  referencia.clear();
}

class velocidade extends StatefulWidget {
  velocidade({Key key, this.title, post}) : super(key: key);
  final String title;
  @override
  _velocidadeState createState() => _velocidadeState();
}

class _velocidadeState extends State<velocidade> {
  Timer timer;
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));
  }

  int i = 0, n = 1;
  double velmedia = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
      future: fetchPost(),
      builder: (context, snapshot) {
        current = snapshot.data.lap.toString();
        if (snapshot.data != null) {
          if (previous != current) {
            velmedia = (velmedia*i + snapshot.data.vel)/n;
            i++;
            n++;
          }
          //print(current);
          //print(previous);
          previous = snapshot.data.lap.toString();
              return Text(
                "\n \n " + velmedia.toString(),
                style: TextStyle(fontSize: 55, color: Colors.black),
              );


        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
