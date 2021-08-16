
import 'package:loterias/core/models/jugadas.dart';
import 'blockslotteries.dart';

class BlockslotteriesJugada {
  List<Blockslotteries> blockslotteries;
  List<Jugada> jugadas;
  bool eliminar;

  BlockslotteriesJugada({this.blockslotteries, this.jugadas, this.eliminar = false});

}