
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

import 'mybutton.dart';

Widget myBottomWidget({@required BuildContext context, Function onTap, String text, ValueNotifier<bool> cargando}){

  _back(){
    Navigator.pop(context);
  }

  return (onTap == null)
  ?
  null
  :
  Container(
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              offset: Offset(0.0, -1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: cargando,
                    builder: (_, value, __) {
                      return Wrap(children: [
                        value
                        ?
                        CircularProgressIndicator()
                        :
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextButton(onPressed: _back, child: Text("Cancelar", style: TextStyle(color: Utils.fromHex("#3c4043"), fontFamily: "GoogleSans"),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: MyButton(
                            isResponsive: false,
                            title: text,
                            function: onTap,
                            cargando: value,
                            // type: MyButtonType.noResponsive,
                          ),
                        ),
                        
                      ],);
                    }
                  ),
                )
              ],
            ),
      );
      
}

