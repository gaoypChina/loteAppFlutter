import 'package:loterias/core/classes/cross_platform_screensize/cross_platform_screensize.dart';

class ScreenSize{
  static final double sm = (CrossScreenSize()).getSmSize();
  static final double md = (CrossScreenSize()).getMdSize();
  static final double lg = (CrossScreenSize()).getLgSize();
  static final double xlg = (CrossScreenSize()).getXlgSize();

  static isSmall(double size){
    return size <= sm;
  }

  static isMedium(double size){
    return  size > sm && size <= md;
  }

  static isLarge(double size){
    return  size > md && size <= lg;
  }

  static isXLarge(double size){
    return  size > lg;
  }

  static ScreenSizeType isType(double size){
    if(ScreenSize.isSmall(size))
      return ScreenSizeType.sm;
    else if(ScreenSize.isMedium(size))
      return ScreenSizeType.md;
    else if(ScreenSize.isLarge(size))
      return ScreenSizeType.lg;
    else
      return ScreenSizeType.xlg;
  }
}

class ScreenSizeType{
  List<String> types = ["sm", "md", "large", "xlarge"];
  int index = 0;
  ScreenSizeType._(int index){
    this.index = index;
  }
  static ScreenSizeType sm = ScreenSizeType._(0);
  static ScreenSizeType md = ScreenSizeType._(1);
  static ScreenSizeType lg = ScreenSizeType._(2);
  static ScreenSizeType xlg = ScreenSizeType._(3);

  String toString() => "${types[index]}";
}