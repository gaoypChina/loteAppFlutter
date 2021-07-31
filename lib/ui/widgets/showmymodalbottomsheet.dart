import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';

import 'mybottomsheet.dart';

showMyModalBottomSheet({@required BuildContext context, MyBottomSheet myBottomSheet, MyBottomSheet2 myBottomSheet2}) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        return 
        myBottomSheet2 != null ?
        myBottomSheet2
        :
        myBottomSheet;
      }
  );
}