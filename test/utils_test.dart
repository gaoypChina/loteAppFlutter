import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/utils.dart';


void main() {
  group("Utils test", (){
    test("Testing toInt", () async {
      var data = Utils.toInt("null");
      print("data: $data");
      expect(data == null, false);
    });
  });
}