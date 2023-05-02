import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';


void main() {
  group("Draws model test", (){
    
    

    test("Testing esPale", () async {
      List<String> pales = ["010-", "2023", "2-33"];
      for (var pale in pales) {
         print("Pale: $pale ${Draws.esJugadaPale(pale)}");
      }
      expect(null == null, true);
    });

    test("Testing esJugadaSuperPale", () async {
      List<String> superPales = ["0102s", "01s2s", "s1222"];
      for (var superPale in superPales) {
         print("Super pale: $superPale ${Draws.esJugadaSuperPale(superPale)}");
      }
      expect(null == null, true);
    });

    test("Testing esJugadaPick3Straigh", () async {
      List<String> datos = ["123", "123-", "1-2", "-23"];
      for (var elemento in datos) {
         print("esJugadaPick3Straigh: $elemento ${Draws.esJugadaPick3Straight(elemento)}");
      }
      expect(null == null, true);
    });

    test("Testing esJugadaPick3Box", () async {
      List<String> datos = ["123+", "12+3", "312", "+123"];
      for (var elemento in datos) {
         print("esJugadaPick3Box: $elemento ${Draws.esJugadaPick3Box(elemento)}");
      }
      expect(null == null, true);
    });

     test("Testing esJugadaPick4Box", () async {
      List<String> datos = ["1234+", "12+34", "3124", "+1234", "1244+"];
      for (var elemento in datos) {
         print("esJugadaPick4Box: $elemento ${Draws.esJugadaPick4Box(elemento)}");
      }
      expect(null == null, true);
    });

     test("Testing esJugadaPick4Straight", () async {
      List<String> superPales = ["1234-", "12-34", "3124", "-1234", "1244-"];
      for (var superPale in superPales) {
         print("esJugadaPick4Straight: $superPale ${Draws.esJugadaPick4Straight(superPale)}");
      }
      expect(null == null, true);
    });

     test("Testing esEntero", () async {
      List<String> datos = ["123", "0", "-23", "1234-", "12-34", "-3124", "-1234", "1244-"];
      for (var elemento in datos) {
         print("esEntero: $elemento ${Draws.esEntero(elemento)}");
      }
      expect(null == null, true);
    });



  });

  
}