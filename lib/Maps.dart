import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Historial.dart';

class Maps extends StatelessWidget {
  GoogleMapController mapController;
  //posicion debe llamarse igual al key que pasé como parámetro

  //final posiciones;
  final double latitud1;
  final double longitud1;
  final double latitud2;
  final double longitud2;
  final String direccion1;
  final String direccion2;

  Maps(this.latitud1, this.longitud1, this.latitud2, this.longitud2,
      this.direccion1, this.direccion2);

  void _onMapCreated(GoogleMapController controller) {
    //Guarda los datos de la Api de Google Maps
    mapController = controller;

    _centerView();

  }

  _centerView() async {
    await mapController.getVisibleRegion();

    var left = min(latitud1, latitud2);
    var right = max(latitud1, latitud2);
    var top = max(longitud1, longitud2);
    var bottom = min(longitud1, longitud2);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
      child: new MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Distancia entre dos puntos'),
            backgroundColor: Colors.black,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  mapType: MapType.satellite,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitud1, latitud2),
                    zoom: 12.0,
                  ),
                  markers: _createMarkers(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(Icons.zoom_out_map),
                        elevation: 10,
                        backgroundColor: Colors.blueAccent,
                        tooltip: "Centrar",
                        onPressed: () {
                          _centerView();
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
      markerId: MarkerId("Punto1"),
      position: LatLng(latitud1, longitud1),
      infoWindow: InfoWindow(title: "Punto1", snippet: direccion1),
    ));
    tmp.add(Marker(
      markerId: MarkerId("Punto2"),
      position: LatLng(latitud2, longitud2),
      infoWindow: InfoWindow(title: "Punto2", snippet: direccion2),
    ));
    return tmp;
  }
}