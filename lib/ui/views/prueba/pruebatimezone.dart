import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:ntp/ntp.dart';

class PruebaTimeZone extends StatefulWidget {
  const PruebaTimeZone({ Key key }) : super(key: key);

  @override
  _PruebaTimeZoneState createState() => _PruebaTimeZoneState();
}

class _PruebaTimeZoneState extends State<PruebaTimeZone> {
  String currentTimeZone;
  String systemDateTimeString = "";
  String ntpDateTimeString = "";
  String rdnowDateTimeString = "";
  String loteriaDateTimeString = "";

  _showDates() async {
    
    print("before NTP");
    DateTime startDate = await NTP.now();
    var systemDateTime = DateTime.now();
    setState(() {
      ntpDateTimeString = "${startDate.hour}:${startDate.minute}";
      systemDateTimeString = "${systemDateTime.hour}:${systemDateTime.minute}";
      var rdDateTime = Utils.dateTimeToRD(startDate);
      rdnowDateTimeString = "${rdDateTime.hour}:${rdDateTime.minute}";
      var dateTimeLoteria = Utils.horaLoteriaToCurrentTimeZone("08:05", startDate);
      loteriaDateTimeString = "${dateTimeLoteria.hour}:${dateTimeLoteria.minute}";
    });
    // print('NTP DateTime: ${startDate}');
    // print("systemDateTime: ${systemDateTime.toString()}");
    // print("currentTimeZoneDateTime: ${startDate.toString()}");
  }
  _getCurrentTimeZone() async {
    var crossPlatform = CrossTimezone();
    currentTimeZone = await crossPlatform.getCurrentTimezone();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentTimeZone();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Systemdate: $systemDateTimeString", style: TextStyle(color: Colors.green, fontSize: 16),),
            Text("RD: $rdnowDateTimeString", style: TextStyle(color: Colors.purple, fontSize: 16),),
            Text("NTP: $ntpDateTimeString"),
            Text("Loteria currentTime: $loteriaDateTimeString"),
            TextButton(child: Text("Mostrar fecha"), onPressed: _showDates,),
          ],
        ),
      ),
    );
  }
}