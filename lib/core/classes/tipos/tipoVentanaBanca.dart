class TipoVentanaBanca {
  const TipoVentanaBanca._(this.index);

  final int index;
  static const TipoVentanaBanca normal = TipoVentanaBanca._(0);
  static const TipoVentanaBanca actualizarMasivamente = TipoVentanaBanca._(1);
  static const TipoVentanaBanca crearMasivamente = TipoVentanaBanca._(2);

  static const List<TipoVentanaBanca> values = <TipoVentanaBanca>[
    normal, actualizarMasivamente, crearMasivamente
  ];
}