import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/utils.dart';


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
  });
}