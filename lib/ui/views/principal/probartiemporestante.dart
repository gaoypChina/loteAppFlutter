import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:timezone/timezone.dart' as tz;


class ProbarTiempoRestante extends StatefulWidget {
  @override
  _ProbarTiempoRestanteState createState() => _ProbarTiempoRestanteState();
}

class _ProbarTiempoRestanteState extends State<ProbarTiempoRestante> {
  int estimateTs = DateTime(2021, 1, 17, 15, 30, 30).millisecondsSinceEpoch; // set needed date
  
   _horaCierreLoteriaToCurrentTimeZone(Loteria loteria) async {
    var santoDomingo = tz.getLocation('America/Santo_Domingo');
    var fechaActualRd = tz.TZDateTime.now(santoDomingo);
    var fechaLoteriaRD = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${loteria.horaCierre != null ? loteria.horaCierre : '00:00'}");
    
    int horasASumar = (fechaLoteriaRD.hour - fechaActualRd.hour);
    int minutosASumar = (fechaLoteriaRD.minute - fechaActualRd.minute);
    int segundosARestar = fechaActualRd.second;
    
    var fechaLoteriaConvertidaAFormatoRD;
    fechaLoteriaConvertidaAFormatoRD = fechaActualRd.add(Duration(hours: horasASumar, minutes: minutosASumar));
    fechaLoteriaConvertidaAFormatoRD = fechaLoteriaConvertidaAFormatoRD.subtract(Duration(seconds: segundosARestar));

    var currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    var currentTimeZoneLocation = tz.getLocation(currentTimeZone);
    var fechaLoteriaCurrentTimeZone = tz.TZDateTime.from(fechaLoteriaConvertidaAFormatoRD, currentTimeZoneLocation);

    return fechaLoteriaCurrentTimeZone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("CUlo"),
            ),
            FlatButton(
              child: Text("Default timezone"),
              onPressed: (){
                _horaCierreLoteriaToCurrentTimeZone(Loteria(descripcion: "La Primera", horaCierre: "11:50"));
                _horaCierreLoteriaToCurrentTimeZone(Loteria(descripcion: "Real", horaCierre: "12:50"));
              },
            ),
            StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        DateFormat format = DateFormat("mm:ss");
                        int now = DateTime
                            .now()
                            .millisecondsSinceEpoch;
                        Duration remaining = Duration(milliseconds: estimateTs - now);
                        var dateString = '${remaining.inHours}:${format.format(
                            DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';
                        // print(dateString);
                        return Container(color: Colors.greenAccent.withOpacity(0.3),
                          alignment: Alignment.center,
                          child: Text(dateString),);
                      })
          ],
        )
      ),
    );
  }
}