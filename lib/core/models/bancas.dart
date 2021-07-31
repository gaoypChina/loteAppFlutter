
import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/comision.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/gastos.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/pagoscombinacion.dart';
import 'package:loterias/core/models/usuario.dart';

class Banca {
  int id;
  String descripcion;
  String codigo;
  String dueno;
  String localidad;
  int status;
  int idMoneda;
  Moneda monedaObject;
  String moneda;
  String monedaAbreviatura;
  String monedaColor;
  double descontar;
  double deCada;
  double limiteVenta;
  double balanceDesactivacion;
  int minutosCancelarTicket;
  int imprimirCodigoQr;
  String piepagina1;
  String piepagina2;
  String piepagina3;
  String piepagina4;

  String ip;
  Usuario usuario;
  Grupo grupo;
  List<Loteria> loterias;
  List<Comision> comisiones;
  List<Pagoscombinacion> pagosCombinaciones;
  List<Gasto> gastos;
  List<Dia> dias;
  double ventasDelDia;
  double balance;


  Banca({this.id, this.descripcion, this.codigo, this.dueno, this.localidad, this.status, this.idMoneda, this.monedaObject, this.monedaAbreviatura, this.monedaColor, this.descontar, this.deCada, this.limiteVenta, this.balanceDesactivacion, this.minutosCancelarTicket, this.imprimirCodigoQr, this.usuario, this.grupo, this.loterias, this.comisiones, this.pagosCombinaciones, this.gastos, this.dias});

  Banca.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        codigo = snapshot['codigo'] ?? '',
        dueno = snapshot['dueno'] ?? '',
        localidad = snapshot['localidad'] ?? '',
        status = snapshot['status'] ?? 1,
        idMoneda = snapshot['idMoneda'] ?? 1,
        monedaObject = snapshot['monedaObject'] != null ? Moneda.fromMap(Utils.parsedToJsonOrNot(snapshot['monedaObject'])) : null,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        grupo = snapshot['grupo'] != null ? Grupo.fromMap(Utils.parsedToJsonOrNot(snapshot['grupo'])) : null,
        moneda = snapshot['moneda'] ?? '',
        monedaAbreviatura = snapshot['monedaAbreviatura'] ?? '',
        monedaColor = snapshot['monedaColor'] ?? '',
        descontar = Utils.toDouble(snapshot['descontar'].toString()) ?? 0.0,
        deCada = Utils.toDouble(snapshot['deCada'].toString()) ?? 0.0,
        limiteVenta = Utils.toDouble(snapshot['limiteVenta'].toString()) ?? 0.0,
        balanceDesactivacion = Utils.toDouble(snapshot['balanceDesactivacion'].toString()) ?? 0.0,
        minutosCancelarTicket = Utils.toInt(snapshot['minutosCancelarTicket'].toString()) ?? 0,
        imprimirCodigoQr = snapshot['imprimirCodigoQr'] ?? 1,
        piepagina1 = snapshot['piepagina1'] ?? '',
        piepagina2 = snapshot['piepagina2'] ?? '',
        piepagina3 = snapshot['piepagina3'] ?? '',
        piepagina4 = snapshot['piepagina4'] ?? '',

        ip = snapshot['ip'] ?? '',
        loterias = (snapshot["loterias"] != null) ? loteriasToMap(Utils.parsedToJsonOrNot(snapshot["loterias"])) : [],
        comisiones = (snapshot["comisiones"] != null) ? comisionesToMap(Utils.parsedToJsonOrNot(snapshot["comisiones"])) : [],
        pagosCombinaciones = (snapshot["pagosCombinaciones"] != null) ? pagosCombinacionesToMap(Utils.parsedToJsonOrNot(snapshot["pagosCombinaciones"])) : [],
        gastos = (snapshot["gastos"] != null) ? gastosToMap(Utils.parsedToJsonOrNot(snapshot["gastos"])) : [],
        dias = (snapshot["dias"] != null) ? diasToMap(Utils.parsedToJsonOrNot(snapshot["dias"])) : [],
        ventasDelDia = Utils.toDouble(snapshot['ventasDelDia'].toString()) ?? 0.0,
        balance = Utils.toDouble(snapshot['balance'].toString()) ?? 0.0
        ;

        static List<Loteria> loteriasToMap(loterias){
          if(loterias != null && loterias.length > 0)
            return loterias.map<Loteria>((data) => Loteria.fromMap(data)).toList();
          else
            return [];
        }

        static List<Comision> comisionesToMap(List<dynamic> comisiones){
          if(comisiones != null && comisiones.length > 0)
            return comisiones.map((data) => Comision.fromMap(data)).toList();
          else
            return [];
        }

        static List<Pagoscombinacion> pagosCombinacionesToMap(List<dynamic> pagosCombinaciones){
          if(pagosCombinaciones != null && pagosCombinaciones.length > 0)
            return pagosCombinaciones.map((data) => Pagoscombinacion.fromMap(data)).toList();
          else
            return [];
        }

        static List<Gasto> gastosToMap(List<dynamic> gastos){
          if(gastos != null && gastos.length > 0)
            return gastos.map((data) => Gasto.fromMap(data)).toList();
          else
            return [];
        }

        static List<Dia> diasToMap(List<dynamic> dias){
          if(dias != null && dias.length > 0)
            return dias.map((data) => Dia.fromMap(data)).toList();
          else
            return [];
        }

        static List bancasToJson(List<Banca> lista) {
          List jsonList = [];
          if(lista == null)
            return jsonList;

          lista.map((u)=>
            jsonList.add(u.toJson())
          ).toList();
          return jsonList;
        }
        

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "codigo": codigo,
      "status": status,
      "idMoneda": idMoneda,
      "moneda": moneda,
      "monedaAbreviatura": monedaAbreviatura,
      "monedaColor": monedaColor,
      "descontar": descontar,
      "deCada": deCada,
      "limiteVenta": limiteVenta,
      // "imprimirCodigoQr": imprimirCodigoQr,
      "piepagina1": piepagina1,
      "piepagina2": piepagina2,
      "piepagina3": piepagina3,
      "piepagina4": piepagina4,
      "ventasDelDia": ventasDelDia,
    };
  }

  toJsonSave() {
    return {
      "id": id,
      "descripcion": descripcion,
      "codigo": codigo,
      "dueno": dueno,
      "localidad": localidad,
      "status": status,
      "idMoneda": idMoneda,
      "monedaAbreviatura": monedaAbreviatura,
      "monedaColor": monedaColor,
      "descontar": descontar,
      "deCada": deCada,
      "limiteVenta": limiteVenta,
      "balanceDesactivacion": balanceDesactivacion,
      "minutosCancelarTicket": minutosCancelarTicket,
      "imprimirCodigoQr": imprimirCodigoQr,
      "piepagina1": piepagina1,
      "piepagina2": piepagina2,
      "piepagina3": piepagina3,
      "piepagina4": piepagina4,
      "monedaObject": monedaObject != null ? monedaObject.toJson() : null,
      "usuario": usuario != null ? usuario.toJson() : null,
      "grupo": grupo != null ? grupo.toJson() : null,
      "loterias" : Loteria.loteriasToJson(loterias),
      "comisiones" : Comision.comisionesToJson(comisiones),
      "pagosCombinaciones" : Pagoscombinacion.pagosCombinacionesToJson(pagosCombinaciones),
      "gastos" : Gasto.gastosToJson(gastos),
      "dias" : Dia.diasToJson(dias),
    };
  }
}