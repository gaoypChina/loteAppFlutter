

class Blocksgenerals{
   int id;
   int idDia;
   int idLoteria;
   int idSorteo;
   double monto;
   DateTime created_at;
   int idMoneda;

  Blocksgenerals(this.id, this.idDia, this.idLoteria, this.idSorteo, this.monto, this.created_at, this.idMoneda);

Blocksgenerals.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idDia = snapshot['idDia'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        idMoneda = snapshot['idMoneda'] ?? 0
        ;

  static List<Blocksgenerals> fromMapList(var parsed) => parsed != null ? parsed.map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList() : [];


  toJson() {
    return {
      "id": id,
      "idDia": idDia,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "monto": monto,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
    };
  }

  static List blocksgeneralsToJson(List<Blocksgenerals> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build