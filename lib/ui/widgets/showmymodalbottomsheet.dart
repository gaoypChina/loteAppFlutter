import 'package:flutter/material.dart';

import 'mybottomsheet.dart';

showMyModalBottomSheet({@required BuildContext context, MyBottomSheet myBottomSheet}) async {
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
        return myBottomSheet;
      }
  );
}