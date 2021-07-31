import 'package:flutter_test/flutter_test.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



void main() {
  group("Socket test", (){
    test("Socket connect", () async {
      var socket;
    var signedToken = Utils.createJwtForSocket(data: {'id': 836, 'username' : "john.doe"}, key: 'quierocomerpopola');
      socket = IO.io(Utils.URL_SOCKET, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {'foo': 'bar'}, // optional
      'query': 'auth_token='+signedToken.toString() +'&room=' + "valentin"
      // 'query': 'auth_token='+"hola" +'&room=' + "valentin"
    });
    socket.on('connect', (_) async {
     print("connected...");
      // print(data);
      socket.emit("message", ["Hello world!"]);
      
    });

    
    //  socket.on("realtime-stock:App\\Events\\RealtimeStockEvent", (data) async {   //sample event
    //   // var parsed = Utils.parseDatos(data);
    //   var parsed = data.cast<String, dynamic>();
    //   // print('type List<stocks>: ${parsed['stocks'].runtimeType.toString() ==  'List<dynamic>'}');
    //   // print('type stock: ${parsed['stocks']}');
    //   //await Realtime.addStocksDatosNuevos(parsed['stocks']);
    //   // print('event parsed: ${parsed}');
    //   // print("realtime-stock1");
    //   // print(data);
    //   print("realtime-stock antes");
    //   if(parsed['stocks'].runtimeType.toString() !=  'List<dynamic>'){
    //     await Realtime.addStock(parsed['stocks']);
    //     // print("realtime-stock despues");
    //   }else{
    //     await Realtime.addStocks(parsed['stocks']);
    //   }
    // });

   
    
    
    socket.on("error", (data){   //sample event
      print("onError: $data");
    // _listaMensajes.add("initSocket OnError ${DateTime.now().hour}:${DateTime.now().minute}");

  // Utils.showAlertDialog(context: context, title: "Principal initSocket error", content: "onError start socket");

      // print(data);
    });
    socket.on('connect_error', (data) => print(data));
    socket.on('error', (data) => print("errr: ${data}"));
    
    // socket.onError((e) => print(e));
    socket.connect();
      expect(true == null, false);
    });
  });
}