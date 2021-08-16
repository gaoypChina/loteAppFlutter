import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/classes/widgettoimage.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:printing/printing.dart';


class TicketImageV2 {
  static double _screenWidth = 1350;
  static double _calculatedHeight = 1000;

  static Future<Uint8List> create(Sale sale, List<Salesdetails> listSalesdetails, [bool original = true]) async {
    _calculatedHeight = 1000;
    var header = await _ticketHead(sale, original);
    
    var widget = Container(
          
          width: _screenWidth,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Utils.fromHex("#1170ec")),
            color: Colors.white
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 260),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.black),
              child: Column(
                children: [
                  header,
                  _ticketContent(sale, listSalesdetails),
                  _ticketFooter(sale, listSalesdetails),
                  // _receiptNumberAndDate(),
                  // _receiptContent()
                ]
              ),
            )
          )
        );
   
    // var image = await createImageFromWidget(widget);
    var image = await createImageFromWidget(widget, imageSize: Size(_screenWidth, _calculatedHeight), logicalSize: Size(_screenWidth, _calculatedHeight));
    print("TicketImageV2 image: $image");
    // Uint8List file = await savePdf(pdf);
    // return pdfFileToImage(file);
    return image;
  }

  // static Future<ThemeData> _initFont() async {
  //   final font = await rootBundle.load("assets/fonts/ProductSans-Regular.ttf");
  //   final fontBold = await rootBundle.load("assets/fonts/ProductSans-Bold.ttf");
  //   final fontItalic = await rootBundle.load("assets/fonts/ProductSans-Italic.ttf");
  //   final fontBoldItalic =await rootBundle.load("assets/fonts/ProductSans-BoldItalic.ttf");

  //   final ttf = Font.ttf(font);
  //   final ttfBold = Font.ttf(fontBold);
  //   final ttfItalic = Font.ttf(fontItalic);
  //   final ttfBoldItalic = Font.ttf(fontBoldItalic);

  //   final ThemeData theme = ThemeData.withFont(
  //     base: ttf,
  //     bold: ttfBold,
  //     italic: ttfItalic,
  //     boldItalic: ttfBoldItalic,
  //   );
  //   return theme;
  // }

  static _ticketHead(Sale sale, original) async {
    var ajusteMap = await Db.ajustes();
    Ajuste ajuste = ajusteMap != null ? Ajuste.fromMap(ajusteMap) : null;
    var nombreConsorcio = ajuste != null ? ajuste.imprimirNombreConsorcio == 1 ? Text("${ajuste.consorcio}") : SizedBox() : SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        nombreConsorcio,
        Text("${sale.banca.descripcion}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
        Text("** ${original ? 'ORIGINAL' : 'COPIA'} **", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
        Text("TICKET: ${Utils.toSecuencia('', sale.idTicket, false)}", style: TextStyle(fontSize: 60)),
        // Text("FECHA: ${DateFormat('EEE, MMM d yyy hh:mm a', 'es').format(sale.created_at)}", style: TextStyle(fontSize: 60)),
        Text("FECHA: ${DateFormat('EEE', 'Es').format(sale.created_at).toUpperCase()} ${DateFormat('d/MM/yyyy').add_jm().format(sale.created_at)}", style: TextStyle(fontSize: 60)),
        SizedBox(height: 20),
        Text("${sale.ticket.codigoBarra}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
        SizedBox(height: 20),
      ]
    );
  }

  static _ticketContent(Sale sale, List<Salesdetails> listSalesdetails){
    List<Widget> widgets = [];
    List<Salesdetails> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(listSalesdetails)).cast<Salesdetails>().toList();
    for (var salesdetailsLoteria in listaLoteriasJugadas) {
      Loteria loteria = salesdetailsLoteria.loteria;
      List<Salesdetails> salesdetails = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idLoteriaSuperpale == 0 || element.idLoteriaSuperpale == null)).toList();
      _ticketJugadasContent(widgets, salesdetails, loteria);

      // Buscamos todas las jugadas de tipo SuperPale que tenga esta loteria usada arriba y nos aseguramos de que los idLoteriaSuperPale sean de diferentes loterias
      // y no sea nulos
      salesdetails = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idSorteo == 4)).toList();
      List<Salesdetails> listaLoteriasSuperPaleJugadas = Utils.removeDuplicateLoteriasSuperPaleFromList(List.from(salesdetails)).cast<Salesdetails>().toList();
      // if(listaLoteriasSuperPaleJugadas.length == 0)
      //   continue;

    for (var salesdetailLoteriaSuperPale in listaLoteriasSuperPaleJugadas) {
        // List<Salesdetails> salesdetailsSuperPale = salesdetails.where((element) => element.idLoteriaSuperpale != 0 && element.idLoteriaSuperpale != null).toList();
        List<Salesdetails> salesdetailsSuperPale = salesdetails.where((element) => element.idLoteriaSuperpale == salesdetailLoteriaSuperPale.idLoteriaSuperpale).toList();
        _ticketJugadasContent(widgets, salesdetailsSuperPale, loteria, true);
      }
    }

    
    return Column(
      children: widgets
    );
  }

  static _ticketJugadasContent(List<Widget> widgets, List<Salesdetails> salesdetails, Loteria loteria, [bool lasJugadasSonDeTipoSuperPale = false]){
    for (var i = 0; i < salesdetails.length; i+=2) {
        if(i > salesdetails.length)
          break;

        Salesdetails detail = salesdetails[i];
        Salesdetails detail2 = i + 1 < salesdetails.length ? salesdetails[i + 1] : null;
        // AGREGAMOS LA LOTERIA
        if(i == 0){
          _calculatedHeight += 190;
          widgets.add(Divider());
          if(lasJugadasSonDeTipoSuperPale == false)
            widgets.add(Text("${loteria.descripcion}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)));
          else{
            print("TicketImage _ticketJugadasContent: ${salesdetails[i].toJson()}");
            widgets.add(Text("Super pale(${loteria.descripcion} / ${salesdetails[i].loteriaSuperPale.descripcion})", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)));
          }

          widgets.add(Divider());
          widgets.add(SizedBox(height: 10));

          widgets.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text("Jugada", style: TextStyle(fontWeight: FontWeight.bold)),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text("Monto", style: TextStyle(fontWeight: FontWeight.bold)),
                  // ),
                 Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                    width: 285,
                    child: Text("Jugada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 220,
                      child: Text("Monto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
                    ),
                  ),
                ]
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                    width: 285,
                    child: Text("Jugada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 220,
                      child: Text("Monto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)),
                    ),
                  ),
                  // Text("Jugada", style: TextStyle(fontWeight: FontWeight.bold)),
                  // Text("Monto", style: TextStyle(fontWeight: FontWeight.bold)),
                ]
              )
            ]
          ));
        }

        var jugadaRow = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text("${detail.jugada}", style: TextStyle(fontWeight: FontWeight.bold)),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text("${detail.monto}", style: TextStyle(fontWeight: FontWeight.bold)),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 285,
                      child: Text("${Utils.jugadaFormatToJugada(detail.jugada)}", style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 220,
                      child: Text("${Utils.toPrintCurrency(detail.monto)}", style: TextStyle(fontSize: 60)),
                    ),
                  )
                ]
              ),
            ]
          );

          jugadaRow.children.add(Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    width: 285,
                    child: Text("${detail2 != null ? Utils.jugadaFormatToJugada(detail2.jugada) : ''}", style: TextStyle(fontSize: 60)),
                  ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 220,
                  child: Text("${detail2 != null ? Utils.toPrintCurrency(detail2.monto) : ''}", style: TextStyle(fontSize: 60)),
                ),
              )
            ]
          ));

        // print("TicketImage _ticketContent detail2 null: ${detail2 == null} i: $i jugadaLength: ${salesdetails.length}");
        _calculatedHeight += 70;
        widgets.add(jugadaRow);

      }
  }

  static Widget _ticketFooter(Sale sale, List<Salesdetails> listSalesdetails){
    var total = listSalesdetails.map((e) => e.monto).reduce((value, element) => value + element);
    var subTotalWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? Text("Subtotal: ${Utils.toCurrency(sale.total)}", style: TextStyle(fontSize: 30)) : SizedBox();
    var descuentoMontoWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? Text("Descuento: ${Utils.toCurrency(sale.descuentoMonto)}", style: TextStyle(fontSize: 30)) : SizedBox();
    var totalWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? Text("Total: ${Utils.toCurrency(sale.total - sale.descuentoMonto)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70)) : Text("Total: ${Utils.toCurrency(sale.total)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70));
    
    var piepagina1Widget = sale.banca.piepagina1 != null ? sale.banca.piepagina1.isNotEmpty ? Text("${sale.banca.piepagina1}", style: TextStyle(fontSize: 25)) : SizedBox() : SizedBox();
    var piepagina2Widget = sale.banca.piepagina2 != null ? sale.banca.piepagina2.isNotEmpty ? Text("${sale.banca.piepagina2}", style: TextStyle(fontSize: 25)) : SizedBox() : SizedBox();
    var piepagina3Widget = sale.banca.piepagina3 != null ? sale.banca.piepagina3.isNotEmpty ? Text("${sale.banca.piepagina3}", style: TextStyle(fontSize: 25)) : SizedBox() : SizedBox();
    var piepagina4Widget = sale.banca.piepagina4 != null ? sale.banca.piepagina4.isNotEmpty ? Text("${sale.banca.piepagina4}", style: TextStyle(fontSize: 25)) : SizedBox() : SizedBox();
    
    if(!(piepagina1Widget is SizedBox))
      _calculatedHeight += 50;
    if(!(piepagina2Widget is SizedBox))
      _calculatedHeight += 50;
    if(!(piepagina3Widget is SizedBox))
      _calculatedHeight += 50;
    if(!(piepagina4Widget is SizedBox))
      _calculatedHeight += 50;
    
    if(sale.descuentoMonto > 0)
      _calculatedHeight += 50;

    return  Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        subTotalWidget,
        descuentoMontoWidget,
        totalWidget,
        piepagina1Widget,
        piepagina2Widget,
        piepagina3Widget,
        piepagina4Widget,
      ]
    )
    );
  }

  static Future<Uint8List> savePdf(pdf) async {
    return pdf.save();
  }

  static Future<Uint8List> pdfFileToImage(Uint8List pdfFile) async {
    var _image;
    await for (final page in Printing.raster(pdfFile)) {
      // final image = page.toImage(); // ...or page.toPng()
      // final image = page.toPng(); // ...or page.toPng()
      // var byteData = await (await image).toByteData(format: ImageByteFormat.png);
      // _image = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

      _image = page.toPng();
      break;
    }
    return _image;
  }
}