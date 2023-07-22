import 'package:loterias/core/classes/singleton.dart';

class EscanerQr {
  const EscanerQr._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const EscanerQr flutter_barcode_scanner = EscanerQr._(0);

  /// Extra-light
  static const EscanerQr flutter_qr_bar_scanner_google = EscanerQr._(1);


  /// A list of all the font weights.
  static const List<EscanerQr> values = <EscanerQr>[
    flutter_barcode_scanner, flutter_qr_bar_scanner_google
  ];

  static const List<String> _stringValues = <String>[
    "flutter_barcode_scanner", "flutter_qr_bar_scanner_google"
  ];

  @override
  String toString() {
    // TODO: implement toString
    return _stringValues[index];
  }
}

class EscanerQrService {
  static String flutter_barcode_scanner = "flutter_barcode_scanner";
  static String flutter_qr_bar_scanner_google = "flutter_qr_bar_scanner_google";

  static Future<void> guardar(EscanerQr escaner) async{
    var c = await DB.create();
    await c.add("escanerQr", escaner.toString());
  }

  static esEscanerGoogle() async {
    var c = await DB.create();

    var escaner = await c.getValue("escanerQr");

    if(escaner == null)
      return true;

    return EscanerQr.flutter_qr_bar_scanner_google.toString() == escaner;
  }
}