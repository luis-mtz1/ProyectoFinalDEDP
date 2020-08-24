import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal/Mapas.dart';
import 'Record.dart';
import 'db_helper.dart';
import 'Mapas.dart';

class Historial extends StatefulWidget {
  @override
  _Historial createState() => _Historial();
}

class _Historial extends State<Historial>{
  Future<List<Record>> records;
  var dbHelper;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList(){
    records = dbHelper.getRecords();
  }

  SingleChildScrollView dataTable(List<Record> records){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: 0,
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(
                label: Text('Usuario',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                tooltip: "Usuario que realizo la busqueda"
            ),
            DataColumn(
                label: Text('Fecha',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                tooltip: "Fecha en la que se realizo busqueda"
            ),
            DataColumn(
                label: Text('Direcció 1',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                tooltip: "Primera direccion buscada"
            ),
            DataColumn(
                label: Text('Direcció 2',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                tooltip: "Segunda direccion buscada"
            ),
            DataColumn(
                label: Text('Distancia',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                tooltip: "Distancia en linea recta de ambos puntos"
            ),
            DataColumn(
                label: Text(''),
                tooltip: "Buscar nuevamente en el mapa"
            ),
          ],
          rows: records.map((record) => DataRow(
              cells: [
                DataCell(
                    Text(record.usuario,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                DataCell(
                    Text(record.date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                DataCell(
                    Text(record.adress1)
                ),
                DataCell(
                    Text(record.adress2)
                ),
                DataCell(
                    Text(record.distancia+" m")
                ),
                DataCell(
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Mapas(double.parse(record.latitude1),
                                  double.parse(record.longitude1), double.parse(record.latitude2),
                                  double.parse(record.longitude2), record.adress1, record.adress2, record.distancia)
                          ));
                        },
                      ),
                    )
                ),
              ]
          ),).toList(),
        ),
      ),
    );
  }

  list(){
    return Expanded(
      child: FutureBuilder(
        future: records,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return dataTable(snapshot.data);
          }

          if(null==snapshot.data || snapshot.data == 0){
            return Text("Sin datos");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(onWillPop: () async => false,
        child: new Scaffold (
          appBar: AppBar(
            title: Text('Historial de Ubicaciones'),
            backgroundColor: Colors.black,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                list(),
              ],
            ),
          ),
        )
    );
  }

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(onWillPop: () async => false,
      child: new Scaffold (
        appBar: AppBar(
         title: Text('Historial de Ubicaciones'),
         backgroundColor: Colors.black,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ),
        body: ListView (
          children: <Widget>[
            ListTile (
              leading: Image.asset ('imagenes/maps.png', color: Colors.black54),
              title: Text('Historial 1', style: TextStyle(
                fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Direccion 1 \nDireccion 2'),
              contentPadding: EdgeInsets.all(5.0),
            ),

            ListTile (
              leading: Image.asset ('imagenes/maps.png', color: Colors.black54),
              title: Text('Historial 1', style: TextStyle(
                fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Direccion 1 \nDireccion 2'),
              contentPadding: EdgeInsets.all(5.0),
            )
          ],
        ),
      )
    );
  }*/
}