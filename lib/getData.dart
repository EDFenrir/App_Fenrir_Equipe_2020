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

Post oldSnapshot = null;

var previous = null;
var current = null;

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
    timer =  Timer.periodic(Duration(milliseconds:500), (Timer t) => setState((){}));
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
      future: fetchPost(),
      builder: (context, snapshot) {
        current = snapshot.data.datetime.toString();
        if (snapshot.data != null ) {
          print(current);
          print(previous);
          previous = snapshot.data.datetime.toString();
          return  ListTile(
            title: Text('Tempo :' + snapshot.data.datetime.toString()),
            subtitle: Text(snapshot.data.vel.toString() + 'km/h'),
            leading: Text('setor: ' + snapshot.data.lap.toString()),
            trailing: Text('Volta: ' + snapshot.data.lap.toString()),
          );
        } else if (snapshot.hasError) {
          //print("estou aqui 3");
          return Text("${snapshot.error}");
        }
        //print("estou aqui 2");
        return CircularProgressIndicator();
      },
    );
  }
}
