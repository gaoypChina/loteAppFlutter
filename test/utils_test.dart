import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/escanerqrservice.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/loterias.dart';


void main() {
  group("Utils test", (){
    test("Testing toInt", () async {
      var data = Utils.toInt("null");
      print("data: $data");
      expect(data == null, false);
    });

    test("Testing toDouble", () async {
      var data = Utils.toDouble(null);
      print("Utils_test Testing toDouble: $data");
      expect(data == null, false);
    });

    test("Testing toBigInt", () async {
      var data = Utils.toBigInt(10);
      print("Utils_test Testing toBigInt: $data");
      expect(data == null, false);
    });

    test("Testing lastMonth", () async {
      var data = Utils.getLastMonth(DateTime.parse("2021-03-01"), dayOfTheMonth: 31);
      print("data: $data");
      expect(data == null, false);
    });

   
  test("Testing loteria", () async {
    Loteria loteria1 = Loteria(id: 1, descripcion: "Loteria1");
    Loteria loteria2 = Loteria(id: 2, descripcion: "Loteria2");
    print("Testing loteria1: ${loteria1.id}");
    print("Testing loteria2: ${loteria2.id}");
    loteria1.setLoteria(loteria2);
    print("Testing loteria1 despues: ${loteria1.id}");
    expect(loteria1.id == 1, false);
  });

  
  test("Testing bloqueos", () async {
      await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1212, 1, 1, '21', 10, 3, null, null, null, 0, 1, 1)], false);
      var data = await Db.obtenerMontoDeTablaBlocksplaysgenerals(idLoteria: 1, idSorteo: 1, jugada: '21', idMoneda: 1);
      print("Utils_test Testing bloqueos: ${data.length}");
    });
    

    test("Testing toInt", () async {
      var data = Utils.toInt("null");
      print("data: $data");
      expect(data == null, false);
    });

    test("Testing cantidad jugadas a combinar", () async {
      int cantidadJugadasCombinadasExistentes = 0;
        int cantidadJugadasCombinadasPermitidas = null;
        int cantidadJugadasACombinar = 39;

        if(true && cantidadJugadasCombinadasPermitidas != null){
          int cantidadRestanteJugadasACombinar = 0;
          // if(cantidadJugadasACombinar > cantidadJugadasCombinadasExistentes)
          //   cantidadRestanteJugadasACombinar =  cantidadJugadasACombinar - cantidadJugadasCombinadasExistentes;
          // else
          //   cantidadRestanteJugadasACombinar = cantidadJugadasCombinadasExistentes - cantidadJugadasACombinar;

          if(cantidadJugadasCombinadasExistentes >= cantidadJugadasCombinadasPermitidas)
            cantidadRestanteJugadasACombinar = 0;
          else
            cantidadRestanteJugadasACombinar = cantidadJugadasCombinadasPermitidas - cantidadJugadasCombinadasExistentes;

          if(cantidadJugadasACombinar > cantidadRestanteJugadasACombinar)
            cantidadJugadasACombinar = cantidadRestanteJugadasACombinar;
          // cantidadJugadasACombinar = cantidadRestanteJugadasACombinar < cantidadJugadasCombinadasPermitidas ? cantidadRestanteJugadasACombinar : 0;
      print("data: $cantidadJugadasACombinar");
        }

        expect(true, true);
    });


    group("Utils obtener primer, segundo y tercer par de numeros ", (){
      String jugada = "010203";
      test("1er", () async {
        var data = Utils.getPrimerParDeNumeros(jugada);
        print("data: $data");
        expect(data == "01", true);
      });

      test("2do", () async {
        var data = Utils.getSegundoParDeNumeros(jugada);
        print("data: $data");
        expect(data == "02", true);
      });

      test("3er", () async {
        var data = Utils.getTercerParDeNumeros(jugada);
        print("data: $data");
        expect(data == "03", true);
      });
    });

    test("Utils escanerQr", () async {
      var data = EscanerQr.flutter_qr_bar_scanner_google;
      print("Utils escanerQr: ${data.toString()}");
      expect(false, false);
    });

  });

  
}