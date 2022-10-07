import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';

class MyEmpty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String titleButton;
  final Function onTap;
  final Widget customButtom;
  final Color color;

  MyEmpty(
      {Key key,
      this.icon,
      this.title = '',
      this.titleButton = '',
      this.onTap,
      this.customButtom,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Icon(
            icon,
            color: MyColors.grey,
          ),
        ),
        MyDescripcon(title: title),
        (customButtom != null)
            ? customButtom
            : Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextButton(
                    onPressed: onTap,
                    child: Text(
                      titleButton,
                      style: TextStyle(
                          color: color ?? Theme.of(context).primaryColor,
                          fontFamily: "GoogleSans",
                          letterSpacing: 0.4),
                    )),
              )
      ],
    );
  }
}
