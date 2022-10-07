import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/cross_platform_network_image/cross_platform_network_image.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/ticketimagev2.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/medioporelcualmostrarticketrecarga.dart';
import 'package:loterias/core/models/proveedor.dart';
import 'package:loterias/core/models/recarga.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/recargasservice.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:phone_form_field/phone_form_field.dart';

class RecargasDialogAddScreen extends StatefulWidget {
  const RecargasDialogAddScreen({Key key}) : super(key: key);

  @override
  State<RecargasDialogAddScreen> createState() => _RecargasDialogAddScreenState();
}

class _RecargasDialogAddScreenState extends State<RecargasDialogAddScreen> {
  Future<void> _future;
  var _txtMonto = TextEditingController();
  PhoneController _txtNumero;
  FocusNode _txtNumeroFocusNode;
  bool _mostrarLabelDelCampoNumero = true;
  var _formKey = GlobalKey<FormState>();
  List<Banca> listaBanca = [];
  List<Proveedor> listaProveedores = [];
  Proveedor _proveedor;
  Banca _banca;
  bool _cargando = false;
  bool _tienePermisoJugarComoCualquierBanca = false;
  int _idBancaAsignadaAEsteUsuario;
  ValueNotifier<bool> _valueNotifierMostrarCargandoWidget = ValueNotifier<bool>(false);
  List<MedioPorElCualMostrarTicketRecarga> listaMetodosParaMostrarTicketRecarga = MedioPorElCualMostrarTicketRecarga.getAll();
  MedioPorElCualMostrarTicketRecarga _medioPorElCualMostrarTicketRecarga;
 

  _init() async {
    _tienePermisoJugarComoCualquierBanca = await Db.existePermiso("Jugar como cualquier banca");

    _idBancaAsignadaAEsteUsuario = await Db.idBanca();

    var parsed = await RecargaService.crear(context: context);

    listaBanca = Banca.fromMapList(parsed["bancas"]);
    listaProveedores = Proveedor.fromMapList(parsed["proveedores"]);

  }

  _addOrRemoveLabel() {
    bool campoVacio = false;
    if (_txtNumero.value == null)
      campoVacio = true;
    else {
      if (_txtNumero.value.nsn == null || _txtNumero.value.nsn == '')
        campoVacio = true;
    }
    setState(() =>
    _mostrarLabelDelCampoNumero = !_txtNumeroFocusNode.hasFocus && campoVacio);
  }

  Future<void> _guardar() async {
    
    if(!_formKey.currentState.validate())
      return;

    String telefono = _txtNumero.value != null ? _txtNumero.value.nsn != null ? _txtNumero.value.nsn : '' : '';
    int montoRecarga = Utils.toInt(_txtMonto.text);

    if(telefono.isEmpty){
      Utils.showAlertDialog(context: context, title: "Error", content: "Campo numero de telefono esta vacío");
      return;
    }

    if(montoRecarga <= 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "Monto invalido");
      return;
    }

    if(_proveedor == null){
      Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar un proveedor");
      return;
    }

    if(_tienePermisoJugarComoCualquierBanca && _banca == null){
      Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar una banca");
      return;
    }

    if(_medioPorElCualMostrarTicketRecarga == null){
      Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar un medio por cual mostrara el ticket... Imprimir, WhatsApp, Compartir.");
      return;
    }

    if(_medioPorElCualMostrarTicketRecarga.medio == MedioPorElCualMostrarTicketRecarga.IMPRIMIR){
      if(await Utils.exiseImpresora() == false){
        Utils.showAlertDialog(context: context, title: "Impresora", content: "Debe registrar una impresora");
        return;
      }

      if(!kIsWeb){
        if(!(await BluetoothChannel.turnOn())){
          return;
        }
      }
    }


    try {
      // setState(() => _cargando = true);
      _valueNotifierMostrarCargandoWidget.value = true;

      Recarga _recarga = await RecargaService.guardar(context: context, recarga: Recarga(monto: montoRecarga.toDouble(), numero: telefono, idProveedor: _proveedor.id, idBanca: !_tienePermisoJugarComoCualquierBanca ? _idBancaAsignadaAEsteUsuario : _banca.id));
      // setState(() => _cargando = false);

      _valueNotifierMostrarCargandoWidget.value = false;

      String ticketGenerado = await Recarga.cambiarDatosDelTicketDeMidas(_recarga);

      if(_medioPorElCualMostrarTicketRecarga.medio == MedioPorElCualMostrarTicketRecarga.IMPRIMIR){

         BluetoothChannel.printText(content: ticketGenerado + "\n\n\n", normalOPrueba: true);

      }else{

        Uint8List ticketRecargaToImage = await TicketImageV2.imageFromWidget(Center(child: Text(ticketGenerado)));

        ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: ticketRecargaToImage, codigoQr: "", sms_o_whatsapp: _medioPorElCualMostrarTicketRecarga.medio == MedioPorElCualMostrarTicketRecarga.COMPARTIR);

      }

      print("RecargasAdialogddscreen.dart _guardar: true");
    } on dynamic catch (e) {
      // setState(() => _cargando = false);
      _valueNotifierMostrarCargandoWidget.value = false;
    }


  }

_medioPorElCualMostrarTicketRecargaChanged(MedioPorElCualMostrarTicketRecarga medioPorElCualMostrarTicketRecarga){
  setState(() => _medioPorElCualMostrarTicketRecarga = medioPorElCualMostrarTicketRecarga);
}

