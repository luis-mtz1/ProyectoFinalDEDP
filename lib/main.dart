import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Principal.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final myControlles = TextEditingController();

  _recuperarDatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myControlles.text=(prefs.getString("usuario") ?? "");
    });
  }

  _guardarDatos1(String user) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("usuario", user);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text("Proyecto Final"),
            backgroundColor: Colors.black,
          ),
          body: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'imagenes/geo.png',
                        width: 180.0,
                        height: 200.0,
                      ),
                      Text(
                        "Distancia entre dos puntos",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Nombre"
                        ),
                        controller: myControlles,
                        autofocus: true,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,

                      ),
                      Text(
                        "",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 300.0,
                        height: 50.0,
                        child: FlatButton(
                          child: new Text("Ingresar", style: TextStyle(
                            fontSize: 35,
                          ),
                          ),
                          color: Colors.deepOrange,
                          padding: EdgeInsets.all(16.0),
                          textColor: Colors.white,
                          onPressed: () {
                            if(myControlles.text!=""){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Principal()),
                              );
                              _guardarDatos1(myControlles.text);
                            } else{
                              _showToast(context);
                            }
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
          )
        ),
    );
  }

  void _showToast(BuildContext context){
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text("Introduce tu nombre"),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: "UNDO",
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.white,
      ),
    ));
  }
}