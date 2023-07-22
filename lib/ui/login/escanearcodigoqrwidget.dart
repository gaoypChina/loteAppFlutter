import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

class EscanearCodigoQrWidget extends StatefulWidget {
  EscanearCodigoQrWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _EscanearCodigoQrWidgetState createState() => _EscanearCodigoQrWidgetState();
}

class _EscanearCodigoQrWidgetState extends State<EscanearCodigoQrWidget> {
  String _qrInfo = 'Scan a QR/Bar code';
  bool _mostrarEscaner = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _mostrarEscaner
          ? 
          _escanerWidget()
          : 
          _vacioWidget()
    );
  }

  Widget _escanerWidget(){
    return Center(
      child: SizedBox(
        // height: 1000,
        // width: 500,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: QRBarScannerCamera(
          onError: (context, error) => Text(
            error.toString(),
            style: TextStyle(color: Colors.red),
          ),
          qrCodeCallback: (code) {
            _retornarQr(code);
          },
        ),
      ),
    );
  }

  _retornarQr(String code) {
    setState(() {
      _mostrarEscaner = false;
      _qrInfo = code;
      Future.delayed(Duration(milliseconds: 50), () => Navigator.pop(context, code));
    });
  }

  _vacioWidget(){
    //Antes de enviar el codigoQr hacia atras primero se debe quitar el _escanerWidget y poner el _vacioWidget para que no se dispare un 
    //error de navegacion que ocurre cuando el escaner(camara) esta activo
    return SizedBox.shrink();
  }
}