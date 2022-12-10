import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/classes/utils.dart';
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
    


  });

  
}