Widget  _roundedCotainer(MedioPorElCualMostrarTicketRecarga medioPorElCualMostrarTicketRecarga){
    return GestureDetector(
      onTap: () => _medioPorElCualMostrarTicketRecargaChanged(medioPorElCualMostrarTicketRecarga),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _medioPorElCualMostrarTicketRecarga == medioPorElCualMostrarTicketRecarga ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
          border: _medioPorElCualMostrarTicketRecarga == medioPorElCualMostrarTicketRecarga ? null : Border.all(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Text(medioPorElCualMostrarTicketRecarga.medio, style: TextStyle(color: _medioPorElCualMostrarTicketRecarga == medioPorElCualMostrarTicketRecarga ? Colors.blue[700] : null, fontWeight: FontWeight.bold),),
      ),
    );
  }

Widget  _medioPorElCualMostrarTicketRecargaWidget(){
    return Wrap(
      children: listaMetodosParaMostrarTicketRecarga.map<Widget>((e) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: _roundedCotainer(e),
      )).toList(),
    );
  }

  Widget _logoDelProveedor(Proveedor proveedor){
   Widget container = Container(
      width: 40, 
      height: 40,  
      decoration: BoxDecoration(
        borderRadius: !kIsWeb ? BorderRadius.circular(7.0) : null
      ),
      child: CrossNetWorkImage().getWidget("${proveedor.enlaceDelLogo}")
    );

    if(!kIsWeb)
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: container,
    );

    return container;
  }
  

  Widget _screen(bool isSmallOrMedium){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _medioPorElCualMostrarTicketRecargaWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PhoneFormField(
              key: Key('phone-field'),
              controller: _txtNumero,     // controller & initialValue value
              initialValue: null,   // can't be supplied simultaneously
              shouldFormat: true,    // default
              defaultCountry: 'DO',
              focusNode: _txtNumeroFocusNode,// default
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  // labelText: _mostrarLabelDelCampoNumero ? 'Telefono' : null,          // default to null
                  labelText: 'Numero de telefono',          // default to null
                  // border: InputBorder.none, // default to UnderlineInputBorder(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  // hintText: "Telefono",
                  // helperText: "Numero de telefono a recargar",
                // ...
              ),
              validator: PhoneValidator.validMobile(allowEmpty: false),   // default PhoneValidator.valid()
              selectorNavigator: null, // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
              // selectorNavigator: const PopupNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
              showFlagInInput: true,  // default
              flagSize: 16,           // default
              // autofillHints: [AutofillHints.telephoneNumber], // default to null
              enabled: true,          // default
              autofocus: true,       // default
              autovalidateMode: AutovalidateMode.onUserInteraction, // default
              onSaved: (PhoneNumber p) => print('saved $p'),   // default null
              onChanged: (PhoneNumber p) => print('saved $p'), // default null
              // ... + other textfield params
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MyTextFormField(
              medium: 1,
              controller: _txtMonto,
              title: "Monto recarga",
              isRequired: true,
              isMoneyFormat: true,
              type: MyType.floatingLabelWithBorder,
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            ),
          ),
          Visibility(
            visible: _tienePermisoJugarComoCualquierBanca,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyDropdownButton(
                medium: 1,
                hint: "Selec. banca",
                value: _banca,
                items: listaBanca.map((e) => [e, e.descripcion]).toList(),
                onChanged: (value) => setState(() => _banca = value)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              hint: Text("Selec. proveedor"),
              value: _proveedor,
              isExpanded: true,
              validator: (proveedor) => proveedor == null ? 'Campo requerido' : null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                border: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black))
              ),
              items: listaProveedores.map((e) => DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    _logoDelProveedor(e),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("${e.nombre}"),
                    )
                  ],
              ))).toList(), 
              onChanged: (value) => setState(() => _proveedor = value)
            ),
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtNumeroFocusNode = FocusNode();
    _txtNumeroFocusNode.addListener(_addOrRemoveLabel);
    _txtNumero = PhoneController(null);
    _medioPorElCualMostrarTicketRecarga = listaMetodosParaMostrarTicketRecarga[0];
    _future = _init();
  }
  
  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Recargar",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true, cargandoNotifier: _valueNotifierMostrarCargandoWidget,)
          ],
        ), 
        sliver: SliverFillRemaining(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done)
                return Center(child: CircularProgressIndicator());

              return ValueListenableBuilder<bool>(
                valueListenable: _valueNotifierMostrarCargandoWidget,
                builder: (context, value, __) {
                  return AbsorbPointer(absorbing: value, child: _screen(isSmallOrMedium));
                }
              );
            },
        )
        )
      )
    );
    return StatefulBuilder(
      builder: (context, statefulBuilderSetState) {
        return MyAlertDialog(
          title: "Recargar",
          cargando: _cargando,
          content: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done)
                return Center(child: CircularProgressIndicator());

              return _screen(isSmallOrMedium);
            }
          ),
          // okDescription: "Recargar",
          // okFunction: () => _guardar(),
          actions: [
            Visibility(
              visible: _cargando,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
              ),
            ),
            GestureDetector(
              onTap:(){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: _ckbPrintScreen(),
                
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.print, size: 22, color: Colors.orange[900])
                ),
              ),
            ),
              GestureDetector(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: _ckbPrintScreen(),
                
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.share, size: 22, color: Colors.blue[900])
                ),
              ),
            ),
            GestureDetector(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: _ckbPrintScreen(),
                
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: FaIcon(FontAwesomeIcons.whatsapp, size: 22, color: Colors.green[900],)
                ),
              ),
            ),
            
          ],
        );
      }
    );
  }
}