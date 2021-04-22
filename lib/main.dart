import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import './getData.dart';
import 'volta_atual.dart';


void main() {
  runApp(MyApp());
}

//Início da criação do Widget

class MyApp extends StatelessWidget { //StatelessWidget = sem alteração; widget principal

  @override // @override = sobreescrevendo a função build que irá devolver um Widget e que recebe um BuildContext
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp = widget especial que confere a cara de aplicativo padrão
      debugShowCheckedModeBanner: false, // debugShowCheckedModeBanner serve para mostrar que se está na página em questão
      theme: ThemeData(
        primarySwatch: Colors.yellow, // tema da barra superior
      ),
      home: MyHomePage(title: 'Fenrir Equipe'),
    );
  }
}

class MyHomePage extends StatefulWidget { // StatefulWidget = widget com estado, pode ser alterado 
  MyHomePage({Key key, this.title, post}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
} // Página inicial do aplicativo

class _MyHomePageState extends State<MyHomePage> {


  bool flag = true; // Mudança de página



  final ScrollController controller = ScrollController();  //ScrollController = controla um widget de rolagem
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold = implementa a estrutura básica de layout
      appBar: AppBar( // AppBar = barra de aplicativos exibida na parte superior
        title: Text(widget.title),
      ),
      //Menu
      drawer: Drawer( // Drawer = barra de navegação que fica do lado com os botões
        child: ListView( // ListView = widget de lista rolável de widgets organizados linearmente
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
            ),
            //Botão de Play
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
              onTap: () {
                setState(() {
                  startButtonPressed2();
                  startButtonPressed();
                  flag2 = false;
                });
              },
            ),
            //Botão de Pause
            ListTile(
              leading: Icon(Icons.pause),
              title: Text('Pause'),
              onTap: () {
                setState(() {
                  stopButtonPressed();
                  stopButtonPressed2();
                  flag2 = true;
                });
              },
            ),
            //Botão de Reset
            ListTile(
              onTap: () {
                showAlertDialogReset(context);
              },
              leading: Icon(Icons.refresh),
              title: Text('Reset'),
            ),
            ListTile(
              onTap: () {
                showAlertDialogClear(context);
                velmedia = 0;
                n = 1;
                i = 0;
              },
              leading: Icon(Icons.delete_forever),
              title: Text('Clear sectors and time lap'),
            ),
          ],
        ),
      ),
      //imagem de fundo
      body: Center(
        child: Container(
          child: Stack(children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fenrir.png'),
                    fit: BoxFit.contain, // BoxFit diz respeito a como uma caixa deve ser inscrita em outra caixa, no caso, como a imagem deve ser inscrita
                    alignment: Alignment(0.0, -0.5),
                  ),
                ),
              ),
            ),
            //Cronômetro geral
            Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: displayCronometro(),
                      ),
                    ],
                  ),
                ),
              ),
              //Velocidade média -- falta implementação
              Expanded(
                flex: 2,
                child: Center(
                  child: velocidade(),
                ),
              ),
              //Cronometro da volta atual -- falta implementação
              Expanded(
                  flex: 3,
                  child: Center(
                    child: cronometro()
                  )),
              //Lista de setores
              Divider(height: 5,
              color: Colors.black),
              Expanded(
                flex: 4,
                child:Container(
                  child:Center(
                  child: flag
                    ? getData()
                    : tempos(),
                ),), // Dados recebidos do servidor
              ),
              Expanded(
                flex: 1,
                child: Container(
                    child: Row(  // Row = layout em linha
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: flag
                        ? Colors.yellow
                        : Colors.white,
                        child: FlatButton(
                          child: Icon(Icons.drive_eta),
                          onPressed: (){
                            setState(() {
                              flag = true;
                            });
                          },
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: flag
                            ? Colors.white
                            : Colors.yellow,
                        child: FlatButton(
                          child: Icon(Icons.timer),
                          onPressed: (){
                            setState(() {
                              flag = false;
                            });  // Quando as abas com as listas são selecionadas ficam amarelas; quando não, permanecem brancas.
                          },
                        ),
                      )
                    )
                  ],
                )
              ),
              )
            ])
          ]),
        ),
      ),
    );
  }

  //caixa de confirmação do RESET
  showAlertDialogReset(BuildContext context) {
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
    Widget continuaButton = FlatButton(  // FlatButton = Botão de Texto
      child: Text(
        "Continuar",
        style: TextStyle(
          color: Color(0xFF008000),
        ),
      ),
      onPressed: () {
        setState(() {
          resetButtonPressed();
          Navigator.pop(context);
          resetButtonPressed2();
          flag2 = true;
        });
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("RESET"),
      content: Text("Tem certeza que deseja continuar ?"),
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

  //Caixa de confirmação clear sectors
  showAlertDialogClear(BuildContext context) {
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
        "Continuar",
        style: TextStyle(
          color: Color(0xFF008000),
        ),
      ),
      onPressed: () {
        setState(() {
          cleanList();
          Navigator.pop(context);
          voltaAnterior = 1;
          listaTempos.clear();
          tempoVolta.clear();
          resetButtonPressed();
          Navigator.pop(context);
          resetButtonPressed2();
          flag2 = true;
        });
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("RESET"),
      content: Text("Você está prestes a apagar TODOS os dados, deseja continuar ?"),
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
