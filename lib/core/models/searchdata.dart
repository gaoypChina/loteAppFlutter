


import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/permiso.dart';

class SearchDataType {
  const SearchDataType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const SearchDataType lottery = SearchDataType._(0);

  /// Extra-light
  static const SearchDataType user = SearchDataType._(1);

  /// Light
  static const SearchDataType branch = SearchDataType._(2);

  static const SearchDataType group = SearchDataType._(3);
  static const SearchDataType sale = SearchDataType._(4);

  /// A list of all the font weights.
  static const List<SearchDataType> values = <SearchDataType>[
    lottery, user, branch, group, sale
  ];
}

class SearchData {
  int id;
  String title;
  String subtitle;
  double total;
  DateTime created_at;
  SearchDataType type;

  SearchData({this.id, this.title, this.subtitle, this.total, this.created_at, this.type});

  SearchData.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        title = snapshot['title'] != null ? snapshot['title'].toString() : '',
        subtitle = snapshot['subtitle'] != null ? snapshot['subtitle'] : '',
        total = Utils.toDouble(snapshot['total'], returnNullIfNotDouble: true),
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : null,
        type = getType(snapshot["type"])
        ;


  static SearchDataType getType(String type){
    SearchDataType returnType;
    switch (type) {
      case "lottery":
        returnType = SearchDataType.lottery;
        break;
      case "branch":
        returnType = SearchDataType.branch;
        break;
      case "user":
        returnType = SearchDataType.user;
        break;
      case "group":
        returnType = SearchDataType.group;
        break;
      default:
        returnType = type == "sale" ?  SearchDataType.sale : null;
    }

    return returnType;
  }

  static List<Permiso> permisosToMap(List<dynamic> permisos){
    if(permisos != null && permisos.length > 0)
      return permisos.map((data) => Permiso.fromMap(data)).toList();
    else
      return [];
  }

  // static List<Prestamo> PrestamoSuperpaleToMap(List<dynamic> Prestamos){
  //   if(Prestamos != null)
  //     return Prestamos.map((data) => Prestamo.fromMap(Utils.parsedToJsonOrNot(data)).toList();)
  //   else
  //     return List<Prestamo>();
  // }

  toJson() {
    return {
      "id": (id != null) ? id.toInt() : null,
      "title": title,
    };
  }
}