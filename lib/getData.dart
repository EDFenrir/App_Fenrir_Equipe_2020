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
  final set;
  final lat;
  final lon;
  final vel;
  final timelap;
  final timeset;
  final datetime;
  Post({this.data, this.lap, this.set, this.lat, this.lon, this.vel, this.timelap, this.timeset, this.datetime});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      data: json['data'],
      lap: json['data']['lap'],
      set: json['data']['set'],
      vel: json['data']['vel'],
      timelap: json['data']['timelap'],
      timeset: json['data']['timeset'],
      datetime: json['data']['datetime'],
    );
  }
}

Future<Post> post;
List<String> dados = List<String>();
List<double> referencia = List<double>();
List<double> novo = List<double>();
Post oldSnapshot;

String previous;
String previous2;
String current;
String current2;

int i = 0, n = 1;
double velmedia = 0;


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
        current = snapshot.data.set.toString();
        current2 = snapshot.data.datetime.toString();
        if (snapshot.data != null) {

          if(previous2 != current2 && previous2 != null) {
            velmedia = (velmedia * i + snapshot.data.vel) / n;
            i++;
            n++;
            print(velmedia);
          }
          //verificação de dados novos
          if (previous != current && previous != null) {
            dados.add(' Volta: ' +
                snapshot.data.lap.toString() +
                ' Setor: ' +
                snapshot.data.set.toString() +
                '\n Tempo: ' /*+ snapshot.data.datetime.toString()*/ +
                ' Velocidade: ' +
                snapshot.data.vel.toString() +
                ' km/h');
            referencia.add(snapshot.data.vel);
          }
          previous = snapshot.data.set.toString();
          previous2 = snapshot.data.datetime.toString();
          //tipo de lista
          if (dados.length != 0) {
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: Colors.black),
              itemCount: dados.length,
              itemBuilder: (context, index) {
                  return Container(
                    color: referencia[index] <= 10.0
                        ? Colors.red
                        : Colors.green,
                    child: ListTile(
                      title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(dados[index])),
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
                    child: Text("Volta não iniciada",style: TextStyle(fontSize: 40, color: Colors.black),),
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
  //Atualização dos setores
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return
      Text(velmedia.toStringAsFixed(2),
        style: TextStyle(fontSize: 50, color: Colors.black),
      );
  }
}