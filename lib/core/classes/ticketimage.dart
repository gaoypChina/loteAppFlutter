import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';


class TicketImage {
  static double _screenWidth = 1000;

  static Future<Uint8List> create(Sale sale, List<Salesdetails> listSalesdetails, [bool original = true]) async {
    final pdf = pw.Document();
    var theme = await _initFont();
    var header = await _ticketHead(sale, original);
    // QrImage a = QrImage(
    //   data: "1234567890",
    //   version: QrVersions.auto,
    //   size: 200.0,
    // );
    
    pdf.addPage(pw.Page(
      theme: theme,
      pageFormat: PdfPageFormat.undefined,
      build: (pw.Context context) {
        return pw.Container(
          width: _screenWidth,
          padding: pw.EdgeInsets.only(left: 20, right: 20, top: 10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 3, color: PdfColor.fromHex("#1170ec")),
            color: PdfColor.fromHex("#ffffff")
          ),
          child:  pw.Column(
            children: [
              header,
              _ticketContent(sale, listSalesdetails),
              _ticketFooter(sale, listSalesdetails),
              // _receiptNumberAndDate(),
              // _receiptContent()
            ]
          )
        );
    })); 

    Uint8List file = await savePdf(pdf);
    return pdfFileToImage(file);
  }

  static Future<pw.ThemeData> _initFont() async {
    final font = await rootBundle.load("assets/fonts/ProductSans-Regular.ttf");
    final fontBold = await rootBundle.load("assets/fonts/ProductSans-Bold.ttf");
    final fontItalic = await rootBundle.load("assets/fonts/ProductSans-Italic.ttf");
    final fontBoldItalic =await rootBundle.load("assets/fonts/ProductSans-BoldItalic.ttf");

    final ttf = pw.Font.ttf(font);
    final ttfBold = pw.Font.ttf(fontBold);
    final ttfItalic = pw.Font.ttf(fontItalic);
    final ttfBoldItalic = pw.Font.ttf(fontBoldItalic);

    final pw.ThemeData theme = pw.ThemeData.withFont(
      base: ttf,
      bold: ttfBold,
      italic: ttfItalic,
      boldItalic: ttfBoldItalic,
    );
    return theme;
  }

  static _ticketHead(Sale sale, original) async {
    var ajusteMap = await Db.ajustes();
    Ajuste ajuste = ajusteMap != null ? Ajuste.fromMap(ajusteMap) : null;
    var nombreConsorcio = ajuste != null ? ajuste.imprimirNombreConsorcio == 1 ? pw.Text("${ajuste.consorcio}") : pw.SizedBox() : pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        nombreConsorcio,
        pw.Text("${sale.banca.descripcion}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
        pw.Text("** ${original ? 'ORIGINAL' : 'COPIA'} **", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
        pw.Text("TICKET: ${Utils.toSecuencia('', sale.idTicket, false)}", style: pw.TextStyle(fontSize: 30)),
        pw.Text("FECHA: ${DateFormat('EEE, MMM d yyy jms').format(sale.created_at)}", style: pw.TextStyle(fontSize: 30)),
        pw.SizedBox(height: 20),
        pw.Text("${sale.ticket.codigoBarra}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
        pw.SizedBox(height: 20),
      ]
    );
  }

  static _ticketContent(Sale sale, List<Salesdetails> listSalesdetails){
    List<pw.Widget> widgets = [];
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

    
    return pw.Column(
      children: widgets
    );
  }

  static _ticketJugadasContent(List<pw.Widget> widgets, List<Salesdetails> salesdetails, Loteria loteria, [bool lasJugadasSonDeTipoSuperPale = false]){
    for (var i = 0; i < salesdetails.length; i+=2) {
        if(i > salesdetails.length)
          break;

        Salesdetails detail = salesdetails[i];
        Salesdetails detail2 = i + 1 < salesdetails.length ? salesdetails[i + 1] : null;
        // AGREGAMOS LA LOTERIA
        if(i == 0){
          widgets.add(pw.Divider());
          if(lasJugadasSonDeTipoSuperPale == false)
            widgets.add(pw.Text("${loteria.descripcion}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)));
          else{
            print("TicketImage _ticketJugadasContent: ${salesdetails[i].toJson()}");
            widgets.add(pw.Text("Super pale(${loteria.descripcion} / ${salesdetails[i].loteriaSuperPale.descripcion})", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)));
          }

          widgets.add(pw.Divider());
          widgets.add(pw.SizedBox(height: 10));

          widgets.add(pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Row(
                children: [
                  // pw.Padding(
                  //   padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  //   child: pw.Text("Jugada", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // ),
                  // pw.Padding(
                  //   padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  //   child: pw.Text("Monto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // ),
                 pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                    width: 170,
                    child: pw.Text("Jugada", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
                  ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                      width: 150,
                      child: pw.Text("Monto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
                    ),
                  ),
                ]
              ),
              pw.Row(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                    width: 170,
                    child: pw.Text("Jugada", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
                  ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                      width: 150,
                      child: pw.Text("Monto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)),
                    ),
                  ),
                  // pw.Text("Jugada", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text("Monto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]
              )
            ]
          ));
        }

        var jugadaRow = pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Row(
                children: [
                  // pw.Padding(
                  //   padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  //   child: pw.Text("${detail.jugada}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // ),
                  // pw.Padding(
                  //   padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  //   child: pw.Text("${detail.monto}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                      width: 170,
                      child: pw.Text("${Utils.jugadaFormatToJugada(detail.jugada)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 45)),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                      width: 150,
                      child: pw.Text("${detail.monto}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 45)),
                    ),
                  )
                ]
              ),
            ]
          );

          jugadaRow.children.add(pw.Row(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Container(
                    width: 170,
                    child: pw.Text("${detail2 != null ? Utils.jugadaFormatToJugada(detail2.jugada) : ''}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 45)),
                  ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Container(
                  width: 150,
                  child: pw.Text("${detail2 != null ? detail2.monto : ''}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 45)),
                ),
              )
            ]
          ));

        // print("TicketImage _ticketContent detail2 null: ${detail2 == null} i: $i jugadaLength: ${salesdetails.length}");

        widgets.add(jugadaRow);

      }
  }

  static pw.Widget _ticketFooter(Sale sale, List<Salesdetails> listSalesdetails){
    var total = listSalesdetails.map((e) => e.monto).reduce((value, element) => value + element);
    var subTotalWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? pw.Text("Subtotal: ${Utils.toCurrency(sale.total)}", style: pw.TextStyle(fontSize: 30)) : pw.SizedBox();
    var descuentoMontoWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? pw.Text("Descuento: ${Utils.toCurrency(sale.descuentoMonto)}", style: pw.TextStyle(fontSize: 30)) : pw.SizedBox();
    var totalWidget = sale.hayDescuento == 1 && sale.descuentoMonto > 0 ? pw.Text("Total: ${Utils.toCurrency(sale.total - sale.descuentoMonto)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50)) : pw.Text("Total: ${Utils.toCurrency(sale.total)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 50));
    
    var piepagina1Widget = sale.banca.piepagina1 != null ? sale.banca.piepagina1.isNotEmpty ? pw.Text("Descuento: ${sale.banca.piepagina1}", style: pw.TextStyle(fontSize: 25)) : pw.SizedBox() : pw.SizedBox();
    var piepagina2Widget = sale.banca.piepagina2 != null ? sale.banca.piepagina2.isNotEmpty ? pw.Text("Descuento: ${sale.banca.piepagina2}", style: pw.TextStyle(fontSize: 25)) : pw.SizedBox() : pw.SizedBox();
    var piepagina3Widget = sale.banca.piepagina3 != null ? sale.banca.piepagina3.isNotEmpty ? pw.Text("Descuento: ${sale.banca.piepagina3}", style: pw.TextStyle(fontSize: 25)) : pw.SizedBox() : pw.SizedBox();
    var piepagina4Widget = sale.banca.piepagina4 != null ? sale.banca.piepagina4.isNotEmpty ? pw.Text("Descuento: ${sale.banca.piepagina4}", style: pw.TextStyle(fontSize: 25)) : pw.SizedBox() : pw.SizedBox();
    
    return  pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 260),
      child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
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