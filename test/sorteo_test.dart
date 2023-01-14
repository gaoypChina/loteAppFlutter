import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';


void main() {
  group("Sorteo test", (){
    
    test("Testing esIdPaleTripletaOSuperpale == false", () async {
      var data = Draws.esIdPaleTripletaOSuperpale(1);
      print("Utils_test Testing toBigInt: $data");
      expect(data, false);
    });

    test("Testing esIdPaleTripletaOSuperpale == true", () async {
      var pale = Draws.esIdPaleTripletaOSuperpale(2);
      var tripleta = Draws.esIdPaleTripletaOSuperpale(3);
      var superPale = Draws.esIdPaleTripletaOSuperpale(4);
      // print("Utils_test Testing toBigInt: $data");
      expect(pale && tripleta && superPale, true);
    });

  });

  
}