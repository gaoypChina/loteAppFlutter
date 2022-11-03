import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/services/usuarioservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';

class VerContrasenasDialog extends StatefulWidget {
  final List<int> idUsuarios;
  final int idGrupo;
  const VerContrasenasDialog({Key key, @required this.idUsuarios, this.idGrupo}) : super(key: key);

  @override
  State<VerContrasenasDialog> createState() => _VerContrasenasDialogState();
}

class _VerContrasenasDialogState extends State<VerContrasenasDialog> {
  String _usuariosYContrasenas = "";
  Future<String> _future;

  Future<String> _obtenerContrasenas() async {
    _usuariosYContrasenas = await UsuarioService.obtenerContrasenas(context: context, idUsuarios: widget.idUsuarios);
    return _usuariosYContrasenas;
  }

  _volverACargar(){
    _future = _obtenerContrasenas();
  }

  _copiarPortapapeles() async {
    await Clipboard.setData(ClipboardData(text: _usuariosYContrasenas != null ? _usuariosYContrasenas : ''));
    Utils.showFlushbar(context, "Copiado correctamente...");
  }

  _volverAtras(){
    Navigator.pop(context);
  }


  @override
  void initState() {
    // TODO: implement initState
    _future = _obtenerContrasenas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Contraseñas"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: FutureBuilder<String>(
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.hasError)
            return MyEmpty(title: "${snapshot.error}", titleButton: "Volver a cargar", icon: Icons.error, onTap: () => _volverACargar(),);

          if(snapshot.connectionState != ConnectionState.done)
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator()]);

          return SingleChildScrollView(child: SelectableText(snapshot.data));
        }
      ),
      actions: [
        TextButton(
          onPressed: (){
          _copiarPortapapeles();
          _volverAtras();
        }, child: Text("Copiar"))
      ],
    );
  }
}