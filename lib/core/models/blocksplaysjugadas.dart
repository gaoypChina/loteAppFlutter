
import 'package:loterias/core/models/jugadas.dart';

import 'blocksplays.dart';

class BlocksplaysJugada {
  List<Blocksplays> blocksplays;
  List<Jugada> jugadas;
  bool eliminar;

  BlocksplaysJugada({this.blocksplays, this.jugadas, this.eliminar = false});

}