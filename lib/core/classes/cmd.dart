class CMD{
  static const String h1 = "h1";
  static const String h2 = "h2";
  static const String p = "p";
  static const String left = "left";
  static const String right = "right";
  static const String center = "center";
  static const String qr = "qr";
  static const String textBoldOn = "textBoldOn";
  static const String textBoldOff = "textBoldOff";
  static const String textSizeDoubleWidth = "textSizeDoubleWidth";

  static const String h1Web = '\x1b\x21\x30'; //TXT_4SQUARE
  static const String h2Web = '\x1b\x21\x10'; //TXT_2HEIGHT
  static const String centerWeb = '\x1b\x61\x01'; //TXT_ALIGN_CT
  static const String leftWeb = '\x1b\x61\x00'; //TXT_ALIGN_LT Left justification
  static const String rightWeb = '\x1b\x61\x02'; //TXT_ALIGN_RT right justification
  static const String pWeb = '\x1b\x21\x00'; //TXT_NORMAL


  static cmdToWeb(String cmd){
    String cmdToReturn;
    if(cmd == CMD.h1)
      cmdToReturn = CMD.h1Web;
    if(cmd == CMD.h2)
      cmdToReturn = CMD.h2Web;
    if(cmd == CMD.center)
      cmdToReturn = CMD.centerWeb;
    if(cmd == CMD.left)
      cmdToReturn = CMD.leftWeb;
    if(cmd == CMD.right)
      cmdToReturn = CMD.rightWeb;
    if(cmd == CMD.p)
      cmdToReturn = CMD.pWeb;

    return cmdToReturn;
  }
}