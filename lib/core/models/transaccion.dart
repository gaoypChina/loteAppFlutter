

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/models/usuario.dart';

class Transaccion{
   int id;
   Tipo tipo;
   Usuario usuario;
   Entidad entidad1;
   Entidad entidad2;
   Tipo tipoEntidad2;
   int status;
   DateTime created_at;
   double entidad1_saldo_inicial;
   double entidad2_saldo_inicial;
   double debito;
   double credito;
   double entidad1_saldo_final;
   double entidad2_saldo_final;
   String nota;
   String nota_grupo;

  Transaccion({this.id, this.tipo, this.usuario, this.entidad1, this.entidad2, this.status, this.created_at, this.tipoEntidad2, this.entidad1_saldo_inicial, this.entidad2_saldo_inicial, this.debito, this.credito, this.entidad1_saldo_final, this.entidad2_saldo_final, this.nota, this.nota_grupo});

Transaccion.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        tipo = snapshot['tipo'] != null ? Tipo.fromMap(Utils.parsedToJsonOrNot(snapshot['tipo'])) : null,
        tipoEntidad2 = snapshot['tipoEntidad2Object'] != null ? Tipo.fromMap(Utils.parsedToJsonOrNot(snapshot['tipoEntidad2Object'])) : null,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        entidad1 = snapshot['entidad1'] != null ? Entidad.fromMap(Utils.parsedToJsonOrNot(snapshot['entidad1'])) : null,
        entidad2 = snapshot['entidad2'] != null ? Entidad.fromMap(Utils.parsedToJsonOrNot(snapshot['entidad2'])) : null,
        status = snapshot['status'] != null ? Utils.toInt(snapshot['status']) : 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        entidad1_saldo_inicial = snapshot['entidad1_saldo_inicial'] != null ? Utils.toDouble(snapshot['entidad1_saldo_inicial']) : null,
        entidad2_saldo_inicial = snapshot['entidad2_saldo_inicial'] != null ? Utils.toDouble(snapshot['entidad2_saldo_inicial']) : null,
        debito = snapshot['debito'] != null ? Utils.toDouble(snapshot['debito']) : null,
        credito = snapshot['credito'] != null ? Utils.toDouble(snapshot['credito']) : null,
        entidad1_saldo_final = snapshot['entidad1_saldo_final'] != null ? Utils.toDouble(snapshot['entidad1_saldo_final']) : null,
        entidad2_saldo_final = snapshot['entidad2_saldo_final'] != null ? Utils.toDouble(snapshot['entidad2_saldo_final']) : null,
        nota = snapshot['nota'] ?? '',
        nota_grupo = snapshot['nota_grupo'] ?? ''
        ;

  toJson() {
    return {
      "id": id,
      "tipo": tipo,
      "tipoEntidad2": tipoEntidad2,
      "usuario": usuario,
      "entidad1": entidad1,
      "entidad2": entidad2,
      "status": status,
      "created_at": created_at.toString(),
      "entidad1_saldo_inicial": entidad1_saldo_inicial,
      "entidad2_saldo_inicial": entidad2_saldo_inicial,
      "debito": debito,
      "credito": credito,
      "entidad1_saldo_final": entidad1_saldo_final,
      "entidad2_saldo_final": entidad2_saldo_final,
    };
  }

 

  static List transaccionToJson(List<Transaccion> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build