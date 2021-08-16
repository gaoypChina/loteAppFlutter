
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/jugadas.dart';

class BlocksgeneralsJugada {
  List<Blocksgenerals> blocksgenerals;
  List<Jugada> jugadas;
  bool eliminar;

  BlocksgeneralsJugada({this.blocksgenerals, this.jugadas, this.eliminar = false});

}