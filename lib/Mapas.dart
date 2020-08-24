import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Principal.dart';
import 'Historial.dart';

class Mapas extends StatefulWidget{
  final double latitud1;
  final double longitud1;
  final double latitud2;
  final double longitud2;
  final String direccion1;
  final String direccion2;
  final String distancia;

  Mapas(this.latitud1, this.longitud1, this.latitud2, this.longitud2,
      this.direccion1, this.direccion2, this.distancia);

  _Mapas createState() => _Mapas();
}

class _Mapas extends State<Mapas>{
  GoogleMapController mapController;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapType _defaultMapType = MapType.hybrid;
  Set<Polyline> lines = {};

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lines.add(
      Polyline(
        points: [LatLng(widget.latitud1, widget.longitud1), LatLng(widget.latitud2, widget.longitud2)],
        color: Colors.yellow,
        polylineId: PolylineId("line_one"),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        visible: true,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    //Guarda los datos de la Api de Google Maps
     mapController = controller;
    _centerView();
  }

  _centerView() async {
    await mapController.getVisibleRegion();

    var left = min(widget.latitud1, widget.latitud2);
    var right = max(widget.latitud1, widget.latitud2);
    var top = max(widget.longitud1, widget.longitud2);
    var bottom = min(widget.longitud1, widget.longitud2);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Distancia entre dos puntos'),
            backgroundColor: Colors.black,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Principal()),
              ),
            ),
          ),
          body: Builder(
            builder: (context) => Stack(
              children: <Widget>[
                GoogleMap(
                  polylines: lines,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  mapType: _defaultMapType,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitud1, widget.latitud2),
                    zoom: 12.0,
                  ),
                  markers: _createMarkers(context),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 12),
                  alignment: Alignment.topLeft,
                  child: ButtonTheme(
                    minWidth: 30,
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(Icons.zoom_out_map),
                          onPressed: _centerView,
                          color: Colors.white70,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                        Text("     "),
                        FlatButton(
                          child: Icon(Icons.layers),
                          onPressed: _changeMapType,
                          color: Colors.white70,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                        Text("     "),
                        FlatButton(
                          child: Icon(Icons.receipt),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Historial()),
                            );
                          },
                          color: Colors.white70,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        ),
    );
  }

  Set<Marker> _createMarkers(BuildContext context) {
    var tmp = Set<Marker>();

    tmp.add(Marker(
      markerId: MarkerId("Punto1"),
      position: LatLng(widget.latitud1, widget.longitud1),
      infoWindow: InfoWindow(title: "Punto1", snippet: widget.direccion1),
      onTap: (){
        String msg="Latitud: "+widget.latitud1.toString()+" \nLongitud: "+widget.longitud1.toString()+
            " \nDistancia al punto 2: "+widget.distancia+" m";
        _showToast(context, msg);
      },
    ));
    tmp.add(Marker(
      markerId: MarkerId("Punto2"),
      position: LatLng(widget.latitud2, widget.longitud2),
      infoWindow: InfoWindow(title: "Punto2", snippet: widget.direccion2),
      onTap: (){
        String msg="Latitud: "+widget.latitud2.toString()+" \nLongitud: "+widget.longitud2.toString()+
            " \nDistancia al punto 1: "+widget.distancia+" m";
        _showToast(context, msg);
      }
    ));
    return tmp;
  }

  void _showToast(BuildContext context, String msg){
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: "UNDO",
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.white,
      ),
    ));
  }

}