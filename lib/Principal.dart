import 'package:address_search_text_field/address_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:proyectofinal/db_helper.dart';
import 'package:proyectofinal/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Historial.dart';
import 'Record.dart';
import 'db_helper.dart';
import 'Mapas.dart';
import 'main.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String user;
  static var now = new DateTime.now();
  static var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  //Instancia del objeto Geolocator
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final snackBar = SnackBar(content: Text('Porfavor agrega ambas direcciones'));

  TextEditingController controller = TextEditingController();

  _recuperarDatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user=(prefs.getString("usuario") ?? "");
    });
  }

  //De este objeto sacaremos las coordenadas
  String _currentAddress1;
  String _currentAddress2;
  double _latitud1, _longitud1, _latitud2, _longitud2;

  var dbHelper;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    _recuperarDatos();
  }

  //En esta cadena guardamos la dirección

  String _distancia="La distancia entre ambos puntos es de: ";

  double _distanciaEnMetros;
  String _distacinaRecta;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Ubicación"),
          backgroundColor: Colors.black,
          leading: new IconButton(
            icon: new Icon(Icons.home),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MyApp()),
              );
              dispose();
            }
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
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
                    Text("",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    AddressSearchTextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        icon: Image.asset(
                          'imagenes/dire.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      country: "Mexico",
                      city: "Leon",
                      hintText: "Introduce dirección",
                      noResultsText: "No se encontro la dirección ingresada",
                      onDone: (AddressPoint point) {
                        print(point.latitude);
                        print(point.longitude);

                        _latitud1=point.latitude;
                        _longitud1=point.longitude;
                        _currentAddress1=point.address;
                        //_guardarDatos1(_currentAddress1);
                        controller1.text=_currentAddress1;

                        //_getAddressFromLatLng1();
                        Navigator.of(context).pop();
                      },
                    ),
                    AddressSearchTextField(
                      controller: controller2,
                      decoration: InputDecoration(
                        icon: Image.asset(
                          'imagenes/dire.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      country: "Mexico",
                      city: "Leon",
                      hintText: "Introduce dirección",
                      noResultsText: "No se encontro la dirección ingresada",
                      onDone: (AddressPoint point) {
                        print(point.latitude);
                        print(point.longitude);

                        _latitud2=point.latitude;
                        _longitud2=point.longitude;
                        _currentAddress2=point.address;
                        //_guardarDatos2(_currentAddress2);
                        controller2.text=_currentAddress2;

                        //_getAddressFromLatLng2();
                        Navigator.of(context).pop();
                      },
                      onCleaned: () {},
                    ),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    FlatButton(
                      child: Text("Obetener Distancia", style: TextStyle(
                        fontSize: 20,
                      ),
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_latitud1==null || _longitud1==null){
                          String msg="Introduce la direccion 1";
                          _showToast(context, msg);
                        } else if (_latitud2==null || _longitud2==null){
                          String msg="Introduce la direccion 2";
                          _showToast(context, msg);
                        } else{
                          obtenerDistancia();
                          setState(() {
                            if(_distanciaEnMetros!=null){
                              _distacinaRecta=_distanciaEnMetros.toStringAsFixed(2);
                              _distancia="La distancia entre ambos puntos es de: $_distacinaRecta m";
                            }
                          });
                        }
                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    //if(_distanciaEnMetros!=null)
                    Text(
                      _distancia,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    IconButton(
                      //child: Text("Abrir Mapa", style: TextStyle(
                      //fontSize: 20,
                      //),
                      //),
                      icon: Image.asset('imagenes/maps.png',
                        width: 100,
                        height: 100,
                      ),
                      color: Colors.blueAccent,
                      //textColor: Colors.white,
                      onPressed: () {
                        //Abro pantalla pasando como parámetro el objeto Position
                        if (_latitud1==null || _longitud1==null){
                          String msg="Introduce la direccion 1";
                          _showToast(context, msg);
                        } else if (_latitud2==null || _longitud2==null){
                          String msg="Introduce la direccion 2";
                          _showToast(context, msg);
                        } else if(_distanciaEnMetros==null){
                          String msg="Obten la distancia";
                          _showToast(context, msg);
                        } else if(user==""){
                          String msg="Error";
                          _showToast(context, msg);
                        }else{
                          Record r=Record(null, _currentAddress1, _currentAddress2, _latitud1.toString(),
                              _longitud1.toString(), _latitud2.toString(), _longitud2.toString(),
                              formattedDate, _distacinaRecta, user);
                          dbHelper.save(r);
                          controller1.clear();
                          controller2.clear();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Mapas(_latitud1, _longitud1, _latitud2, _longitud2,
                                  _currentAddress1,_currentAddress2, _distacinaRecta)
                          ));
                          dispose();
                        }
                      },
                      //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    Text("Abir Maps",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    FlatButton(
                      child: Text("Historial de Ubicaciones", style: TextStyle(
                        fontSize: 20,
                      ),
                      ),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Historial()),
                        );
                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  void _showToast(BuildContext context, String msg){
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: "UNDO",
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.white,
      ),
    ));
  }

  obtenerDistancia() async {
    _distanciaEnMetros = await geolocator.distanceBetween(_latitud1,_longitud1,_latitud2,_longitud2);
  }
}