import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/ajustesservice.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/horariosservice.dart';


void main() {
  group("Horarios", (){
    test("Testing index", () async {
      var parsed = await HorariosService.indexTest(context: null);
      print("parsed: $parsed");
      // var _data = parsed["data"] != null ? Banca.fromMap(parsed["data"]) : null;
      // _data.loterias.forEach((element) {
      //   print("Loteria: ${element.descripcion}");
      //   element.sorteos.forEach((e) {
      //     print("sorteo: ${e.descripcion}");
      //   });
      // });
      expect(parsed == null, false);
    });

    test("Testing guardar", () async {
      var t = Tipo(24, "FOrmato2", "nada", 1, DateTime.now());
      var a = Ajuste(consorcio: "Consorcio estefania", imprimirNombreConsorcio: 0, tipoFormatoTicket: t, );
      
      var parsed = await AjustesService.guardar(context: null, ajuste: a);
      print("data: $parsed");
      expect(parsed == null, false);
    });

    test("Testing Bancasearch", () async {
      var parsed = await BancaService.searchTest(context: null, search: "01");
      print("parsed: $parsed");
      // var _data = parsed["data"] != null ? Banca.fromMap(parsed["data"]) : null;
      // _data.loterias.forEach((element) {
      //   print("Loteria: ${element.descripcion}");
      //   element.sorteos.forEach((e) {
      //     print("sorteo: ${e.descripcion}");
      //   });
      // });
      expect(parsed == null, false);
    });
  });
}