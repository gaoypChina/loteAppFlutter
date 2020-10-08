import 'package:flutter/material.dart';

mySplashScreen({@required BuildContext context}){
  SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(child: Image(image: AssetImage('assets/images/loterias_dominicanas.png'), width: MediaQuery.of(context).size.width / 1.5,))
              )
            ),
            // Expanded(flex: 4, child: Image(image: AssetImage('assets/images/oterias_dominicanas.png'),)),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: new CircularProgressIndicator(),
                  ),
                ),
            )
          ],
        ),
      );
    
}