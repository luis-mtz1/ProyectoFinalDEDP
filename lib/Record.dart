
class Record {
  int id;
  String adress1;
  String adress2;
  String latitude1;
  String longitude1;
  String latitude2;
  String longitude2;
  String date;
  String distancia;
  String usuario;

  Record(this.id,this.adress1,this.adress2,this.latitude1,this.longitude1,this.latitude2,this.
          longitude2,this.date,this.distancia,this.usuario);

  Map<String, dynamic> toMap(){
    return {'id': id, 'adress1': adress1, 'adress2': adress2, 'latitude1': latitude1,
      'longitude1': longitude1, 'latitude2': latitude2, 'longitude2': longitude2,
      'date': date, 'distancia': distancia, 'usuario': usuario};
  }

  Record.fromMap(Map<String, dynamic> map){
    id = map['id'];
    adress1 = map['adress1'];
    adress2 = map['adress2'];
    latitude1 = map['latitude1'];
    longitude1 = map['longitude1'];
    latitude2 = map['latitude2'];
    longitude2 = map['longitude2'];
    date = map['date'];
    distancia = map['distancia'];
    usuario = map['usuario'];
  }
}

