import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
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
List<String> dados = List<String>();

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
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
      future: fetchPost(),
      builder: (context, snapshot) {
        current = snapshot.data.lap.toString();
        if (snapshot.data != null) {
          if (previous != current) {
            dados.add(  
            ' Volta: ' + snapshot.data.lap.toString()+
            ' Setor: ' + snapshot.data.lap.toString()+
            '\n Tempo: ' /*+ snapshot.data.datetime.toString()*/+
            ' Velocidade: '+snapshot.data.vel.toString()+' km/h');
          }
          //print(current);
          //print(previous);
          previous = snapshot.data.lap.toString();
          return ListView.separated(
            separatorBuilder: (context,index)=> Divider(color: Colors.black),
            itemCount: dados.length,
            itemBuilder: (context, index) {
              return ListTile(
                title:Padding(padding: EdgeInsets.all(8.0),child:Text(dados[index])),
              );
            },
          );

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
