import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/ajustesservice.dart';
import 'package:loterias/core/services/bancaservice.dart';


void main() {
  group("Bancas test", (){
    test("Testing index", () async {
      var parsed = await BancaService.index(context: null);
      print("data: $parsed");
      expect(parsed == null, false);
    });

    test("Testing guardar", () async {
      var t = Tipo(24, "FOrmato2", "nada", 1, DateTime.now());
      var a = Ajuste(consorcio: "Consorcio estefania", imprimirNombreConsorcio: 0, tipoFormatoTicket: t, );
      
      var parsed = await AjustesService.guardar(context: null, ajuste: a);
      print("data: $parsed");
      expect(parsed == null, false);
    });
  });
}