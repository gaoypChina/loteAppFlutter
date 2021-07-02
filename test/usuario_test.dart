import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/ajustesservice.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/usuarioservice.dart';


void main() {
  group("Usuario test", (){
    test("Testing Usuariosearch", () async {
      var parsed = await UsuarioService.searchTest(context: null, search: "01");
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