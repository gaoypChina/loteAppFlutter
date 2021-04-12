import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/services/reporteservice.dart';


void main() {
  group("Customer test", (){
    test("filling customer", () async {
      var parsed = await ReporteService.jugadas(context: null, fechaInicial: DateTime.parse("2021-04-01 00:00"), fechaFinal: DateTime.parse("2021-04-10 23:00"));

      expect(parsed == null, false);
    });
  });
}