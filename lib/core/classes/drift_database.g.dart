// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String name;
  final DateTime created_at;
  final bool status;
  Task(
      {@required this.id,
      @required this.name,
      this.created_at,
      @required this.status});
  factory Task.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Task(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      status: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<bool>(status);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      status: serializer.fromJson<bool>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(created_at),
      'status': serializer.toJson<bool>(status),
    };
  }

  Task copyWith({int id, String name, DateTime created_at, bool status}) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        created_at: created_at ?? this.created_at,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, created_at, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.name == this.name &&
          other.created_at == this.created_at &&
          other.status == this.status);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> created_at;
  final Value<bool> status;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.created_at = const Value.absent(),
    this.status = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.created_at = const Value.absent(),
    this.status = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Task> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<DateTime> created_at,
    Expression<bool> status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (created_at != null) 'created_at': created_at,
      if (status != null) 'status': status,
    });
  }

  TasksCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<DateTime> created_at,
      Value<bool> status}) {
    return TasksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      created_at: created_at ?? this.created_at,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name =>
      _name ??= GeneratedColumn<String>('name', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<bool> _status;
  @override
  GeneratedColumn<bool> get status =>
      _status ??= GeneratedColumn<bool>('status', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultConstraints: 'CHECK (status IN (0, 1))',
          defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, created_at, status];
  @override
  String get aliasedName => _alias ?? 'tasks';
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String tablePrefix}) {
    return Task.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

class Permission extends DataClass implements Insertable<Permission> {
  final int id;
  final String descripcion;
  final DateTime created_at;
  final int idTipo;
  final int status;
  Permission(
      {@required this.id,
      @required this.descripcion,
      this.created_at,
      @required this.idTipo,
      @required this.status});
  factory Permission.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Permission(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      idTipo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_tipo']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || idTipo != null) {
      map['id_tipo'] = Variable<int>(idTipo);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    return map;
  }

  PermissionsCompanion toCompanion(bool nullToAbsent) {
    return PermissionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      idTipo:
          idTipo == null && nullToAbsent ? const Value.absent() : Value(idTipo),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Permission.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Permission(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      idTipo: serializer.fromJson<int>(json['idTipo']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'created_at': serializer.toJson<DateTime>(created_at),
      'idTipo': serializer.toJson<int>(idTipo),
      'status': serializer.toJson<int>(status),
    };
  }

  Permission copyWith(
          {int id,
          String descripcion,
          DateTime created_at,
          int idTipo,
          int status}) =>
      Permission(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        created_at: created_at ?? this.created_at,
        idTipo: idTipo ?? this.idTipo,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Permission(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('idTipo: $idTipo, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, descripcion, created_at, idTipo, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Permission &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.created_at == this.created_at &&
          other.idTipo == this.idTipo &&
          other.status == this.status);
}

class PermissionsCompanion extends UpdateCompanion<Permission> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<DateTime> created_at;
  final Value<int> idTipo;
  final Value<int> status;
  const PermissionsCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.created_at = const Value.absent(),
    this.idTipo = const Value.absent(),
    this.status = const Value.absent(),
  });
  PermissionsCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    this.created_at = const Value.absent(),
    @required int idTipo,
    @required int status,
  })  : descripcion = Value(descripcion),
        idTipo = Value(idTipo),
        status = Value(status);
  static Insertable<Permission> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<DateTime> created_at,
    Expression<int> idTipo,
    Expression<int> status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (created_at != null) 'created_at': created_at,
      if (idTipo != null) 'id_tipo': idTipo,
      if (status != null) 'status': status,
    });
  }

  PermissionsCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<DateTime> created_at,
      Value<int> idTipo,
      Value<int> status}) {
    return PermissionsCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      created_at: created_at ?? this.created_at,
      idTipo: idTipo ?? this.idTipo,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (idTipo.present) {
      map['id_tipo'] = Variable<int>(idTipo.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PermissionsCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('idTipo: $idTipo, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $PermissionsTable extends Permissions
    with TableInfo<$PermissionsTable, Permission> {
  final GeneratedDatabase _db;
  final String _alias;
  $PermissionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idTipoMeta = const VerificationMeta('idTipo');
  GeneratedColumn<int> _idTipo;
  @override
  GeneratedColumn<int> get idTipo =>
      _idTipo ??= GeneratedColumn<int>('id_tipo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descripcion, created_at, idTipo, status];
  @override
  String get aliasedName => _alias ?? 'permissions';
  @override
  String get actualTableName => 'permissions';
  @override
  VerificationContext validateIntegrity(Insertable<Permission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('id_tipo')) {
      context.handle(_idTipoMeta,
          idTipo.isAcceptableOrUnknown(data['id_tipo'], _idTipoMeta));
    } else if (isInserting) {
      context.missing(_idTipoMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Permission map(Map<String, dynamic> data, {String tablePrefix}) {
    return Permission.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PermissionsTable createAlias(String alias) {
    return $PermissionsTable(_db, alias);
  }
}

class Day extends DataClass implements Insertable<Day> {
  final int id;
  final String descripcion;
  final DateTime created_at;
  final int wday;
  final DateTime horaApertura;
  final DateTime horaCierre;
  Day(
      {@required this.id,
      @required this.descripcion,
      this.created_at,
      @required this.wday,
      @required this.horaApertura,
      @required this.horaCierre});
  factory Day.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Day(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      wday: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}wday']),
      horaApertura: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hora_apertura']),
      horaCierre: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hora_cierre']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || wday != null) {
      map['wday'] = Variable<int>(wday);
    }
    if (!nullToAbsent || horaApertura != null) {
      map['hora_apertura'] = Variable<DateTime>(horaApertura);
    }
    if (!nullToAbsent || horaCierre != null) {
      map['hora_cierre'] = Variable<DateTime>(horaCierre);
    }
    return map;
  }

  DaysCompanion toCompanion(bool nullToAbsent) {
    return DaysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      wday: wday == null && nullToAbsent ? const Value.absent() : Value(wday),
      horaApertura: horaApertura == null && nullToAbsent
          ? const Value.absent()
          : Value(horaApertura),
      horaCierre: horaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(horaCierre),
    );
  }

  factory Day.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Day(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      wday: serializer.fromJson<int>(json['wday']),
      horaApertura: serializer.fromJson<DateTime>(json['horaApertura']),
      horaCierre: serializer.fromJson<DateTime>(json['horaCierre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'created_at': serializer.toJson<DateTime>(created_at),
      'wday': serializer.toJson<int>(wday),
      'horaApertura': serializer.toJson<DateTime>(horaApertura),
      'horaCierre': serializer.toJson<DateTime>(horaCierre),
    };
  }

  Day copyWith(
          {int id,
          String descripcion,
          DateTime created_at,
          int wday,
          DateTime horaApertura,
          DateTime horaCierre}) =>
      Day(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        created_at: created_at ?? this.created_at,
        wday: wday ?? this.wday,
        horaApertura: horaApertura ?? this.horaApertura,
        horaCierre: horaCierre ?? this.horaCierre,
      );
  @override
  String toString() {
    return (StringBuffer('Day(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('wday: $wday, ')
          ..write('horaApertura: $horaApertura, ')
          ..write('horaCierre: $horaCierre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, descripcion, created_at, wday, horaApertura, horaCierre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Day &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.created_at == this.created_at &&
          other.wday == this.wday &&
          other.horaApertura == this.horaApertura &&
          other.horaCierre == this.horaCierre);
}

class DaysCompanion extends UpdateCompanion<Day> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<DateTime> created_at;
  final Value<int> wday;
  final Value<DateTime> horaApertura;
  final Value<DateTime> horaCierre;
  const DaysCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.created_at = const Value.absent(),
    this.wday = const Value.absent(),
    this.horaApertura = const Value.absent(),
    this.horaCierre = const Value.absent(),
  });
  DaysCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    this.created_at = const Value.absent(),
    @required int wday,
    @required DateTime horaApertura,
    @required DateTime horaCierre,
  })  : descripcion = Value(descripcion),
        wday = Value(wday),
        horaApertura = Value(horaApertura),
        horaCierre = Value(horaCierre);
  static Insertable<Day> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<DateTime> created_at,
    Expression<int> wday,
    Expression<DateTime> horaApertura,
    Expression<DateTime> horaCierre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (created_at != null) 'created_at': created_at,
      if (wday != null) 'wday': wday,
      if (horaApertura != null) 'hora_apertura': horaApertura,
      if (horaCierre != null) 'hora_cierre': horaCierre,
    });
  }

  DaysCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<DateTime> created_at,
      Value<int> wday,
      Value<DateTime> horaApertura,
      Value<DateTime> horaCierre}) {
    return DaysCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      created_at: created_at ?? this.created_at,
      wday: wday ?? this.wday,
      horaApertura: horaApertura ?? this.horaApertura,
      horaCierre: horaCierre ?? this.horaCierre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (wday.present) {
      map['wday'] = Variable<int>(wday.value);
    }
    if (horaApertura.present) {
      map['hora_apertura'] = Variable<DateTime>(horaApertura.value);
    }
    if (horaCierre.present) {
      map['hora_cierre'] = Variable<DateTime>(horaCierre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaysCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('wday: $wday, ')
          ..write('horaApertura: $horaApertura, ')
          ..write('horaCierre: $horaCierre')
          ..write(')'))
        .toString();
  }
}

class $DaysTable extends Days with TableInfo<$DaysTable, Day> {
  final GeneratedDatabase _db;
  final String _alias;
  $DaysTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _wdayMeta = const VerificationMeta('wday');
  GeneratedColumn<int> _wday;
  @override
  GeneratedColumn<int> get wday =>
      _wday ??= GeneratedColumn<int>('wday', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _horaAperturaMeta =
      const VerificationMeta('horaApertura');
  GeneratedColumn<DateTime> _horaApertura;
  @override
  GeneratedColumn<DateTime> get horaApertura => _horaApertura ??=
      GeneratedColumn<DateTime>('hora_apertura', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _horaCierreMeta = const VerificationMeta('horaCierre');
  GeneratedColumn<DateTime> _horaCierre;
  @override
  GeneratedColumn<DateTime> get horaCierre => _horaCierre ??=
      GeneratedColumn<DateTime>('hora_cierre', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descripcion, created_at, wday, horaApertura, horaCierre];
  @override
  String get aliasedName => _alias ?? 'days';
  @override
  String get actualTableName => 'days';
  @override
  VerificationContext validateIntegrity(Insertable<Day> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('wday')) {
      context.handle(
          _wdayMeta, wday.isAcceptableOrUnknown(data['wday'], _wdayMeta));
    } else if (isInserting) {
      context.missing(_wdayMeta);
    }
    if (data.containsKey('hora_apertura')) {
      context.handle(
          _horaAperturaMeta,
          horaApertura.isAcceptableOrUnknown(
              data['hora_apertura'], _horaAperturaMeta));
    } else if (isInserting) {
      context.missing(_horaAperturaMeta);
    }
    if (data.containsKey('hora_cierre')) {
      context.handle(
          _horaCierreMeta,
          horaCierre.isAcceptableOrUnknown(
              data['hora_cierre'], _horaCierreMeta));
    } else if (isInserting) {
      context.missing(_horaCierreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Day map(Map<String, dynamic> data, {String tablePrefix}) {
    return Day.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DaysTable createAlias(String alias) {
    return $DaysTable(_db, alias);
  }
}

class Lotterie extends DataClass implements Insertable<Lotterie> {
  final int id;
  final String descripcion;
  final String abreviatura;
  final DateTime created_at;
  final int status;
  Lotterie(
      {@required this.id,
      @required this.descripcion,
      @required this.abreviatura,
      this.created_at,
      @required this.status});
  factory Lotterie.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Lotterie(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      abreviatura: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}abreviatura']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || abreviatura != null) {
      map['abreviatura'] = Variable<String>(abreviatura);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    return map;
  }

  LotteriesCompanion toCompanion(bool nullToAbsent) {
    return LotteriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      abreviatura: abreviatura == null && nullToAbsent
          ? const Value.absent()
          : Value(abreviatura),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Lotterie.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lotterie(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      abreviatura: serializer.fromJson<String>(json['abreviatura']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'abreviatura': serializer.toJson<String>(abreviatura),
      'created_at': serializer.toJson<DateTime>(created_at),
      'status': serializer.toJson<int>(status),
    };
  }

  Lotterie copyWith(
          {int id,
          String descripcion,
          String abreviatura,
          DateTime created_at,
          int status}) =>
      Lotterie(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        abreviatura: abreviatura ?? this.abreviatura,
        created_at: created_at ?? this.created_at,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Lotterie(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('abreviatura: $abreviatura, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, descripcion, abreviatura, created_at, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lotterie &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.abreviatura == this.abreviatura &&
          other.created_at == this.created_at &&
          other.status == this.status);
}

class LotteriesCompanion extends UpdateCompanion<Lotterie> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<String> abreviatura;
  final Value<DateTime> created_at;
  final Value<int> status;
  const LotteriesCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.abreviatura = const Value.absent(),
    this.created_at = const Value.absent(),
    this.status = const Value.absent(),
  });
  LotteriesCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    @required String abreviatura,
    this.created_at = const Value.absent(),
    @required int status,
  })  : descripcion = Value(descripcion),
        abreviatura = Value(abreviatura),
        status = Value(status);
  static Insertable<Lotterie> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<String> abreviatura,
    Expression<DateTime> created_at,
    Expression<int> status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (abreviatura != null) 'abreviatura': abreviatura,
      if (created_at != null) 'created_at': created_at,
      if (status != null) 'status': status,
    });
  }

  LotteriesCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<String> abreviatura,
      Value<DateTime> created_at,
      Value<int> status}) {
    return LotteriesCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      abreviatura: abreviatura ?? this.abreviatura,
      created_at: created_at ?? this.created_at,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (abreviatura.present) {
      map['abreviatura'] = Variable<String>(abreviatura.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LotteriesCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('abreviatura: $abreviatura, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $LotteriesTable extends Lotteries
    with TableInfo<$LotteriesTable, Lotterie> {
  final GeneratedDatabase _db;
  final String _alias;
  $LotteriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _abreviaturaMeta =
      const VerificationMeta('abreviatura');
  GeneratedColumn<String> _abreviatura;
  @override
  GeneratedColumn<String> get abreviatura => _abreviatura ??=
      GeneratedColumn<String>('abreviatura', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descripcion, abreviatura, created_at, status];
  @override
  String get aliasedName => _alias ?? 'lotteries';
  @override
  String get actualTableName => 'lotteries';
  @override
  VerificationContext validateIntegrity(Insertable<Lotterie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('abreviatura')) {
      context.handle(
          _abreviaturaMeta,
          abreviatura.isAcceptableOrUnknown(
              data['abreviatura'], _abreviaturaMeta));
    } else if (isInserting) {
      context.missing(_abreviaturaMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lotterie map(Map<String, dynamic> data, {String tablePrefix}) {
    return Lotterie.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LotteriesTable createAlias(String alias) {
    return $LotteriesTable(_db, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String nombres;
  final String email;
  final String usuario;
  final String servidor;
  final DateTime created_at;
  final int status;
  final int idGrupo;
  User(
      {@required this.id,
      @required this.nombres,
      @required this.email,
      @required this.usuario,
      @required this.servidor,
      this.created_at,
      @required this.status,
      this.idGrupo});
  factory User.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nombres: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nombres']),
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      usuario: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}usuario']),
      servidor: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}servidor']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
      idGrupo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_grupo']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nombres != null) {
      map['nombres'] = Variable<String>(nombres);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || usuario != null) {
      map['usuario'] = Variable<String>(usuario);
    }
    if (!nullToAbsent || servidor != null) {
      map['servidor'] = Variable<String>(servidor);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || idGrupo != null) {
      map['id_grupo'] = Variable<int>(idGrupo);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nombres: nombres == null && nullToAbsent
          ? const Value.absent()
          : Value(nombres),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      usuario: usuario == null && nullToAbsent
          ? const Value.absent()
          : Value(usuario),
      servidor: servidor == null && nullToAbsent
          ? const Value.absent()
          : Value(servidor),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      idGrupo: idGrupo == null && nullToAbsent
          ? const Value.absent()
          : Value(idGrupo),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      nombres: serializer.fromJson<String>(json['nombres']),
      email: serializer.fromJson<String>(json['email']),
      usuario: serializer.fromJson<String>(json['usuario']),
      servidor: serializer.fromJson<String>(json['servidor']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      status: serializer.fromJson<int>(json['status']),
      idGrupo: serializer.fromJson<int>(json['idGrupo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombres': serializer.toJson<String>(nombres),
      'email': serializer.toJson<String>(email),
      'usuario': serializer.toJson<String>(usuario),
      'servidor': serializer.toJson<String>(servidor),
      'created_at': serializer.toJson<DateTime>(created_at),
      'status': serializer.toJson<int>(status),
      'idGrupo': serializer.toJson<int>(idGrupo),
    };
  }

  User copyWith(
          {int id,
          String nombres,
          String email,
          String usuario,
          String servidor,
          DateTime created_at,
          int status,
          int idGrupo}) =>
      User(
        id: id ?? this.id,
        nombres: nombres ?? this.nombres,
        email: email ?? this.email,
        usuario: usuario ?? this.usuario,
        servidor: servidor ?? this.servidor,
        created_at: created_at ?? this.created_at,
        status: status ?? this.status,
        idGrupo: idGrupo ?? this.idGrupo,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('nombres: $nombres, ')
          ..write('email: $email, ')
          ..write('usuario: $usuario, ')
          ..write('servidor: $servidor, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status, ')
          ..write('idGrupo: $idGrupo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nombres, email, usuario, servidor, created_at, status, idGrupo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.nombres == this.nombres &&
          other.email == this.email &&
          other.usuario == this.usuario &&
          other.servidor == this.servidor &&
          other.created_at == this.created_at &&
          other.status == this.status &&
          other.idGrupo == this.idGrupo);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> nombres;
  final Value<String> email;
  final Value<String> usuario;
  final Value<String> servidor;
  final Value<DateTime> created_at;
  final Value<int> status;
  final Value<int> idGrupo;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.nombres = const Value.absent(),
    this.email = const Value.absent(),
    this.usuario = const Value.absent(),
    this.servidor = const Value.absent(),
    this.created_at = const Value.absent(),
    this.status = const Value.absent(),
    this.idGrupo = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    @required String nombres,
    @required String email,
    @required String usuario,
    @required String servidor,
    this.created_at = const Value.absent(),
    @required int status,
    this.idGrupo = const Value.absent(),
  })  : nombres = Value(nombres),
        email = Value(email),
        usuario = Value(usuario),
        servidor = Value(servidor),
        status = Value(status);
  static Insertable<User> custom({
    Expression<int> id,
    Expression<String> nombres,
    Expression<String> email,
    Expression<String> usuario,
    Expression<String> servidor,
    Expression<DateTime> created_at,
    Expression<int> status,
    Expression<int> idGrupo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombres != null) 'nombres': nombres,
      if (email != null) 'email': email,
      if (usuario != null) 'usuario': usuario,
      if (servidor != null) 'servidor': servidor,
      if (created_at != null) 'created_at': created_at,
      if (status != null) 'status': status,
      if (idGrupo != null) 'id_grupo': idGrupo,
    });
  }

  UsersCompanion copyWith(
      {Value<int> id,
      Value<String> nombres,
      Value<String> email,
      Value<String> usuario,
      Value<String> servidor,
      Value<DateTime> created_at,
      Value<int> status,
      Value<int> idGrupo}) {
    return UsersCompanion(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      email: email ?? this.email,
      usuario: usuario ?? this.usuario,
      servidor: servidor ?? this.servidor,
      created_at: created_at ?? this.created_at,
      status: status ?? this.status,
      idGrupo: idGrupo ?? this.idGrupo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    if (servidor.present) {
      map['servidor'] = Variable<String>(servidor.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (idGrupo.present) {
      map['id_grupo'] = Variable<int>(idGrupo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('nombres: $nombres, ')
          ..write('email: $email, ')
          ..write('usuario: $usuario, ')
          ..write('servidor: $servidor, ')
          ..write('created_at: $created_at, ')
          ..write('status: $status, ')
          ..write('idGrupo: $idGrupo')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nombresMeta = const VerificationMeta('nombres');
  GeneratedColumn<String> _nombres;
  @override
  GeneratedColumn<String> get nombres =>
      _nombres ??= GeneratedColumn<String>('nombres', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedColumn<String> _email;
  @override
  GeneratedColumn<String> get email =>
      _email ??= GeneratedColumn<String>('email', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _usuarioMeta = const VerificationMeta('usuario');
  GeneratedColumn<String> _usuario;
  @override
  GeneratedColumn<String> get usuario =>
      _usuario ??= GeneratedColumn<String>('usuario', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _servidorMeta = const VerificationMeta('servidor');
  GeneratedColumn<String> _servidor;
  @override
  GeneratedColumn<String> get servidor =>
      _servidor ??= GeneratedColumn<String>('servidor', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idGrupoMeta = const VerificationMeta('idGrupo');
  GeneratedColumn<int> _idGrupo;
  @override
  GeneratedColumn<int> get idGrupo =>
      _idGrupo ??= GeneratedColumn<int>('id_grupo', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombres, email, usuario, servidor, created_at, status, idGrupo];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('nombres')) {
      context.handle(_nombresMeta,
          nombres.isAcceptableOrUnknown(data['nombres'], _nombresMeta));
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('usuario')) {
      context.handle(_usuarioMeta,
          usuario.isAcceptableOrUnknown(data['usuario'], _usuarioMeta));
    } else if (isInserting) {
      context.missing(_usuarioMeta);
    }
    if (data.containsKey('servidor')) {
      context.handle(_servidorMeta,
          servidor.isAcceptableOrUnknown(data['servidor'], _servidorMeta));
    } else if (isInserting) {
      context.missing(_servidorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('id_grupo')) {
      context.handle(_idGrupoMeta,
          idGrupo.isAcceptableOrUnknown(data['id_grupo'], _idGrupoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String consorcio;
  final int idTipoFormatoTicket;
  final int imprimirNombreConsorcio;
  final String descripcionTipoFormatoTicket;
  final int cancelarTicketWhatsapp;
  final int imprimirNombreBanca;
  final int pagarTicketEnCualquierBanca;
  Setting(
      {@required this.id,
      @required this.consorcio,
      @required this.idTipoFormatoTicket,
      @required this.imprimirNombreConsorcio,
      @required this.descripcionTipoFormatoTicket,
      @required this.cancelarTicketWhatsapp,
      @required this.imprimirNombreBanca,
      @required this.pagarTicketEnCualquierBanca});
  factory Setting.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Setting(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      consorcio: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}consorcio']),
      idTipoFormatoTicket: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_tipo_formato_ticket']),
      imprimirNombreConsorcio: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}imprimir_nombre_consorcio']),
      descripcionTipoFormatoTicket: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}descripcion_tipo_formato_ticket']),
      cancelarTicketWhatsapp: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}cancelar_ticket_whatsapp']),
      imprimirNombreBanca: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}imprimir_nombre_banca']),
      pagarTicketEnCualquierBanca: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}pagar_ticket_en_cualquier_banca']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || consorcio != null) {
      map['consorcio'] = Variable<String>(consorcio);
    }
    if (!nullToAbsent || idTipoFormatoTicket != null) {
      map['id_tipo_formato_ticket'] = Variable<int>(idTipoFormatoTicket);
    }
    if (!nullToAbsent || imprimirNombreConsorcio != null) {
      map['imprimir_nombre_consorcio'] = Variable<int>(imprimirNombreConsorcio);
    }
    if (!nullToAbsent || descripcionTipoFormatoTicket != null) {
      map['descripcion_tipo_formato_ticket'] =
          Variable<String>(descripcionTipoFormatoTicket);
    }
    if (!nullToAbsent || cancelarTicketWhatsapp != null) {
      map['cancelar_ticket_whatsapp'] = Variable<int>(cancelarTicketWhatsapp);
    }
    if (!nullToAbsent || imprimirNombreBanca != null) {
      map['imprimir_nombre_banca'] = Variable<int>(imprimirNombreBanca);
    }
    if (!nullToAbsent || pagarTicketEnCualquierBanca != null) {
      map['pagar_ticket_en_cualquier_banca'] =
          Variable<int>(pagarTicketEnCualquierBanca);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      consorcio: consorcio == null && nullToAbsent
          ? const Value.absent()
          : Value(consorcio),
      idTipoFormatoTicket: idTipoFormatoTicket == null && nullToAbsent
          ? const Value.absent()
          : Value(idTipoFormatoTicket),
      imprimirNombreConsorcio: imprimirNombreConsorcio == null && nullToAbsent
          ? const Value.absent()
          : Value(imprimirNombreConsorcio),
      descripcionTipoFormatoTicket:
          descripcionTipoFormatoTicket == null && nullToAbsent
              ? const Value.absent()
              : Value(descripcionTipoFormatoTicket),
      cancelarTicketWhatsapp: cancelarTicketWhatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelarTicketWhatsapp),
      imprimirNombreBanca: imprimirNombreBanca == null && nullToAbsent
          ? const Value.absent()
          : Value(imprimirNombreBanca),
      pagarTicketEnCualquierBanca:
          pagarTicketEnCualquierBanca == null && nullToAbsent
              ? const Value.absent()
              : Value(pagarTicketEnCualquierBanca),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      consorcio: serializer.fromJson<String>(json['consorcio']),
      idTipoFormatoTicket:
          serializer.fromJson<int>(json['idTipoFormatoTicket']),
      imprimirNombreConsorcio:
          serializer.fromJson<int>(json['imprimirNombreConsorcio']),
      descripcionTipoFormatoTicket:
          serializer.fromJson<String>(json['descripcionTipoFormatoTicket']),
      cancelarTicketWhatsapp:
          serializer.fromJson<int>(json['cancelarTicketWhatsapp']),
      imprimirNombreBanca:
          serializer.fromJson<int>(json['imprimirNombreBanca']),
      pagarTicketEnCualquierBanca:
          serializer.fromJson<int>(json['pagarTicketEnCualquierBanca']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'consorcio': serializer.toJson<String>(consorcio),
      'idTipoFormatoTicket': serializer.toJson<int>(idTipoFormatoTicket),
      'imprimirNombreConsorcio':
          serializer.toJson<int>(imprimirNombreConsorcio),
      'descripcionTipoFormatoTicket':
          serializer.toJson<String>(descripcionTipoFormatoTicket),
      'cancelarTicketWhatsapp': serializer.toJson<int>(cancelarTicketWhatsapp),
      'imprimirNombreBanca': serializer.toJson<int>(imprimirNombreBanca),
      'pagarTicketEnCualquierBanca':
          serializer.toJson<int>(pagarTicketEnCualquierBanca),
    };
  }

  Setting copyWith(
          {int id,
          String consorcio,
          int idTipoFormatoTicket,
          int imprimirNombreConsorcio,
          String descripcionTipoFormatoTicket,
          int cancelarTicketWhatsapp,
          int imprimirNombreBanca,
          int pagarTicketEnCualquierBanca}) =>
      Setting(
        id: id ?? this.id,
        consorcio: consorcio ?? this.consorcio,
        idTipoFormatoTicket: idTipoFormatoTicket ?? this.idTipoFormatoTicket,
        imprimirNombreConsorcio:
            imprimirNombreConsorcio ?? this.imprimirNombreConsorcio,
        descripcionTipoFormatoTicket:
            descripcionTipoFormatoTicket ?? this.descripcionTipoFormatoTicket,
        cancelarTicketWhatsapp:
            cancelarTicketWhatsapp ?? this.cancelarTicketWhatsapp,
        imprimirNombreBanca: imprimirNombreBanca ?? this.imprimirNombreBanca,
        pagarTicketEnCualquierBanca:
            pagarTicketEnCualquierBanca ?? this.pagarTicketEnCualquierBanca,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('consorcio: $consorcio, ')
          ..write('idTipoFormatoTicket: $idTipoFormatoTicket, ')
          ..write('imprimirNombreConsorcio: $imprimirNombreConsorcio, ')
          ..write(
              'descripcionTipoFormatoTicket: $descripcionTipoFormatoTicket, ')
          ..write('cancelarTicketWhatsapp: $cancelarTicketWhatsapp, ')
          ..write('imprimirNombreBanca: $imprimirNombreBanca, ')
          ..write('pagarTicketEnCualquierBanca: $pagarTicketEnCualquierBanca')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      consorcio,
      idTipoFormatoTicket,
      imprimirNombreConsorcio,
      descripcionTipoFormatoTicket,
      cancelarTicketWhatsapp,
      imprimirNombreBanca,
      pagarTicketEnCualquierBanca);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.consorcio == this.consorcio &&
          other.idTipoFormatoTicket == this.idTipoFormatoTicket &&
          other.imprimirNombreConsorcio == this.imprimirNombreConsorcio &&
          other.descripcionTipoFormatoTicket ==
              this.descripcionTipoFormatoTicket &&
          other.cancelarTicketWhatsapp == this.cancelarTicketWhatsapp &&
          other.imprimirNombreBanca == this.imprimirNombreBanca &&
          other.pagarTicketEnCualquierBanca ==
              this.pagarTicketEnCualquierBanca);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> consorcio;
  final Value<int> idTipoFormatoTicket;
  final Value<int> imprimirNombreConsorcio;
  final Value<String> descripcionTipoFormatoTicket;
  final Value<int> cancelarTicketWhatsapp;
  final Value<int> imprimirNombreBanca;
  final Value<int> pagarTicketEnCualquierBanca;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.consorcio = const Value.absent(),
    this.idTipoFormatoTicket = const Value.absent(),
    this.imprimirNombreConsorcio = const Value.absent(),
    this.descripcionTipoFormatoTicket = const Value.absent(),
    this.cancelarTicketWhatsapp = const Value.absent(),
    this.imprimirNombreBanca = const Value.absent(),
    this.pagarTicketEnCualquierBanca = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String consorcio,
    @required int idTipoFormatoTicket,
    @required int imprimirNombreConsorcio,
    @required String descripcionTipoFormatoTicket,
    @required int cancelarTicketWhatsapp,
    @required int imprimirNombreBanca,
    @required int pagarTicketEnCualquierBanca,
  })  : consorcio = Value(consorcio),
        idTipoFormatoTicket = Value(idTipoFormatoTicket),
        imprimirNombreConsorcio = Value(imprimirNombreConsorcio),
        descripcionTipoFormatoTicket = Value(descripcionTipoFormatoTicket),
        cancelarTicketWhatsapp = Value(cancelarTicketWhatsapp),
        imprimirNombreBanca = Value(imprimirNombreBanca),
        pagarTicketEnCualquierBanca = Value(pagarTicketEnCualquierBanca);
  static Insertable<Setting> custom({
    Expression<int> id,
    Expression<String> consorcio,
    Expression<int> idTipoFormatoTicket,
    Expression<int> imprimirNombreConsorcio,
    Expression<String> descripcionTipoFormatoTicket,
    Expression<int> cancelarTicketWhatsapp,
    Expression<int> imprimirNombreBanca,
    Expression<int> pagarTicketEnCualquierBanca,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (consorcio != null) 'consorcio': consorcio,
      if (idTipoFormatoTicket != null)
        'id_tipo_formato_ticket': idTipoFormatoTicket,
      if (imprimirNombreConsorcio != null)
        'imprimir_nombre_consorcio': imprimirNombreConsorcio,
      if (descripcionTipoFormatoTicket != null)
        'descripcion_tipo_formato_ticket': descripcionTipoFormatoTicket,
      if (cancelarTicketWhatsapp != null)
        'cancelar_ticket_whatsapp': cancelarTicketWhatsapp,
      if (imprimirNombreBanca != null)
        'imprimir_nombre_banca': imprimirNombreBanca,
      if (pagarTicketEnCualquierBanca != null)
        'pagar_ticket_en_cualquier_banca': pagarTicketEnCualquierBanca,
    });
  }

  SettingsCompanion copyWith(
      {Value<int> id,
      Value<String> consorcio,
      Value<int> idTipoFormatoTicket,
      Value<int> imprimirNombreConsorcio,
      Value<String> descripcionTipoFormatoTicket,
      Value<int> cancelarTicketWhatsapp,
      Value<int> imprimirNombreBanca,
      Value<int> pagarTicketEnCualquierBanca}) {
    return SettingsCompanion(
      id: id ?? this.id,
      consorcio: consorcio ?? this.consorcio,
      idTipoFormatoTicket: idTipoFormatoTicket ?? this.idTipoFormatoTicket,
      imprimirNombreConsorcio:
          imprimirNombreConsorcio ?? this.imprimirNombreConsorcio,
      descripcionTipoFormatoTicket:
          descripcionTipoFormatoTicket ?? this.descripcionTipoFormatoTicket,
      cancelarTicketWhatsapp:
          cancelarTicketWhatsapp ?? this.cancelarTicketWhatsapp,
      imprimirNombreBanca: imprimirNombreBanca ?? this.imprimirNombreBanca,
      pagarTicketEnCualquierBanca:
          pagarTicketEnCualquierBanca ?? this.pagarTicketEnCualquierBanca,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (consorcio.present) {
      map['consorcio'] = Variable<String>(consorcio.value);
    }
    if (idTipoFormatoTicket.present) {
      map['id_tipo_formato_ticket'] = Variable<int>(idTipoFormatoTicket.value);
    }
    if (imprimirNombreConsorcio.present) {
      map['imprimir_nombre_consorcio'] =
          Variable<int>(imprimirNombreConsorcio.value);
    }
    if (descripcionTipoFormatoTicket.present) {
      map['descripcion_tipo_formato_ticket'] =
          Variable<String>(descripcionTipoFormatoTicket.value);
    }
    if (cancelarTicketWhatsapp.present) {
      map['cancelar_ticket_whatsapp'] =
          Variable<int>(cancelarTicketWhatsapp.value);
    }
    if (imprimirNombreBanca.present) {
      map['imprimir_nombre_banca'] = Variable<int>(imprimirNombreBanca.value);
    }
    if (pagarTicketEnCualquierBanca.present) {
      map['pagar_ticket_en_cualquier_banca'] =
          Variable<int>(pagarTicketEnCualquierBanca.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('consorcio: $consorcio, ')
          ..write('idTipoFormatoTicket: $idTipoFormatoTicket, ')
          ..write('imprimirNombreConsorcio: $imprimirNombreConsorcio, ')
          ..write(
              'descripcionTipoFormatoTicket: $descripcionTipoFormatoTicket, ')
          ..write('cancelarTicketWhatsapp: $cancelarTicketWhatsapp, ')
          ..write('imprimirNombreBanca: $imprimirNombreBanca, ')
          ..write('pagarTicketEnCualquierBanca: $pagarTicketEnCualquierBanca')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  final GeneratedDatabase _db;
  final String _alias;
  $SettingsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _consorcioMeta = const VerificationMeta('consorcio');
  GeneratedColumn<String> _consorcio;
  @override
  GeneratedColumn<String> get consorcio =>
      _consorcio ??= GeneratedColumn<String>('consorcio', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _idTipoFormatoTicketMeta =
      const VerificationMeta('idTipoFormatoTicket');
  GeneratedColumn<int> _idTipoFormatoTicket;
  @override
  GeneratedColumn<int> get idTipoFormatoTicket => _idTipoFormatoTicket ??=
      GeneratedColumn<int>('id_tipo_formato_ticket', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _imprimirNombreConsorcioMeta =
      const VerificationMeta('imprimirNombreConsorcio');
  GeneratedColumn<int> _imprimirNombreConsorcio;
  @override
  GeneratedColumn<int> get imprimirNombreConsorcio =>
      _imprimirNombreConsorcio ??= GeneratedColumn<int>(
          'imprimir_nombre_consorcio', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descripcionTipoFormatoTicketMeta =
      const VerificationMeta('descripcionTipoFormatoTicket');
  GeneratedColumn<String> _descripcionTipoFormatoTicket;
  @override
  GeneratedColumn<String> get descripcionTipoFormatoTicket =>
      _descripcionTipoFormatoTicket ??= GeneratedColumn<String>(
          'descripcion_tipo_formato_ticket', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _cancelarTicketWhatsappMeta =
      const VerificationMeta('cancelarTicketWhatsapp');
  GeneratedColumn<int> _cancelarTicketWhatsapp;
  @override
  GeneratedColumn<int> get cancelarTicketWhatsapp => _cancelarTicketWhatsapp ??=
      GeneratedColumn<int>('cancelar_ticket_whatsapp', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _imprimirNombreBancaMeta =
      const VerificationMeta('imprimirNombreBanca');
  GeneratedColumn<int> _imprimirNombreBanca;
  @override
  GeneratedColumn<int> get imprimirNombreBanca => _imprimirNombreBanca ??=
      GeneratedColumn<int>('imprimir_nombre_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _pagarTicketEnCualquierBancaMeta =
      const VerificationMeta('pagarTicketEnCualquierBanca');
  GeneratedColumn<int> _pagarTicketEnCualquierBanca;
  @override
  GeneratedColumn<int> get pagarTicketEnCualquierBanca =>
      _pagarTicketEnCualquierBanca ??= GeneratedColumn<int>(
          'pagar_ticket_en_cualquier_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        consorcio,
        idTipoFormatoTicket,
        imprimirNombreConsorcio,
        descripcionTipoFormatoTicket,
        cancelarTicketWhatsapp,
        imprimirNombreBanca,
        pagarTicketEnCualquierBanca
      ];
  @override
  String get aliasedName => _alias ?? 'settings';
  @override
  String get actualTableName => 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('consorcio')) {
      context.handle(_consorcioMeta,
          consorcio.isAcceptableOrUnknown(data['consorcio'], _consorcioMeta));
    } else if (isInserting) {
      context.missing(_consorcioMeta);
    }
    if (data.containsKey('id_tipo_formato_ticket')) {
      context.handle(
          _idTipoFormatoTicketMeta,
          idTipoFormatoTicket.isAcceptableOrUnknown(
              data['id_tipo_formato_ticket'], _idTipoFormatoTicketMeta));
    } else if (isInserting) {
      context.missing(_idTipoFormatoTicketMeta);
    }
    if (data.containsKey('imprimir_nombre_consorcio')) {
      context.handle(
          _imprimirNombreConsorcioMeta,
          imprimirNombreConsorcio.isAcceptableOrUnknown(
              data['imprimir_nombre_consorcio'], _imprimirNombreConsorcioMeta));
    } else if (isInserting) {
      context.missing(_imprimirNombreConsorcioMeta);
    }
    if (data.containsKey('descripcion_tipo_formato_ticket')) {
      context.handle(
          _descripcionTipoFormatoTicketMeta,
          descripcionTipoFormatoTicket.isAcceptableOrUnknown(
              data['descripcion_tipo_formato_ticket'],
              _descripcionTipoFormatoTicketMeta));
    } else if (isInserting) {
      context.missing(_descripcionTipoFormatoTicketMeta);
    }
    if (data.containsKey('cancelar_ticket_whatsapp')) {
      context.handle(
          _cancelarTicketWhatsappMeta,
          cancelarTicketWhatsapp.isAcceptableOrUnknown(
              data['cancelar_ticket_whatsapp'], _cancelarTicketWhatsappMeta));
    } else if (isInserting) {
      context.missing(_cancelarTicketWhatsappMeta);
    }
    if (data.containsKey('imprimir_nombre_banca')) {
      context.handle(
          _imprimirNombreBancaMeta,
          imprimirNombreBanca.isAcceptableOrUnknown(
              data['imprimir_nombre_banca'], _imprimirNombreBancaMeta));
    } else if (isInserting) {
      context.missing(_imprimirNombreBancaMeta);
    }
    if (data.containsKey('pagar_ticket_en_cualquier_banca')) {
      context.handle(
          _pagarTicketEnCualquierBancaMeta,
          pagarTicketEnCualquierBanca.isAcceptableOrUnknown(
              data['pagar_ticket_en_cualquier_banca'],
              _pagarTicketEnCualquierBancaMeta));
    } else if (isInserting) {
      context.missing(_pagarTicketEnCualquierBancaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    return Setting.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(_db, alias);
  }
}

class Branch extends DataClass implements Insertable<Branch> {
  final int id;
  final String descripcion;
  final String codigo;
  final String dueno;
  final int idUsuario;
  final double limiteVenta;
  final double descontar;
  final double deCada;
  final int minutosCancelarTicket;
  final String piepagina1;
  final String piepagina2;
  final String piepagina3;
  final String piepagina4;
  final int idMoneda;
  final String moneda;
  final String monedaAbreviatura;
  final String monedaColor;
  final int status;
  final DateTime created_at;
  final double ventasDelDia;
  final int cantidadCombinacionesJugadasPermitidasPorTicket;
  Branch(
      {@required this.id,
      @required this.descripcion,
      @required this.codigo,
      @required this.dueno,
      @required this.idUsuario,
      @required this.limiteVenta,
      @required this.descontar,
      @required this.deCada,
      @required this.minutosCancelarTicket,
      @required this.piepagina1,
      @required this.piepagina2,
      @required this.piepagina3,
      @required this.piepagina4,
      @required this.idMoneda,
      @required this.moneda,
      @required this.monedaAbreviatura,
      @required this.monedaColor,
      @required this.status,
      this.created_at,
      @required this.ventasDelDia,
      this.cantidadCombinacionesJugadasPermitidasPorTicket});
  factory Branch.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Branch(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      codigo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}codigo']),
      dueno: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dueno']),
      idUsuario: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_usuario']),
      limiteVenta: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}limite_venta']),
      descontar: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descontar']),
      deCada: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}de_cada']),
      minutosCancelarTicket: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}minutos_cancelar_ticket']),
      piepagina1: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}piepagina1']),
      piepagina2: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}piepagina2']),
      piepagina3: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}piepagina3']),
      piepagina4: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}piepagina4']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
      moneda: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}moneda']),
      monedaAbreviatura: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}moneda_abreviatura']),
      monedaColor: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}moneda_color']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      ventasDelDia: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ventas_del_dia']),
      cantidadCombinacionesJugadasPermitidasPorTicket: const IntType()
          .mapFromDatabaseResponse(data[
              '${effectivePrefix}cantidad_combinaciones_jugadas_permitidas_por_ticket']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    if (!nullToAbsent || dueno != null) {
      map['dueno'] = Variable<String>(dueno);
    }
    if (!nullToAbsent || idUsuario != null) {
      map['id_usuario'] = Variable<int>(idUsuario);
    }
    if (!nullToAbsent || limiteVenta != null) {
      map['limite_venta'] = Variable<double>(limiteVenta);
    }
    if (!nullToAbsent || descontar != null) {
      map['descontar'] = Variable<double>(descontar);
    }
    if (!nullToAbsent || deCada != null) {
      map['de_cada'] = Variable<double>(deCada);
    }
    if (!nullToAbsent || minutosCancelarTicket != null) {
      map['minutos_cancelar_ticket'] = Variable<int>(minutosCancelarTicket);
    }
    if (!nullToAbsent || piepagina1 != null) {
      map['piepagina1'] = Variable<String>(piepagina1);
    }
    if (!nullToAbsent || piepagina2 != null) {
      map['piepagina2'] = Variable<String>(piepagina2);
    }
    if (!nullToAbsent || piepagina3 != null) {
      map['piepagina3'] = Variable<String>(piepagina3);
    }
    if (!nullToAbsent || piepagina4 != null) {
      map['piepagina4'] = Variable<String>(piepagina4);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    if (!nullToAbsent || moneda != null) {
      map['moneda'] = Variable<String>(moneda);
    }
    if (!nullToAbsent || monedaAbreviatura != null) {
      map['moneda_abreviatura'] = Variable<String>(monedaAbreviatura);
    }
    if (!nullToAbsent || monedaColor != null) {
      map['moneda_color'] = Variable<String>(monedaColor);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || ventasDelDia != null) {
      map['ventas_del_dia'] = Variable<double>(ventasDelDia);
    }
    if (!nullToAbsent ||
        cantidadCombinacionesJugadasPermitidasPorTicket != null) {
      map['cantidad_combinaciones_jugadas_permitidas_por_ticket'] =
          Variable<int>(cantidadCombinacionesJugadasPermitidasPorTicket);
    }
    return map;
  }

  BranchsCompanion toCompanion(bool nullToAbsent) {
    return BranchsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      codigo:
          codigo == null && nullToAbsent ? const Value.absent() : Value(codigo),
      dueno:
          dueno == null && nullToAbsent ? const Value.absent() : Value(dueno),
      idUsuario: idUsuario == null && nullToAbsent
          ? const Value.absent()
          : Value(idUsuario),
      limiteVenta: limiteVenta == null && nullToAbsent
          ? const Value.absent()
          : Value(limiteVenta),
      descontar: descontar == null && nullToAbsent
          ? const Value.absent()
          : Value(descontar),
      deCada:
          deCada == null && nullToAbsent ? const Value.absent() : Value(deCada),
      minutosCancelarTicket: minutosCancelarTicket == null && nullToAbsent
          ? const Value.absent()
          : Value(minutosCancelarTicket),
      piepagina1: piepagina1 == null && nullToAbsent
          ? const Value.absent()
          : Value(piepagina1),
      piepagina2: piepagina2 == null && nullToAbsent
          ? const Value.absent()
          : Value(piepagina2),
      piepagina3: piepagina3 == null && nullToAbsent
          ? const Value.absent()
          : Value(piepagina3),
      piepagina4: piepagina4 == null && nullToAbsent
          ? const Value.absent()
          : Value(piepagina4),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
      moneda:
          moneda == null && nullToAbsent ? const Value.absent() : Value(moneda),
      monedaAbreviatura: monedaAbreviatura == null && nullToAbsent
          ? const Value.absent()
          : Value(monedaAbreviatura),
      monedaColor: monedaColor == null && nullToAbsent
          ? const Value.absent()
          : Value(monedaColor),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      ventasDelDia: ventasDelDia == null && nullToAbsent
          ? const Value.absent()
          : Value(ventasDelDia),
      cantidadCombinacionesJugadasPermitidasPorTicket:
          cantidadCombinacionesJugadasPermitidasPorTicket == null &&
                  nullToAbsent
              ? const Value.absent()
              : Value(cantidadCombinacionesJugadasPermitidasPorTicket),
    );
  }

  factory Branch.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Branch(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      codigo: serializer.fromJson<String>(json['codigo']),
      dueno: serializer.fromJson<String>(json['dueno']),
      idUsuario: serializer.fromJson<int>(json['idUsuario']),
      limiteVenta: serializer.fromJson<double>(json['limiteVenta']),
      descontar: serializer.fromJson<double>(json['descontar']),
      deCada: serializer.fromJson<double>(json['deCada']),
      minutosCancelarTicket:
          serializer.fromJson<int>(json['minutosCancelarTicket']),
      piepagina1: serializer.fromJson<String>(json['piepagina1']),
      piepagina2: serializer.fromJson<String>(json['piepagina2']),
      piepagina3: serializer.fromJson<String>(json['piepagina3']),
      piepagina4: serializer.fromJson<String>(json['piepagina4']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
      moneda: serializer.fromJson<String>(json['moneda']),
      monedaAbreviatura: serializer.fromJson<String>(json['monedaAbreviatura']),
      monedaColor: serializer.fromJson<String>(json['monedaColor']),
      status: serializer.fromJson<int>(json['status']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      ventasDelDia: serializer.fromJson<double>(json['ventasDelDia']),
      cantidadCombinacionesJugadasPermitidasPorTicket: serializer.fromJson<int>(
          json['cantidadCombinacionesJugadasPermitidasPorTicket']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'codigo': serializer.toJson<String>(codigo),
      'dueno': serializer.toJson<String>(dueno),
      'idUsuario': serializer.toJson<int>(idUsuario),
      'limiteVenta': serializer.toJson<double>(limiteVenta),
      'descontar': serializer.toJson<double>(descontar),
      'deCada': serializer.toJson<double>(deCada),
      'minutosCancelarTicket': serializer.toJson<int>(minutosCancelarTicket),
      'piepagina1': serializer.toJson<String>(piepagina1),
      'piepagina2': serializer.toJson<String>(piepagina2),
      'piepagina3': serializer.toJson<String>(piepagina3),
      'piepagina4': serializer.toJson<String>(piepagina4),
      'idMoneda': serializer.toJson<int>(idMoneda),
      'moneda': serializer.toJson<String>(moneda),
      'monedaAbreviatura': serializer.toJson<String>(monedaAbreviatura),
      'monedaColor': serializer.toJson<String>(monedaColor),
      'status': serializer.toJson<int>(status),
      'created_at': serializer.toJson<DateTime>(created_at),
      'ventasDelDia': serializer.toJson<double>(ventasDelDia),
      'cantidadCombinacionesJugadasPermitidasPorTicket': serializer
          .toJson<int>(cantidadCombinacionesJugadasPermitidasPorTicket),
    };
  }

  Branch copyWith(
          {int id,
          String descripcion,
          String codigo,
          String dueno,
          int idUsuario,
          double limiteVenta,
          double descontar,
          double deCada,
          int minutosCancelarTicket,
          String piepagina1,
          String piepagina2,
          String piepagina3,
          String piepagina4,
          int idMoneda,
          String moneda,
          String monedaAbreviatura,
          String monedaColor,
          int status,
          DateTime created_at,
          double ventasDelDia,
          int cantidadCombinacionesJugadasPermitidasPorTicket}) =>
      Branch(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        codigo: codigo ?? this.codigo,
        dueno: dueno ?? this.dueno,
        idUsuario: idUsuario ?? this.idUsuario,
        limiteVenta: limiteVenta ?? this.limiteVenta,
        descontar: descontar ?? this.descontar,
        deCada: deCada ?? this.deCada,
        minutosCancelarTicket:
            minutosCancelarTicket ?? this.minutosCancelarTicket,
        piepagina1: piepagina1 ?? this.piepagina1,
        piepagina2: piepagina2 ?? this.piepagina2,
        piepagina3: piepagina3 ?? this.piepagina3,
        piepagina4: piepagina4 ?? this.piepagina4,
        idMoneda: idMoneda ?? this.idMoneda,
        moneda: moneda ?? this.moneda,
        monedaAbreviatura: monedaAbreviatura ?? this.monedaAbreviatura,
        monedaColor: monedaColor ?? this.monedaColor,
        status: status ?? this.status,
        created_at: created_at ?? this.created_at,
        ventasDelDia: ventasDelDia ?? this.ventasDelDia,
        cantidadCombinacionesJugadasPermitidasPorTicket:
            cantidadCombinacionesJugadasPermitidasPorTicket ??
                this.cantidadCombinacionesJugadasPermitidasPorTicket,
      );
  @override
  String toString() {
    return (StringBuffer('Branch(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('codigo: $codigo, ')
          ..write('dueno: $dueno, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('limiteVenta: $limiteVenta, ')
          ..write('descontar: $descontar, ')
          ..write('deCada: $deCada, ')
          ..write('minutosCancelarTicket: $minutosCancelarTicket, ')
          ..write('piepagina1: $piepagina1, ')
          ..write('piepagina2: $piepagina2, ')
          ..write('piepagina3: $piepagina3, ')
          ..write('piepagina4: $piepagina4, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('moneda: $moneda, ')
          ..write('monedaAbreviatura: $monedaAbreviatura, ')
          ..write('monedaColor: $monedaColor, ')
          ..write('status: $status, ')
          ..write('created_at: $created_at, ')
          ..write('ventasDelDia: $ventasDelDia, ')
          ..write(
              'cantidadCombinacionesJugadasPermitidasPorTicket: $cantidadCombinacionesJugadasPermitidasPorTicket')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        descripcion,
        codigo,
        dueno,
        idUsuario,
        limiteVenta,
        descontar,
        deCada,
        minutosCancelarTicket,
        piepagina1,
        piepagina2,
        piepagina3,
        piepagina4,
        idMoneda,
        moneda,
        monedaAbreviatura,
        monedaColor,
        status,
        created_at,
        ventasDelDia,
        cantidadCombinacionesJugadasPermitidasPorTicket
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Branch &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.codigo == this.codigo &&
          other.dueno == this.dueno &&
          other.idUsuario == this.idUsuario &&
          other.limiteVenta == this.limiteVenta &&
          other.descontar == this.descontar &&
          other.deCada == this.deCada &&
          other.minutosCancelarTicket == this.minutosCancelarTicket &&
          other.piepagina1 == this.piepagina1 &&
          other.piepagina2 == this.piepagina2 &&
          other.piepagina3 == this.piepagina3 &&
          other.piepagina4 == this.piepagina4 &&
          other.idMoneda == this.idMoneda &&
          other.moneda == this.moneda &&
          other.monedaAbreviatura == this.monedaAbreviatura &&
          other.monedaColor == this.monedaColor &&
          other.status == this.status &&
          other.created_at == this.created_at &&
          other.ventasDelDia == this.ventasDelDia &&
          other.cantidadCombinacionesJugadasPermitidasPorTicket ==
              this.cantidadCombinacionesJugadasPermitidasPorTicket);
}

class BranchsCompanion extends UpdateCompanion<Branch> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<String> codigo;
  final Value<String> dueno;
  final Value<int> idUsuario;
  final Value<double> limiteVenta;
  final Value<double> descontar;
  final Value<double> deCada;
  final Value<int> minutosCancelarTicket;
  final Value<String> piepagina1;
  final Value<String> piepagina2;
  final Value<String> piepagina3;
  final Value<String> piepagina4;
  final Value<int> idMoneda;
  final Value<String> moneda;
  final Value<String> monedaAbreviatura;
  final Value<String> monedaColor;
  final Value<int> status;
  final Value<DateTime> created_at;
  final Value<double> ventasDelDia;
  final Value<int> cantidadCombinacionesJugadasPermitidasPorTicket;
  const BranchsCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.codigo = const Value.absent(),
    this.dueno = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.limiteVenta = const Value.absent(),
    this.descontar = const Value.absent(),
    this.deCada = const Value.absent(),
    this.minutosCancelarTicket = const Value.absent(),
    this.piepagina1 = const Value.absent(),
    this.piepagina2 = const Value.absent(),
    this.piepagina3 = const Value.absent(),
    this.piepagina4 = const Value.absent(),
    this.idMoneda = const Value.absent(),
    this.moneda = const Value.absent(),
    this.monedaAbreviatura = const Value.absent(),
    this.monedaColor = const Value.absent(),
    this.status = const Value.absent(),
    this.created_at = const Value.absent(),
    this.ventasDelDia = const Value.absent(),
    this.cantidadCombinacionesJugadasPermitidasPorTicket = const Value.absent(),
  });
  BranchsCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    @required String codigo,
    @required String dueno,
    @required int idUsuario,
    @required double limiteVenta,
    @required double descontar,
    @required double deCada,
    @required int minutosCancelarTicket,
    @required String piepagina1,
    @required String piepagina2,
    @required String piepagina3,
    @required String piepagina4,
    @required int idMoneda,
    @required String moneda,
    @required String monedaAbreviatura,
    @required String monedaColor,
    @required int status,
    this.created_at = const Value.absent(),
    @required double ventasDelDia,
    this.cantidadCombinacionesJugadasPermitidasPorTicket = const Value.absent(),
  })  : descripcion = Value(descripcion),
        codigo = Value(codigo),
        dueno = Value(dueno),
        idUsuario = Value(idUsuario),
        limiteVenta = Value(limiteVenta),
        descontar = Value(descontar),
        deCada = Value(deCada),
        minutosCancelarTicket = Value(minutosCancelarTicket),
        piepagina1 = Value(piepagina1),
        piepagina2 = Value(piepagina2),
        piepagina3 = Value(piepagina3),
        piepagina4 = Value(piepagina4),
        idMoneda = Value(idMoneda),
        moneda = Value(moneda),
        monedaAbreviatura = Value(monedaAbreviatura),
        monedaColor = Value(monedaColor),
        status = Value(status),
        ventasDelDia = Value(ventasDelDia);
  static Insertable<Branch> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<String> codigo,
    Expression<String> dueno,
    Expression<int> idUsuario,
    Expression<double> limiteVenta,
    Expression<double> descontar,
    Expression<double> deCada,
    Expression<int> minutosCancelarTicket,
    Expression<String> piepagina1,
    Expression<String> piepagina2,
    Expression<String> piepagina3,
    Expression<String> piepagina4,
    Expression<int> idMoneda,
    Expression<String> moneda,
    Expression<String> monedaAbreviatura,
    Expression<String> monedaColor,
    Expression<int> status,
    Expression<DateTime> created_at,
    Expression<double> ventasDelDia,
    Expression<int> cantidadCombinacionesJugadasPermitidasPorTicket,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (codigo != null) 'codigo': codigo,
      if (dueno != null) 'dueno': dueno,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (limiteVenta != null) 'limite_venta': limiteVenta,
      if (descontar != null) 'descontar': descontar,
      if (deCada != null) 'de_cada': deCada,
      if (minutosCancelarTicket != null)
        'minutos_cancelar_ticket': minutosCancelarTicket,
      if (piepagina1 != null) 'piepagina1': piepagina1,
      if (piepagina2 != null) 'piepagina2': piepagina2,
      if (piepagina3 != null) 'piepagina3': piepagina3,
      if (piepagina4 != null) 'piepagina4': piepagina4,
      if (idMoneda != null) 'id_moneda': idMoneda,
      if (moneda != null) 'moneda': moneda,
      if (monedaAbreviatura != null) 'moneda_abreviatura': monedaAbreviatura,
      if (monedaColor != null) 'moneda_color': monedaColor,
      if (status != null) 'status': status,
      if (created_at != null) 'created_at': created_at,
      if (ventasDelDia != null) 'ventas_del_dia': ventasDelDia,
      if (cantidadCombinacionesJugadasPermitidasPorTicket != null)
        'cantidad_combinaciones_jugadas_permitidas_por_ticket':
            cantidadCombinacionesJugadasPermitidasPorTicket,
    });
  }

  BranchsCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<String> codigo,
      Value<String> dueno,
      Value<int> idUsuario,
      Value<double> limiteVenta,
      Value<double> descontar,
      Value<double> deCada,
      Value<int> minutosCancelarTicket,
      Value<String> piepagina1,
      Value<String> piepagina2,
      Value<String> piepagina3,
      Value<String> piepagina4,
      Value<int> idMoneda,
      Value<String> moneda,
      Value<String> monedaAbreviatura,
      Value<String> monedaColor,
      Value<int> status,
      Value<DateTime> created_at,
      Value<double> ventasDelDia,
      Value<int> cantidadCombinacionesJugadasPermitidasPorTicket}) {
    return BranchsCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      codigo: codigo ?? this.codigo,
      dueno: dueno ?? this.dueno,
      idUsuario: idUsuario ?? this.idUsuario,
      limiteVenta: limiteVenta ?? this.limiteVenta,
      descontar: descontar ?? this.descontar,
      deCada: deCada ?? this.deCada,
      minutosCancelarTicket:
          minutosCancelarTicket ?? this.minutosCancelarTicket,
      piepagina1: piepagina1 ?? this.piepagina1,
      piepagina2: piepagina2 ?? this.piepagina2,
      piepagina3: piepagina3 ?? this.piepagina3,
      piepagina4: piepagina4 ?? this.piepagina4,
      idMoneda: idMoneda ?? this.idMoneda,
      moneda: moneda ?? this.moneda,
      monedaAbreviatura: monedaAbreviatura ?? this.monedaAbreviatura,
      monedaColor: monedaColor ?? this.monedaColor,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      ventasDelDia: ventasDelDia ?? this.ventasDelDia,
      cantidadCombinacionesJugadasPermitidasPorTicket:
          cantidadCombinacionesJugadasPermitidasPorTicket ??
              this.cantidadCombinacionesJugadasPermitidasPorTicket,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (dueno.present) {
      map['dueno'] = Variable<String>(dueno.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int>(idUsuario.value);
    }
    if (limiteVenta.present) {
      map['limite_venta'] = Variable<double>(limiteVenta.value);
    }
    if (descontar.present) {
      map['descontar'] = Variable<double>(descontar.value);
    }
    if (deCada.present) {
      map['de_cada'] = Variable<double>(deCada.value);
    }
    if (minutosCancelarTicket.present) {
      map['minutos_cancelar_ticket'] =
          Variable<int>(minutosCancelarTicket.value);
    }
    if (piepagina1.present) {
      map['piepagina1'] = Variable<String>(piepagina1.value);
    }
    if (piepagina2.present) {
      map['piepagina2'] = Variable<String>(piepagina2.value);
    }
    if (piepagina3.present) {
      map['piepagina3'] = Variable<String>(piepagina3.value);
    }
    if (piepagina4.present) {
      map['piepagina4'] = Variable<String>(piepagina4.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (monedaAbreviatura.present) {
      map['moneda_abreviatura'] = Variable<String>(monedaAbreviatura.value);
    }
    if (monedaColor.present) {
      map['moneda_color'] = Variable<String>(monedaColor.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (ventasDelDia.present) {
      map['ventas_del_dia'] = Variable<double>(ventasDelDia.value);
    }
    if (cantidadCombinacionesJugadasPermitidasPorTicket.present) {
      map['cantidad_combinaciones_jugadas_permitidas_por_ticket'] =
          Variable<int>(cantidadCombinacionesJugadasPermitidasPorTicket.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchsCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('codigo: $codigo, ')
          ..write('dueno: $dueno, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('limiteVenta: $limiteVenta, ')
          ..write('descontar: $descontar, ')
          ..write('deCada: $deCada, ')
          ..write('minutosCancelarTicket: $minutosCancelarTicket, ')
          ..write('piepagina1: $piepagina1, ')
          ..write('piepagina2: $piepagina2, ')
          ..write('piepagina3: $piepagina3, ')
          ..write('piepagina4: $piepagina4, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('moneda: $moneda, ')
          ..write('monedaAbreviatura: $monedaAbreviatura, ')
          ..write('monedaColor: $monedaColor, ')
          ..write('status: $status, ')
          ..write('created_at: $created_at, ')
          ..write('ventasDelDia: $ventasDelDia, ')
          ..write(
              'cantidadCombinacionesJugadasPermitidasPorTicket: $cantidadCombinacionesJugadasPermitidasPorTicket')
          ..write(')'))
        .toString();
  }
}

class $BranchsTable extends Branchs with TableInfo<$BranchsTable, Branch> {
  final GeneratedDatabase _db;
  final String _alias;
  $BranchsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  GeneratedColumn<String> _codigo;
  @override
  GeneratedColumn<String> get codigo =>
      _codigo ??= GeneratedColumn<String>('codigo', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _duenoMeta = const VerificationMeta('dueno');
  GeneratedColumn<String> _dueno;
  @override
  GeneratedColumn<String> get dueno =>
      _dueno ??= GeneratedColumn<String>('dueno', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _idUsuarioMeta = const VerificationMeta('idUsuario');
  GeneratedColumn<int> _idUsuario;
  @override
  GeneratedColumn<int> get idUsuario =>
      _idUsuario ??= GeneratedColumn<int>('id_usuario', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _limiteVentaMeta =
      const VerificationMeta('limiteVenta');
  GeneratedColumn<double> _limiteVenta;
  @override
  GeneratedColumn<double> get limiteVenta => _limiteVenta ??=
      GeneratedColumn<double>('limite_venta', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _descontarMeta = const VerificationMeta('descontar');
  GeneratedColumn<double> _descontar;
  @override
  GeneratedColumn<double> get descontar =>
      _descontar ??= GeneratedColumn<double>('descontar', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _deCadaMeta = const VerificationMeta('deCada');
  GeneratedColumn<double> _deCada;
  @override
  GeneratedColumn<double> get deCada =>
      _deCada ??= GeneratedColumn<double>('de_cada', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _minutosCancelarTicketMeta =
      const VerificationMeta('minutosCancelarTicket');
  GeneratedColumn<int> _minutosCancelarTicket;
  @override
  GeneratedColumn<int> get minutosCancelarTicket => _minutosCancelarTicket ??=
      GeneratedColumn<int>('minutos_cancelar_ticket', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _piepagina1Meta = const VerificationMeta('piepagina1');
  GeneratedColumn<String> _piepagina1;
  @override
  GeneratedColumn<String> get piepagina1 =>
      _piepagina1 ??= GeneratedColumn<String>('piepagina1', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _piepagina2Meta = const VerificationMeta('piepagina2');
  GeneratedColumn<String> _piepagina2;
  @override
  GeneratedColumn<String> get piepagina2 =>
      _piepagina2 ??= GeneratedColumn<String>('piepagina2', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _piepagina3Meta = const VerificationMeta('piepagina3');
  GeneratedColumn<String> _piepagina3;
  @override
  GeneratedColumn<String> get piepagina3 =>
      _piepagina3 ??= GeneratedColumn<String>('piepagina3', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _piepagina4Meta = const VerificationMeta('piepagina4');
  GeneratedColumn<String> _piepagina4;
  @override
  GeneratedColumn<String> get piepagina4 =>
      _piepagina4 ??= GeneratedColumn<String>('piepagina4', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  GeneratedColumn<String> _moneda;
  @override
  GeneratedColumn<String> get moneda =>
      _moneda ??= GeneratedColumn<String>('moneda', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _monedaAbreviaturaMeta =
      const VerificationMeta('monedaAbreviatura');
  GeneratedColumn<String> _monedaAbreviatura;
  @override
  GeneratedColumn<String> get monedaAbreviatura => _monedaAbreviatura ??=
      GeneratedColumn<String>('moneda_abreviatura', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _monedaColorMeta =
      const VerificationMeta('monedaColor');
  GeneratedColumn<String> _monedaColor;
  @override
  GeneratedColumn<String> get monedaColor => _monedaColor ??=
      GeneratedColumn<String>('moneda_color', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _ventasDelDiaMeta =
      const VerificationMeta('ventasDelDia');
  GeneratedColumn<double> _ventasDelDia;
  @override
  GeneratedColumn<double> get ventasDelDia => _ventasDelDia ??=
      GeneratedColumn<double>('ventas_del_dia', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _cantidadCombinacionesJugadasPermitidasPorTicketMeta =
      const VerificationMeta('cantidadCombinacionesJugadasPermitidasPorTicket');
  GeneratedColumn<int> _cantidadCombinacionesJugadasPermitidasPorTicket;
  @override
  GeneratedColumn<int> get cantidadCombinacionesJugadasPermitidasPorTicket =>
      _cantidadCombinacionesJugadasPermitidasPorTicket ??= GeneratedColumn<int>(
          'cantidad_combinaciones_jugadas_permitidas_por_ticket',
          aliasedName,
          true,
          typeName: 'INTEGER',
          requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        descripcion,
        codigo,
        dueno,
        idUsuario,
        limiteVenta,
        descontar,
        deCada,
        minutosCancelarTicket,
        piepagina1,
        piepagina2,
        piepagina3,
        piepagina4,
        idMoneda,
        moneda,
        monedaAbreviatura,
        monedaColor,
        status,
        created_at,
        ventasDelDia,
        cantidadCombinacionesJugadasPermitidasPorTicket
      ];
  @override
  String get aliasedName => _alias ?? 'branchs';
  @override
  String get actualTableName => 'branchs';
  @override
  VerificationContext validateIntegrity(Insertable<Branch> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo'], _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('dueno')) {
      context.handle(
          _duenoMeta, dueno.isAcceptableOrUnknown(data['dueno'], _duenoMeta));
    } else if (isInserting) {
      context.missing(_duenoMeta);
    }
    if (data.containsKey('id_usuario')) {
      context.handle(_idUsuarioMeta,
          idUsuario.isAcceptableOrUnknown(data['id_usuario'], _idUsuarioMeta));
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('limite_venta')) {
      context.handle(
          _limiteVentaMeta,
          limiteVenta.isAcceptableOrUnknown(
              data['limite_venta'], _limiteVentaMeta));
    } else if (isInserting) {
      context.missing(_limiteVentaMeta);
    }
    if (data.containsKey('descontar')) {
      context.handle(_descontarMeta,
          descontar.isAcceptableOrUnknown(data['descontar'], _descontarMeta));
    } else if (isInserting) {
      context.missing(_descontarMeta);
    }
    if (data.containsKey('de_cada')) {
      context.handle(_deCadaMeta,
          deCada.isAcceptableOrUnknown(data['de_cada'], _deCadaMeta));
    } else if (isInserting) {
      context.missing(_deCadaMeta);
    }
    if (data.containsKey('minutos_cancelar_ticket')) {
      context.handle(
          _minutosCancelarTicketMeta,
          minutosCancelarTicket.isAcceptableOrUnknown(
              data['minutos_cancelar_ticket'], _minutosCancelarTicketMeta));
    } else if (isInserting) {
      context.missing(_minutosCancelarTicketMeta);
    }
    if (data.containsKey('piepagina1')) {
      context.handle(
          _piepagina1Meta,
          piepagina1.isAcceptableOrUnknown(
              data['piepagina1'], _piepagina1Meta));
    } else if (isInserting) {
      context.missing(_piepagina1Meta);
    }
    if (data.containsKey('piepagina2')) {
      context.handle(
          _piepagina2Meta,
          piepagina2.isAcceptableOrUnknown(
              data['piepagina2'], _piepagina2Meta));
    } else if (isInserting) {
      context.missing(_piepagina2Meta);
    }
    if (data.containsKey('piepagina3')) {
      context.handle(
          _piepagina3Meta,
          piepagina3.isAcceptableOrUnknown(
              data['piepagina3'], _piepagina3Meta));
    } else if (isInserting) {
      context.missing(_piepagina3Meta);
    }
    if (data.containsKey('piepagina4')) {
      context.handle(
          _piepagina4Meta,
          piepagina4.isAcceptableOrUnknown(
              data['piepagina4'], _piepagina4Meta));
    } else if (isInserting) {
      context.missing(_piepagina4Meta);
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    if (data.containsKey('moneda')) {
      context.handle(_monedaMeta,
          moneda.isAcceptableOrUnknown(data['moneda'], _monedaMeta));
    } else if (isInserting) {
      context.missing(_monedaMeta);
    }
    if (data.containsKey('moneda_abreviatura')) {
      context.handle(
          _monedaAbreviaturaMeta,
          monedaAbreviatura.isAcceptableOrUnknown(
              data['moneda_abreviatura'], _monedaAbreviaturaMeta));
    } else if (isInserting) {
      context.missing(_monedaAbreviaturaMeta);
    }
    if (data.containsKey('moneda_color')) {
      context.handle(
          _monedaColorMeta,
          monedaColor.isAcceptableOrUnknown(
              data['moneda_color'], _monedaColorMeta));
    } else if (isInserting) {
      context.missing(_monedaColorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('ventas_del_dia')) {
      context.handle(
          _ventasDelDiaMeta,
          ventasDelDia.isAcceptableOrUnknown(
              data['ventas_del_dia'], _ventasDelDiaMeta));
    } else if (isInserting) {
      context.missing(_ventasDelDiaMeta);
    }
    if (data
        .containsKey('cantidad_combinaciones_jugadas_permitidas_por_ticket')) {
      context.handle(
          _cantidadCombinacionesJugadasPermitidasPorTicketMeta,
          cantidadCombinacionesJugadasPermitidasPorTicket.isAcceptableOrUnknown(
              data['cantidad_combinaciones_jugadas_permitidas_por_ticket'],
              _cantidadCombinacionesJugadasPermitidasPorTicketMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Branch map(Map<String, dynamic> data, {String tablePrefix}) {
    return Branch.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BranchsTable createAlias(String alias) {
    return $BranchsTable(_db, alias);
  }
}

class Server extends DataClass implements Insertable<Server> {
  final int id;
  final String descripcion;
  final DateTime created_at;
  final int pordefecto;
  Server(
      {@required this.id,
      @required this.descripcion,
      this.created_at,
      @required this.pordefecto});
  factory Server.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Server(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      pordefecto: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pordefecto']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || pordefecto != null) {
      map['pordefecto'] = Variable<int>(pordefecto);
    }
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      pordefecto: pordefecto == null && nullToAbsent
          ? const Value.absent()
          : Value(pordefecto),
    );
  }

  factory Server.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      pordefecto: serializer.fromJson<int>(json['pordefecto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'created_at': serializer.toJson<DateTime>(created_at),
      'pordefecto': serializer.toJson<int>(pordefecto),
    };
  }

  Server copyWith(
          {int id, String descripcion, DateTime created_at, int pordefecto}) =>
      Server(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        created_at: created_at ?? this.created_at,
        pordefecto: pordefecto ?? this.pordefecto,
      );
  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('pordefecto: $pordefecto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, descripcion, created_at, pordefecto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.created_at == this.created_at &&
          other.pordefecto == this.pordefecto);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<DateTime> created_at;
  final Value<int> pordefecto;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.created_at = const Value.absent(),
    this.pordefecto = const Value.absent(),
  });
  ServersCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    this.created_at = const Value.absent(),
    @required int pordefecto,
  })  : descripcion = Value(descripcion),
        pordefecto = Value(pordefecto);
  static Insertable<Server> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<DateTime> created_at,
    Expression<int> pordefecto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (created_at != null) 'created_at': created_at,
      if (pordefecto != null) 'pordefecto': pordefecto,
    });
  }

  ServersCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<DateTime> created_at,
      Value<int> pordefecto}) {
    return ServersCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      created_at: created_at ?? this.created_at,
      pordefecto: pordefecto ?? this.pordefecto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (pordefecto.present) {
      map['pordefecto'] = Variable<int>(pordefecto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('pordefecto: $pordefecto')
          ..write(')'))
        .toString();
  }
}

class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  final GeneratedDatabase _db;
  final String _alias;
  $ServersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _pordefectoMeta = const VerificationMeta('pordefecto');
  GeneratedColumn<int> _pordefecto;
  @override
  GeneratedColumn<int> get pordefecto =>
      _pordefecto ??= GeneratedColumn<int>('pordefecto', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descripcion, created_at, pordefecto];
  @override
  String get aliasedName => _alias ?? 'servers';
  @override
  String get actualTableName => 'servers';
  @override
  VerificationContext validateIntegrity(Insertable<Server> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('pordefecto')) {
      context.handle(
          _pordefectoMeta,
          pordefecto.isAcceptableOrUnknown(
              data['pordefecto'], _pordefectoMeta));
    } else if (isInserting) {
      context.missing(_pordefectoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String tablePrefix}) {
    return Server.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(_db, alias);
  }
}

class Stock extends DataClass implements Insertable<Stock> {
  final int id;
  final int idBanca;
  final int idLoteria;
  final int idLoteriaSuperpale;
  final int idSorteo;
  final String jugada;
  final double montoInicial;
  final double monto;
  final DateTime created_at;
  final int esBloqueoJugada;
  final int esGeneral;
  final int ignorarDemasBloqueos;
  final int idMoneda;
  final int descontarDelBloqueoGeneral;
  Stock(
      {@required this.id,
      @required this.idBanca,
      @required this.idLoteria,
      this.idLoteriaSuperpale,
      @required this.idSorteo,
      @required this.jugada,
      @required this.montoInicial,
      @required this.monto,
      this.created_at,
      @required this.esBloqueoJugada,
      @required this.esGeneral,
      @required this.ignorarDemasBloqueos,
      @required this.idMoneda,
      @required this.descontarDelBloqueoGeneral});
  factory Stock.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Stock(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idBanca: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_banca']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idLoteriaSuperpale: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_loteria_superpale']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      jugada: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}jugada']),
      montoInicial: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto_inicial']),
      monto: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      esBloqueoJugada: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}es_bloqueo_jugada']),
      esGeneral: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}es_general']),
      ignorarDemasBloqueos: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}ignorar_demas_bloqueos']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
      descontarDelBloqueoGeneral: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}descontar_del_bloqueo_general']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idBanca != null) {
      map['id_banca'] = Variable<int>(idBanca);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idLoteriaSuperpale != null) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || jugada != null) {
      map['jugada'] = Variable<String>(jugada);
    }
    if (!nullToAbsent || montoInicial != null) {
      map['monto_inicial'] = Variable<double>(montoInicial);
    }
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || esBloqueoJugada != null) {
      map['es_bloqueo_jugada'] = Variable<int>(esBloqueoJugada);
    }
    if (!nullToAbsent || esGeneral != null) {
      map['es_general'] = Variable<int>(esGeneral);
    }
    if (!nullToAbsent || ignorarDemasBloqueos != null) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    if (!nullToAbsent || descontarDelBloqueoGeneral != null) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral);
    }
    return map;
  }

  StocksCompanion toCompanion(bool nullToAbsent) {
    return StocksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idBanca: idBanca == null && nullToAbsent
          ? const Value.absent()
          : Value(idBanca),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idLoteriaSuperpale: idLoteriaSuperpale == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteriaSuperpale),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      jugada:
          jugada == null && nullToAbsent ? const Value.absent() : Value(jugada),
      montoInicial: montoInicial == null && nullToAbsent
          ? const Value.absent()
          : Value(montoInicial),
      monto:
          monto == null && nullToAbsent ? const Value.absent() : Value(monto),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      esBloqueoJugada: esBloqueoJugada == null && nullToAbsent
          ? const Value.absent()
          : Value(esBloqueoJugada),
      esGeneral: esGeneral == null && nullToAbsent
          ? const Value.absent()
          : Value(esGeneral),
      ignorarDemasBloqueos: ignorarDemasBloqueos == null && nullToAbsent
          ? const Value.absent()
          : Value(ignorarDemasBloqueos),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral == null && nullToAbsent
              ? const Value.absent()
              : Value(descontarDelBloqueoGeneral),
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stock(
      id: serializer.fromJson<int>(json['id']),
      idBanca: serializer.fromJson<int>(json['idBanca']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idLoteriaSuperpale: serializer.fromJson<int>(json['idLoteriaSuperpale']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      jugada: serializer.fromJson<String>(json['jugada']),
      montoInicial: serializer.fromJson<double>(json['montoInicial']),
      monto: serializer.fromJson<double>(json['monto']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      esBloqueoJugada: serializer.fromJson<int>(json['esBloqueoJugada']),
      esGeneral: serializer.fromJson<int>(json['esGeneral']),
      ignorarDemasBloqueos:
          serializer.fromJson<int>(json['ignorarDemasBloqueos']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
      descontarDelBloqueoGeneral:
          serializer.fromJson<int>(json['descontarDelBloqueoGeneral']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBanca': serializer.toJson<int>(idBanca),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idLoteriaSuperpale': serializer.toJson<int>(idLoteriaSuperpale),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'jugada': serializer.toJson<String>(jugada),
      'montoInicial': serializer.toJson<double>(montoInicial),
      'monto': serializer.toJson<double>(monto),
      'created_at': serializer.toJson<DateTime>(created_at),
      'esBloqueoJugada': serializer.toJson<int>(esBloqueoJugada),
      'esGeneral': serializer.toJson<int>(esGeneral),
      'ignorarDemasBloqueos': serializer.toJson<int>(ignorarDemasBloqueos),
      'idMoneda': serializer.toJson<int>(idMoneda),
      'descontarDelBloqueoGeneral':
          serializer.toJson<int>(descontarDelBloqueoGeneral),
    };
  }

  Stock copyWith(
          {int id,
          int idBanca,
          int idLoteria,
          int idLoteriaSuperpale,
          int idSorteo,
          String jugada,
          double montoInicial,
          double monto,
          DateTime created_at,
          int esBloqueoJugada,
          int esGeneral,
          int ignorarDemasBloqueos,
          int idMoneda,
          int descontarDelBloqueoGeneral}) =>
      Stock(
        id: id ?? this.id,
        idBanca: idBanca ?? this.idBanca,
        idLoteria: idLoteria ?? this.idLoteria,
        idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
        idSorteo: idSorteo ?? this.idSorteo,
        jugada: jugada ?? this.jugada,
        montoInicial: montoInicial ?? this.montoInicial,
        monto: monto ?? this.monto,
        created_at: created_at ?? this.created_at,
        esBloqueoJugada: esBloqueoJugada ?? this.esBloqueoJugada,
        esGeneral: esGeneral ?? this.esGeneral,
        ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
        idMoneda: idMoneda ?? this.idMoneda,
        descontarDelBloqueoGeneral:
            descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
      );
  @override
  String toString() {
    return (StringBuffer('Stock(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('esBloqueoJugada: $esBloqueoJugada, ')
          ..write('esGeneral: $esGeneral, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      idBanca,
      idLoteria,
      idLoteriaSuperpale,
      idSorteo,
      jugada,
      montoInicial,
      monto,
      created_at,
      esBloqueoJugada,
      esGeneral,
      ignorarDemasBloqueos,
      idMoneda,
      descontarDelBloqueoGeneral);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stock &&
          other.id == this.id &&
          other.idBanca == this.idBanca &&
          other.idLoteria == this.idLoteria &&
          other.idLoteriaSuperpale == this.idLoteriaSuperpale &&
          other.idSorteo == this.idSorteo &&
          other.jugada == this.jugada &&
          other.montoInicial == this.montoInicial &&
          other.monto == this.monto &&
          other.created_at == this.created_at &&
          other.esBloqueoJugada == this.esBloqueoJugada &&
          other.esGeneral == this.esGeneral &&
          other.ignorarDemasBloqueos == this.ignorarDemasBloqueos &&
          other.idMoneda == this.idMoneda &&
          other.descontarDelBloqueoGeneral == this.descontarDelBloqueoGeneral);
}

class StocksCompanion extends UpdateCompanion<Stock> {
  final Value<int> id;
  final Value<int> idBanca;
  final Value<int> idLoteria;
  final Value<int> idLoteriaSuperpale;
  final Value<int> idSorteo;
  final Value<String> jugada;
  final Value<double> montoInicial;
  final Value<double> monto;
  final Value<DateTime> created_at;
  final Value<int> esBloqueoJugada;
  final Value<int> esGeneral;
  final Value<int> ignorarDemasBloqueos;
  final Value<int> idMoneda;
  final Value<int> descontarDelBloqueoGeneral;
  const StocksCompanion({
    this.id = const Value.absent(),
    this.idBanca = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idLoteriaSuperpale = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.jugada = const Value.absent(),
    this.montoInicial = const Value.absent(),
    this.monto = const Value.absent(),
    this.created_at = const Value.absent(),
    this.esBloqueoJugada = const Value.absent(),
    this.esGeneral = const Value.absent(),
    this.ignorarDemasBloqueos = const Value.absent(),
    this.idMoneda = const Value.absent(),
    this.descontarDelBloqueoGeneral = const Value.absent(),
  });
  StocksCompanion.insert({
    this.id = const Value.absent(),
    @required int idBanca,
    @required int idLoteria,
    this.idLoteriaSuperpale = const Value.absent(),
    @required int idSorteo,
    @required String jugada,
    @required double montoInicial,
    @required double monto,
    this.created_at = const Value.absent(),
    @required int esBloqueoJugada,
    @required int esGeneral,
    @required int ignorarDemasBloqueos,
    @required int idMoneda,
    @required int descontarDelBloqueoGeneral,
  })  : idBanca = Value(idBanca),
        idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        jugada = Value(jugada),
        montoInicial = Value(montoInicial),
        monto = Value(monto),
        esBloqueoJugada = Value(esBloqueoJugada),
        esGeneral = Value(esGeneral),
        ignorarDemasBloqueos = Value(ignorarDemasBloqueos),
        idMoneda = Value(idMoneda),
        descontarDelBloqueoGeneral = Value(descontarDelBloqueoGeneral);
  static Insertable<Stock> custom({
    Expression<int> id,
    Expression<int> idBanca,
    Expression<int> idLoteria,
    Expression<int> idLoteriaSuperpale,
    Expression<int> idSorteo,
    Expression<String> jugada,
    Expression<double> montoInicial,
    Expression<double> monto,
    Expression<DateTime> created_at,
    Expression<int> esBloqueoJugada,
    Expression<int> esGeneral,
    Expression<int> ignorarDemasBloqueos,
    Expression<int> idMoneda,
    Expression<int> descontarDelBloqueoGeneral,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBanca != null) 'id_banca': idBanca,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idLoteriaSuperpale != null)
        'id_loteria_superpale': idLoteriaSuperpale,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (jugada != null) 'jugada': jugada,
      if (montoInicial != null) 'monto_inicial': montoInicial,
      if (monto != null) 'monto': monto,
      if (created_at != null) 'created_at': created_at,
      if (esBloqueoJugada != null) 'es_bloqueo_jugada': esBloqueoJugada,
      if (esGeneral != null) 'es_general': esGeneral,
      if (ignorarDemasBloqueos != null)
        'ignorar_demas_bloqueos': ignorarDemasBloqueos,
      if (idMoneda != null) 'id_moneda': idMoneda,
      if (descontarDelBloqueoGeneral != null)
        'descontar_del_bloqueo_general': descontarDelBloqueoGeneral,
    });
  }

  StocksCompanion copyWith(
      {Value<int> id,
      Value<int> idBanca,
      Value<int> idLoteria,
      Value<int> idLoteriaSuperpale,
      Value<int> idSorteo,
      Value<String> jugada,
      Value<double> montoInicial,
      Value<double> monto,
      Value<DateTime> created_at,
      Value<int> esBloqueoJugada,
      Value<int> esGeneral,
      Value<int> ignorarDemasBloqueos,
      Value<int> idMoneda,
      Value<int> descontarDelBloqueoGeneral}) {
    return StocksCompanion(
      id: id ?? this.id,
      idBanca: idBanca ?? this.idBanca,
      idLoteria: idLoteria ?? this.idLoteria,
      idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
      idSorteo: idSorteo ?? this.idSorteo,
      jugada: jugada ?? this.jugada,
      montoInicial: montoInicial ?? this.montoInicial,
      monto: monto ?? this.monto,
      created_at: created_at ?? this.created_at,
      esBloqueoJugada: esBloqueoJugada ?? this.esBloqueoJugada,
      esGeneral: esGeneral ?? this.esGeneral,
      ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
      idMoneda: idMoneda ?? this.idMoneda,
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBanca.present) {
      map['id_banca'] = Variable<int>(idBanca.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idLoteriaSuperpale.present) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (jugada.present) {
      map['jugada'] = Variable<String>(jugada.value);
    }
    if (montoInicial.present) {
      map['monto_inicial'] = Variable<double>(montoInicial.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (esBloqueoJugada.present) {
      map['es_bloqueo_jugada'] = Variable<int>(esBloqueoJugada.value);
    }
    if (esGeneral.present) {
      map['es_general'] = Variable<int>(esGeneral.value);
    }
    if (ignorarDemasBloqueos.present) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    if (descontarDelBloqueoGeneral.present) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksCompanion(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('esBloqueoJugada: $esBloqueoJugada, ')
          ..write('esGeneral: $esGeneral, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral')
          ..write(')'))
        .toString();
  }
}

class $StocksTable extends Stocks with TableInfo<$StocksTable, Stock> {
  final GeneratedDatabase _db;
  final String _alias;
  $StocksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idBancaMeta = const VerificationMeta('idBanca');
  GeneratedColumn<int> _idBanca;
  @override
  GeneratedColumn<int> get idBanca =>
      _idBanca ??= GeneratedColumn<int>('id_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaSuperpaleMeta =
      const VerificationMeta('idLoteriaSuperpale');
  GeneratedColumn<int> _idLoteriaSuperpale;
  @override
  GeneratedColumn<int> get idLoteriaSuperpale => _idLoteriaSuperpale ??=
      GeneratedColumn<int>('id_loteria_superpale', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _jugadaMeta = const VerificationMeta('jugada');
  GeneratedColumn<String> _jugada;
  @override
  GeneratedColumn<String> get jugada =>
      _jugada ??= GeneratedColumn<String>('jugada', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _montoInicialMeta =
      const VerificationMeta('montoInicial');
  GeneratedColumn<double> _montoInicial;
  @override
  GeneratedColumn<double> get montoInicial => _montoInicial ??=
      GeneratedColumn<double>('monto_inicial', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _montoMeta = const VerificationMeta('monto');
  GeneratedColumn<double> _monto;
  @override
  GeneratedColumn<double> get monto =>
      _monto ??= GeneratedColumn<double>('monto', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _esBloqueoJugadaMeta =
      const VerificationMeta('esBloqueoJugada');
  GeneratedColumn<int> _esBloqueoJugada;
  @override
  GeneratedColumn<int> get esBloqueoJugada => _esBloqueoJugada ??=
      GeneratedColumn<int>('es_bloqueo_jugada', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _esGeneralMeta = const VerificationMeta('esGeneral');
  GeneratedColumn<int> _esGeneral;
  @override
  GeneratedColumn<int> get esGeneral =>
      _esGeneral ??= GeneratedColumn<int>('es_general', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _ignorarDemasBloqueosMeta =
      const VerificationMeta('ignorarDemasBloqueos');
  GeneratedColumn<int> _ignorarDemasBloqueos;
  @override
  GeneratedColumn<int> get ignorarDemasBloqueos => _ignorarDemasBloqueos ??=
      GeneratedColumn<int>('ignorar_demas_bloqueos', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descontarDelBloqueoGeneralMeta =
      const VerificationMeta('descontarDelBloqueoGeneral');
  GeneratedColumn<int> _descontarDelBloqueoGeneral;
  @override
  GeneratedColumn<int> get descontarDelBloqueoGeneral =>
      _descontarDelBloqueoGeneral ??= GeneratedColumn<int>(
          'descontar_del_bloqueo_general', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idBanca,
        idLoteria,
        idLoteriaSuperpale,
        idSorteo,
        jugada,
        montoInicial,
        monto,
        created_at,
        esBloqueoJugada,
        esGeneral,
        ignorarDemasBloqueos,
        idMoneda,
        descontarDelBloqueoGeneral
      ];
  @override
  String get aliasedName => _alias ?? 'stocks';
  @override
  String get actualTableName => 'stocks';
  @override
  VerificationContext validateIntegrity(Insertable<Stock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_banca')) {
      context.handle(_idBancaMeta,
          idBanca.isAcceptableOrUnknown(data['id_banca'], _idBancaMeta));
    } else if (isInserting) {
      context.missing(_idBancaMeta);
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_loteria_superpale')) {
      context.handle(
          _idLoteriaSuperpaleMeta,
          idLoteriaSuperpale.isAcceptableOrUnknown(
              data['id_loteria_superpale'], _idLoteriaSuperpaleMeta));
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('jugada')) {
      context.handle(_jugadaMeta,
          jugada.isAcceptableOrUnknown(data['jugada'], _jugadaMeta));
    } else if (isInserting) {
      context.missing(_jugadaMeta);
    }
    if (data.containsKey('monto_inicial')) {
      context.handle(
          _montoInicialMeta,
          montoInicial.isAcceptableOrUnknown(
              data['monto_inicial'], _montoInicialMeta));
    } else if (isInserting) {
      context.missing(_montoInicialMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto'], _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('es_bloqueo_jugada')) {
      context.handle(
          _esBloqueoJugadaMeta,
          esBloqueoJugada.isAcceptableOrUnknown(
              data['es_bloqueo_jugada'], _esBloqueoJugadaMeta));
    } else if (isInserting) {
      context.missing(_esBloqueoJugadaMeta);
    }
    if (data.containsKey('es_general')) {
      context.handle(_esGeneralMeta,
          esGeneral.isAcceptableOrUnknown(data['es_general'], _esGeneralMeta));
    } else if (isInserting) {
      context.missing(_esGeneralMeta);
    }
    if (data.containsKey('ignorar_demas_bloqueos')) {
      context.handle(
          _ignorarDemasBloqueosMeta,
          ignorarDemasBloqueos.isAcceptableOrUnknown(
              data['ignorar_demas_bloqueos'], _ignorarDemasBloqueosMeta));
    } else if (isInserting) {
      context.missing(_ignorarDemasBloqueosMeta);
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    if (data.containsKey('descontar_del_bloqueo_general')) {
      context.handle(
          _descontarDelBloqueoGeneralMeta,
          descontarDelBloqueoGeneral.isAcceptableOrUnknown(
              data['descontar_del_bloqueo_general'],
              _descontarDelBloqueoGeneralMeta));
    } else if (isInserting) {
      context.missing(_descontarDelBloqueoGeneralMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stock map(Map<String, dynamic> data, {String tablePrefix}) {
    return Stock.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $StocksTable createAlias(String alias) {
    return $StocksTable(_db, alias);
  }
}

class Blocksgeneral extends DataClass implements Insertable<Blocksgeneral> {
  final int id;
  final int idDia;
  final int idLoteria;
  final int idSorteo;
  final double monto;
  final DateTime created_at;
  final int idMoneda;
  final int idLoteriaSuperpale;
  Blocksgeneral(
      {@required this.id,
      @required this.idDia,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.monto,
      this.created_at,
      @required this.idMoneda,
      this.idLoteriaSuperpale});
  factory Blocksgeneral.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blocksgeneral(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idDia: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_dia']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      monto: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
      idLoteriaSuperpale: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_loteria_superpale']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idDia != null) {
      map['id_dia'] = Variable<int>(idDia);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    if (!nullToAbsent || idLoteriaSuperpale != null) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale);
    }
    return map;
  }

  BlocksgeneralsCompanion toCompanion(bool nullToAbsent) {
    return BlocksgeneralsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idDia:
          idDia == null && nullToAbsent ? const Value.absent() : Value(idDia),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      monto:
          monto == null && nullToAbsent ? const Value.absent() : Value(monto),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
      idLoteriaSuperpale: idLoteriaSuperpale == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteriaSuperpale),
    );
  }

  factory Blocksgeneral.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blocksgeneral(
      id: serializer.fromJson<int>(json['id']),
      idDia: serializer.fromJson<int>(json['idDia']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      monto: serializer.fromJson<double>(json['monto']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
      idLoteriaSuperpale: serializer.fromJson<int>(json['idLoteriaSuperpale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idDia': serializer.toJson<int>(idDia),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'monto': serializer.toJson<double>(monto),
      'created_at': serializer.toJson<DateTime>(created_at),
      'idMoneda': serializer.toJson<int>(idMoneda),
      'idLoteriaSuperpale': serializer.toJson<int>(idLoteriaSuperpale),
    };
  }

  Blocksgeneral copyWith(
          {int id,
          int idDia,
          int idLoteria,
          int idSorteo,
          double monto,
          DateTime created_at,
          int idMoneda,
          int idLoteriaSuperpale}) =>
      Blocksgeneral(
        id: id ?? this.id,
        idDia: idDia ?? this.idDia,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        monto: monto ?? this.monto,
        created_at: created_at ?? this.created_at,
        idMoneda: idMoneda ?? this.idMoneda,
        idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
      );
  @override
  String toString() {
    return (StringBuffer('Blocksgeneral(')
          ..write('id: $id, ')
          ..write('idDia: $idDia, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idDia, idLoteria, idSorteo, monto,
      created_at, idMoneda, idLoteriaSuperpale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocksgeneral &&
          other.id == this.id &&
          other.idDia == this.idDia &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.monto == this.monto &&
          other.created_at == this.created_at &&
          other.idMoneda == this.idMoneda &&
          other.idLoteriaSuperpale == this.idLoteriaSuperpale);
}

class BlocksgeneralsCompanion extends UpdateCompanion<Blocksgeneral> {
  final Value<int> id;
  final Value<int> idDia;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<double> monto;
  final Value<DateTime> created_at;
  final Value<int> idMoneda;
  final Value<int> idLoteriaSuperpale;
  const BlocksgeneralsCompanion({
    this.id = const Value.absent(),
    this.idDia = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.monto = const Value.absent(),
    this.created_at = const Value.absent(),
    this.idMoneda = const Value.absent(),
    this.idLoteriaSuperpale = const Value.absent(),
  });
  BlocksgeneralsCompanion.insert({
    this.id = const Value.absent(),
    @required int idDia,
    @required int idLoteria,
    @required int idSorteo,
    @required double monto,
    this.created_at = const Value.absent(),
    @required int idMoneda,
    this.idLoteriaSuperpale = const Value.absent(),
  })  : idDia = Value(idDia),
        idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        monto = Value(monto),
        idMoneda = Value(idMoneda);
  static Insertable<Blocksgeneral> custom({
    Expression<int> id,
    Expression<int> idDia,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<double> monto,
    Expression<DateTime> created_at,
    Expression<int> idMoneda,
    Expression<int> idLoteriaSuperpale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idDia != null) 'id_dia': idDia,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (monto != null) 'monto': monto,
      if (created_at != null) 'created_at': created_at,
      if (idMoneda != null) 'id_moneda': idMoneda,
      if (idLoteriaSuperpale != null)
        'id_loteria_superpale': idLoteriaSuperpale,
    });
  }

  BlocksgeneralsCompanion copyWith(
      {Value<int> id,
      Value<int> idDia,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<double> monto,
      Value<DateTime> created_at,
      Value<int> idMoneda,
      Value<int> idLoteriaSuperpale}) {
    return BlocksgeneralsCompanion(
      id: id ?? this.id,
      idDia: idDia ?? this.idDia,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      monto: monto ?? this.monto,
      created_at: created_at ?? this.created_at,
      idMoneda: idMoneda ?? this.idMoneda,
      idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idDia.present) {
      map['id_dia'] = Variable<int>(idDia.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    if (idLoteriaSuperpale.present) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksgeneralsCompanion(')
          ..write('id: $id, ')
          ..write('idDia: $idDia, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale')
          ..write(')'))
        .toString();
  }
}

class $BlocksgeneralsTable extends Blocksgenerals
    with TableInfo<$BlocksgeneralsTable, Blocksgeneral> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlocksgeneralsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idDiaMeta = const VerificationMeta('idDia');
  GeneratedColumn<int> _idDia;
  @override
  GeneratedColumn<int> get idDia =>
      _idDia ??= GeneratedColumn<int>('id_dia', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _montoMeta = const VerificationMeta('monto');
  GeneratedColumn<double> _monto;
  @override
  GeneratedColumn<double> get monto =>
      _monto ??= GeneratedColumn<double>('monto', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaSuperpaleMeta =
      const VerificationMeta('idLoteriaSuperpale');
  GeneratedColumn<int> _idLoteriaSuperpale;
  @override
  GeneratedColumn<int> get idLoteriaSuperpale => _idLoteriaSuperpale ??=
      GeneratedColumn<int>('id_loteria_superpale', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idDia,
        idLoteria,
        idSorteo,
        monto,
        created_at,
        idMoneda,
        idLoteriaSuperpale
      ];
  @override
  String get aliasedName => _alias ?? 'blocksgenerals';
  @override
  String get actualTableName => 'blocksgenerals';
  @override
  VerificationContext validateIntegrity(Insertable<Blocksgeneral> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_dia')) {
      context.handle(
          _idDiaMeta, idDia.isAcceptableOrUnknown(data['id_dia'], _idDiaMeta));
    } else if (isInserting) {
      context.missing(_idDiaMeta);
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto'], _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    if (data.containsKey('id_loteria_superpale')) {
      context.handle(
          _idLoteriaSuperpaleMeta,
          idLoteriaSuperpale.isAcceptableOrUnknown(
              data['id_loteria_superpale'], _idLoteriaSuperpaleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blocksgeneral map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blocksgeneral.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlocksgeneralsTable createAlias(String alias) {
    return $BlocksgeneralsTable(_db, alias);
  }
}

class Blockslotterie extends DataClass implements Insertable<Blockslotterie> {
  final int id;
  final int idBanca;
  final int idDia;
  final int idLoteria;
  final int idSorteo;
  final double monto;
  final DateTime created_at;
  final int idMoneda;
  final int descontarDelBloqueoGeneral;
  final int idLoteriaSuperpale;
  Blockslotterie(
      {@required this.id,
      @required this.idBanca,
      @required this.idDia,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.monto,
      this.created_at,
      @required this.idMoneda,
      @required this.descontarDelBloqueoGeneral,
      this.idLoteriaSuperpale});
  factory Blockslotterie.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blockslotterie(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idBanca: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_banca']),
      idDia: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_dia']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      monto: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
      descontarDelBloqueoGeneral: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}descontar_del_bloqueo_general']),
      idLoteriaSuperpale: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_loteria_superpale']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idBanca != null) {
      map['id_banca'] = Variable<int>(idBanca);
    }
    if (!nullToAbsent || idDia != null) {
      map['id_dia'] = Variable<int>(idDia);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    if (!nullToAbsent || descontarDelBloqueoGeneral != null) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral);
    }
    if (!nullToAbsent || idLoteriaSuperpale != null) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale);
    }
    return map;
  }

  BlockslotteriesCompanion toCompanion(bool nullToAbsent) {
    return BlockslotteriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idBanca: idBanca == null && nullToAbsent
          ? const Value.absent()
          : Value(idBanca),
      idDia:
          idDia == null && nullToAbsent ? const Value.absent() : Value(idDia),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      monto:
          monto == null && nullToAbsent ? const Value.absent() : Value(monto),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral == null && nullToAbsent
              ? const Value.absent()
              : Value(descontarDelBloqueoGeneral),
      idLoteriaSuperpale: idLoteriaSuperpale == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteriaSuperpale),
    );
  }

  factory Blockslotterie.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blockslotterie(
      id: serializer.fromJson<int>(json['id']),
      idBanca: serializer.fromJson<int>(json['idBanca']),
      idDia: serializer.fromJson<int>(json['idDia']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      monto: serializer.fromJson<double>(json['monto']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
      descontarDelBloqueoGeneral:
          serializer.fromJson<int>(json['descontarDelBloqueoGeneral']),
      idLoteriaSuperpale: serializer.fromJson<int>(json['idLoteriaSuperpale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBanca': serializer.toJson<int>(idBanca),
      'idDia': serializer.toJson<int>(idDia),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'monto': serializer.toJson<double>(monto),
      'created_at': serializer.toJson<DateTime>(created_at),
      'idMoneda': serializer.toJson<int>(idMoneda),
      'descontarDelBloqueoGeneral':
          serializer.toJson<int>(descontarDelBloqueoGeneral),
      'idLoteriaSuperpale': serializer.toJson<int>(idLoteriaSuperpale),
    };
  }

  Blockslotterie copyWith(
          {int id,
          int idBanca,
          int idDia,
          int idLoteria,
          int idSorteo,
          double monto,
          DateTime created_at,
          int idMoneda,
          int descontarDelBloqueoGeneral,
          int idLoteriaSuperpale}) =>
      Blockslotterie(
        id: id ?? this.id,
        idBanca: idBanca ?? this.idBanca,
        idDia: idDia ?? this.idDia,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        monto: monto ?? this.monto,
        created_at: created_at ?? this.created_at,
        idMoneda: idMoneda ?? this.idMoneda,
        descontarDelBloqueoGeneral:
            descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
        idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
      );
  @override
  String toString() {
    return (StringBuffer('Blockslotterie(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idDia: $idDia, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      idBanca,
      idDia,
      idLoteria,
      idSorteo,
      monto,
      created_at,
      idMoneda,
      descontarDelBloqueoGeneral,
      idLoteriaSuperpale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blockslotterie &&
          other.id == this.id &&
          other.idBanca == this.idBanca &&
          other.idDia == this.idDia &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.monto == this.monto &&
          other.created_at == this.created_at &&
          other.idMoneda == this.idMoneda &&
          other.descontarDelBloqueoGeneral == this.descontarDelBloqueoGeneral &&
          other.idLoteriaSuperpale == this.idLoteriaSuperpale);
}

class BlockslotteriesCompanion extends UpdateCompanion<Blockslotterie> {
  final Value<int> id;
  final Value<int> idBanca;
  final Value<int> idDia;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<double> monto;
  final Value<DateTime> created_at;
  final Value<int> idMoneda;
  final Value<int> descontarDelBloqueoGeneral;
  final Value<int> idLoteriaSuperpale;
  const BlockslotteriesCompanion({
    this.id = const Value.absent(),
    this.idBanca = const Value.absent(),
    this.idDia = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.monto = const Value.absent(),
    this.created_at = const Value.absent(),
    this.idMoneda = const Value.absent(),
    this.descontarDelBloqueoGeneral = const Value.absent(),
    this.idLoteriaSuperpale = const Value.absent(),
  });
  BlockslotteriesCompanion.insert({
    this.id = const Value.absent(),
    @required int idBanca,
    @required int idDia,
    @required int idLoteria,
    @required int idSorteo,
    @required double monto,
    this.created_at = const Value.absent(),
    @required int idMoneda,
    @required int descontarDelBloqueoGeneral,
    this.idLoteriaSuperpale = const Value.absent(),
  })  : idBanca = Value(idBanca),
        idDia = Value(idDia),
        idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        monto = Value(monto),
        idMoneda = Value(idMoneda),
        descontarDelBloqueoGeneral = Value(descontarDelBloqueoGeneral);
  static Insertable<Blockslotterie> custom({
    Expression<int> id,
    Expression<int> idBanca,
    Expression<int> idDia,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<double> monto,
    Expression<DateTime> created_at,
    Expression<int> idMoneda,
    Expression<int> descontarDelBloqueoGeneral,
    Expression<int> idLoteriaSuperpale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBanca != null) 'id_banca': idBanca,
      if (idDia != null) 'id_dia': idDia,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (monto != null) 'monto': monto,
      if (created_at != null) 'created_at': created_at,
      if (idMoneda != null) 'id_moneda': idMoneda,
      if (descontarDelBloqueoGeneral != null)
        'descontar_del_bloqueo_general': descontarDelBloqueoGeneral,
      if (idLoteriaSuperpale != null)
        'id_loteria_superpale': idLoteriaSuperpale,
    });
  }

  BlockslotteriesCompanion copyWith(
      {Value<int> id,
      Value<int> idBanca,
      Value<int> idDia,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<double> monto,
      Value<DateTime> created_at,
      Value<int> idMoneda,
      Value<int> descontarDelBloqueoGeneral,
      Value<int> idLoteriaSuperpale}) {
    return BlockslotteriesCompanion(
      id: id ?? this.id,
      idBanca: idBanca ?? this.idBanca,
      idDia: idDia ?? this.idDia,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      monto: monto ?? this.monto,
      created_at: created_at ?? this.created_at,
      idMoneda: idMoneda ?? this.idMoneda,
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
      idLoteriaSuperpale: idLoteriaSuperpale ?? this.idLoteriaSuperpale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBanca.present) {
      map['id_banca'] = Variable<int>(idBanca.value);
    }
    if (idDia.present) {
      map['id_dia'] = Variable<int>(idDia.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    if (descontarDelBloqueoGeneral.present) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral.value);
    }
    if (idLoteriaSuperpale.present) {
      map['id_loteria_superpale'] = Variable<int>(idLoteriaSuperpale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockslotteriesCompanion(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idDia: $idDia, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('monto: $monto, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral, ')
          ..write('idLoteriaSuperpale: $idLoteriaSuperpale')
          ..write(')'))
        .toString();
  }
}

class $BlockslotteriesTable extends Blockslotteries
    with TableInfo<$BlockslotteriesTable, Blockslotterie> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlockslotteriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idBancaMeta = const VerificationMeta('idBanca');
  GeneratedColumn<int> _idBanca;
  @override
  GeneratedColumn<int> get idBanca =>
      _idBanca ??= GeneratedColumn<int>('id_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idDiaMeta = const VerificationMeta('idDia');
  GeneratedColumn<int> _idDia;
  @override
  GeneratedColumn<int> get idDia =>
      _idDia ??= GeneratedColumn<int>('id_dia', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _montoMeta = const VerificationMeta('monto');
  GeneratedColumn<double> _monto;
  @override
  GeneratedColumn<double> get monto =>
      _monto ??= GeneratedColumn<double>('monto', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descontarDelBloqueoGeneralMeta =
      const VerificationMeta('descontarDelBloqueoGeneral');
  GeneratedColumn<int> _descontarDelBloqueoGeneral;
  @override
  GeneratedColumn<int> get descontarDelBloqueoGeneral =>
      _descontarDelBloqueoGeneral ??= GeneratedColumn<int>(
          'descontar_del_bloqueo_general', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaSuperpaleMeta =
      const VerificationMeta('idLoteriaSuperpale');
  GeneratedColumn<int> _idLoteriaSuperpale;
  @override
  GeneratedColumn<int> get idLoteriaSuperpale => _idLoteriaSuperpale ??=
      GeneratedColumn<int>('id_loteria_superpale', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idBanca,
        idDia,
        idLoteria,
        idSorteo,
        monto,
        created_at,
        idMoneda,
        descontarDelBloqueoGeneral,
        idLoteriaSuperpale
      ];
  @override
  String get aliasedName => _alias ?? 'blockslotteries';
  @override
  String get actualTableName => 'blockslotteries';
  @override
  VerificationContext validateIntegrity(Insertable<Blockslotterie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_banca')) {
      context.handle(_idBancaMeta,
          idBanca.isAcceptableOrUnknown(data['id_banca'], _idBancaMeta));
    } else if (isInserting) {
      context.missing(_idBancaMeta);
    }
    if (data.containsKey('id_dia')) {
      context.handle(
          _idDiaMeta, idDia.isAcceptableOrUnknown(data['id_dia'], _idDiaMeta));
    } else if (isInserting) {
      context.missing(_idDiaMeta);
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto'], _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    if (data.containsKey('descontar_del_bloqueo_general')) {
      context.handle(
          _descontarDelBloqueoGeneralMeta,
          descontarDelBloqueoGeneral.isAcceptableOrUnknown(
              data['descontar_del_bloqueo_general'],
              _descontarDelBloqueoGeneralMeta));
    } else if (isInserting) {
      context.missing(_descontarDelBloqueoGeneralMeta);
    }
    if (data.containsKey('id_loteria_superpale')) {
      context.handle(
          _idLoteriaSuperpaleMeta,
          idLoteriaSuperpale.isAcceptableOrUnknown(
              data['id_loteria_superpale'], _idLoteriaSuperpaleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blockslotterie map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blockslotterie.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlockslotteriesTable createAlias(String alias) {
    return $BlockslotteriesTable(_db, alias);
  }
}

class Blocksplay extends DataClass implements Insertable<Blocksplay> {
  final int id;
  final int idBanca;
  final int idLoteria;
  final int idSorteo;
  final String jugada;
  final double monto;
  final double montoInicial;
  final DateTime created_at;
  final DateTime fechaDesde;
  final DateTime fechaHasta;
  final int ignorarDemasBloqueos;
  final int status;
  final int idMoneda;
  final int descontarDelBloqueoGeneral;
  Blocksplay(
      {@required this.id,
      @required this.idBanca,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.jugada,
      @required this.monto,
      @required this.montoInicial,
      this.created_at,
      this.fechaDesde,
      this.fechaHasta,
      @required this.ignorarDemasBloqueos,
      @required this.status,
      @required this.idMoneda,
      @required this.descontarDelBloqueoGeneral});
  factory Blocksplay.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blocksplay(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idBanca: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_banca']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      jugada: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}jugada']),
      monto: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto']),
      montoInicial: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto_inicial']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      fechaDesde: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_desde']),
      fechaHasta: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_hasta']),
      ignorarDemasBloqueos: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}ignorar_demas_bloqueos']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
      descontarDelBloqueoGeneral: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}descontar_del_bloqueo_general']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idBanca != null) {
      map['id_banca'] = Variable<int>(idBanca);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || jugada != null) {
      map['jugada'] = Variable<String>(jugada);
    }
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || montoInicial != null) {
      map['monto_inicial'] = Variable<double>(montoInicial);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || fechaDesde != null) {
      map['fecha_desde'] = Variable<DateTime>(fechaDesde);
    }
    if (!nullToAbsent || fechaHasta != null) {
      map['fecha_hasta'] = Variable<DateTime>(fechaHasta);
    }
    if (!nullToAbsent || ignorarDemasBloqueos != null) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    if (!nullToAbsent || descontarDelBloqueoGeneral != null) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral);
    }
    return map;
  }

  BlocksplaysCompanion toCompanion(bool nullToAbsent) {
    return BlocksplaysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idBanca: idBanca == null && nullToAbsent
          ? const Value.absent()
          : Value(idBanca),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      jugada:
          jugada == null && nullToAbsent ? const Value.absent() : Value(jugada),
      monto:
          monto == null && nullToAbsent ? const Value.absent() : Value(monto),
      montoInicial: montoInicial == null && nullToAbsent
          ? const Value.absent()
          : Value(montoInicial),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      fechaDesde: fechaDesde == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaDesde),
      fechaHasta: fechaHasta == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHasta),
      ignorarDemasBloqueos: ignorarDemasBloqueos == null && nullToAbsent
          ? const Value.absent()
          : Value(ignorarDemasBloqueos),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral == null && nullToAbsent
              ? const Value.absent()
              : Value(descontarDelBloqueoGeneral),
    );
  }

  factory Blocksplay.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blocksplay(
      id: serializer.fromJson<int>(json['id']),
      idBanca: serializer.fromJson<int>(json['idBanca']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      jugada: serializer.fromJson<String>(json['jugada']),
      monto: serializer.fromJson<double>(json['monto']),
      montoInicial: serializer.fromJson<double>(json['montoInicial']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      fechaDesde: serializer.fromJson<DateTime>(json['fechaDesde']),
      fechaHasta: serializer.fromJson<DateTime>(json['fechaHasta']),
      ignorarDemasBloqueos:
          serializer.fromJson<int>(json['ignorarDemasBloqueos']),
      status: serializer.fromJson<int>(json['status']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
      descontarDelBloqueoGeneral:
          serializer.fromJson<int>(json['descontarDelBloqueoGeneral']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBanca': serializer.toJson<int>(idBanca),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'jugada': serializer.toJson<String>(jugada),
      'monto': serializer.toJson<double>(monto),
      'montoInicial': serializer.toJson<double>(montoInicial),
      'created_at': serializer.toJson<DateTime>(created_at),
      'fechaDesde': serializer.toJson<DateTime>(fechaDesde),
      'fechaHasta': serializer.toJson<DateTime>(fechaHasta),
      'ignorarDemasBloqueos': serializer.toJson<int>(ignorarDemasBloqueos),
      'status': serializer.toJson<int>(status),
      'idMoneda': serializer.toJson<int>(idMoneda),
      'descontarDelBloqueoGeneral':
          serializer.toJson<int>(descontarDelBloqueoGeneral),
    };
  }

  Blocksplay copyWith(
          {int id,
          int idBanca,
          int idLoteria,
          int idSorteo,
          String jugada,
          double monto,
          double montoInicial,
          DateTime created_at,
          DateTime fechaDesde,
          DateTime fechaHasta,
          int ignorarDemasBloqueos,
          int status,
          int idMoneda,
          int descontarDelBloqueoGeneral}) =>
      Blocksplay(
        id: id ?? this.id,
        idBanca: idBanca ?? this.idBanca,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        jugada: jugada ?? this.jugada,
        monto: monto ?? this.monto,
        montoInicial: montoInicial ?? this.montoInicial,
        created_at: created_at ?? this.created_at,
        fechaDesde: fechaDesde ?? this.fechaDesde,
        fechaHasta: fechaHasta ?? this.fechaHasta,
        ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
        status: status ?? this.status,
        idMoneda: idMoneda ?? this.idMoneda,
        descontarDelBloqueoGeneral:
            descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
      );
  @override
  String toString() {
    return (StringBuffer('Blocksplay(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('monto: $monto, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('created_at: $created_at, ')
          ..write('fechaDesde: $fechaDesde, ')
          ..write('fechaHasta: $fechaHasta, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('status: $status, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      idBanca,
      idLoteria,
      idSorteo,
      jugada,
      monto,
      montoInicial,
      created_at,
      fechaDesde,
      fechaHasta,
      ignorarDemasBloqueos,
      status,
      idMoneda,
      descontarDelBloqueoGeneral);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocksplay &&
          other.id == this.id &&
          other.idBanca == this.idBanca &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.jugada == this.jugada &&
          other.monto == this.monto &&
          other.montoInicial == this.montoInicial &&
          other.created_at == this.created_at &&
          other.fechaDesde == this.fechaDesde &&
          other.fechaHasta == this.fechaHasta &&
          other.ignorarDemasBloqueos == this.ignorarDemasBloqueos &&
          other.status == this.status &&
          other.idMoneda == this.idMoneda &&
          other.descontarDelBloqueoGeneral == this.descontarDelBloqueoGeneral);
}

class BlocksplaysCompanion extends UpdateCompanion<Blocksplay> {
  final Value<int> id;
  final Value<int> idBanca;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<String> jugada;
  final Value<double> monto;
  final Value<double> montoInicial;
  final Value<DateTime> created_at;
  final Value<DateTime> fechaDesde;
  final Value<DateTime> fechaHasta;
  final Value<int> ignorarDemasBloqueos;
  final Value<int> status;
  final Value<int> idMoneda;
  final Value<int> descontarDelBloqueoGeneral;
  const BlocksplaysCompanion({
    this.id = const Value.absent(),
    this.idBanca = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.jugada = const Value.absent(),
    this.monto = const Value.absent(),
    this.montoInicial = const Value.absent(),
    this.created_at = const Value.absent(),
    this.fechaDesde = const Value.absent(),
    this.fechaHasta = const Value.absent(),
    this.ignorarDemasBloqueos = const Value.absent(),
    this.status = const Value.absent(),
    this.idMoneda = const Value.absent(),
    this.descontarDelBloqueoGeneral = const Value.absent(),
  });
  BlocksplaysCompanion.insert({
    this.id = const Value.absent(),
    @required int idBanca,
    @required int idLoteria,
    @required int idSorteo,
    @required String jugada,
    @required double monto,
    @required double montoInicial,
    this.created_at = const Value.absent(),
    this.fechaDesde = const Value.absent(),
    this.fechaHasta = const Value.absent(),
    @required int ignorarDemasBloqueos,
    @required int status,
    @required int idMoneda,
    @required int descontarDelBloqueoGeneral,
  })  : idBanca = Value(idBanca),
        idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        jugada = Value(jugada),
        monto = Value(monto),
        montoInicial = Value(montoInicial),
        ignorarDemasBloqueos = Value(ignorarDemasBloqueos),
        status = Value(status),
        idMoneda = Value(idMoneda),
        descontarDelBloqueoGeneral = Value(descontarDelBloqueoGeneral);
  static Insertable<Blocksplay> custom({
    Expression<int> id,
    Expression<int> idBanca,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<String> jugada,
    Expression<double> monto,
    Expression<double> montoInicial,
    Expression<DateTime> created_at,
    Expression<DateTime> fechaDesde,
    Expression<DateTime> fechaHasta,
    Expression<int> ignorarDemasBloqueos,
    Expression<int> status,
    Expression<int> idMoneda,
    Expression<int> descontarDelBloqueoGeneral,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBanca != null) 'id_banca': idBanca,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (jugada != null) 'jugada': jugada,
      if (monto != null) 'monto': monto,
      if (montoInicial != null) 'monto_inicial': montoInicial,
      if (created_at != null) 'created_at': created_at,
      if (fechaDesde != null) 'fecha_desde': fechaDesde,
      if (fechaHasta != null) 'fecha_hasta': fechaHasta,
      if (ignorarDemasBloqueos != null)
        'ignorar_demas_bloqueos': ignorarDemasBloqueos,
      if (status != null) 'status': status,
      if (idMoneda != null) 'id_moneda': idMoneda,
      if (descontarDelBloqueoGeneral != null)
        'descontar_del_bloqueo_general': descontarDelBloqueoGeneral,
    });
  }

  BlocksplaysCompanion copyWith(
      {Value<int> id,
      Value<int> idBanca,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<String> jugada,
      Value<double> monto,
      Value<double> montoInicial,
      Value<DateTime> created_at,
      Value<DateTime> fechaDesde,
      Value<DateTime> fechaHasta,
      Value<int> ignorarDemasBloqueos,
      Value<int> status,
      Value<int> idMoneda,
      Value<int> descontarDelBloqueoGeneral}) {
    return BlocksplaysCompanion(
      id: id ?? this.id,
      idBanca: idBanca ?? this.idBanca,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      jugada: jugada ?? this.jugada,
      monto: monto ?? this.monto,
      montoInicial: montoInicial ?? this.montoInicial,
      created_at: created_at ?? this.created_at,
      fechaDesde: fechaDesde ?? this.fechaDesde,
      fechaHasta: fechaHasta ?? this.fechaHasta,
      ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
      status: status ?? this.status,
      idMoneda: idMoneda ?? this.idMoneda,
      descontarDelBloqueoGeneral:
          descontarDelBloqueoGeneral ?? this.descontarDelBloqueoGeneral,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBanca.present) {
      map['id_banca'] = Variable<int>(idBanca.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (jugada.present) {
      map['jugada'] = Variable<String>(jugada.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (montoInicial.present) {
      map['monto_inicial'] = Variable<double>(montoInicial.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (fechaDesde.present) {
      map['fecha_desde'] = Variable<DateTime>(fechaDesde.value);
    }
    if (fechaHasta.present) {
      map['fecha_hasta'] = Variable<DateTime>(fechaHasta.value);
    }
    if (ignorarDemasBloqueos.present) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    if (descontarDelBloqueoGeneral.present) {
      map['descontar_del_bloqueo_general'] =
          Variable<int>(descontarDelBloqueoGeneral.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksplaysCompanion(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('monto: $monto, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('created_at: $created_at, ')
          ..write('fechaDesde: $fechaDesde, ')
          ..write('fechaHasta: $fechaHasta, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('status: $status, ')
          ..write('idMoneda: $idMoneda, ')
          ..write('descontarDelBloqueoGeneral: $descontarDelBloqueoGeneral')
          ..write(')'))
        .toString();
  }
}

class $BlocksplaysTable extends Blocksplays
    with TableInfo<$BlocksplaysTable, Blocksplay> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlocksplaysTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idBancaMeta = const VerificationMeta('idBanca');
  GeneratedColumn<int> _idBanca;
  @override
  GeneratedColumn<int> get idBanca =>
      _idBanca ??= GeneratedColumn<int>('id_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _jugadaMeta = const VerificationMeta('jugada');
  GeneratedColumn<String> _jugada;
  @override
  GeneratedColumn<String> get jugada =>
      _jugada ??= GeneratedColumn<String>('jugada', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _montoMeta = const VerificationMeta('monto');
  GeneratedColumn<double> _monto;
  @override
  GeneratedColumn<double> get monto =>
      _monto ??= GeneratedColumn<double>('monto', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _montoInicialMeta =
      const VerificationMeta('montoInicial');
  GeneratedColumn<double> _montoInicial;
  @override
  GeneratedColumn<double> get montoInicial => _montoInicial ??=
      GeneratedColumn<double>('monto_inicial', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _fechaDesdeMeta = const VerificationMeta('fechaDesde');
  GeneratedColumn<DateTime> _fechaDesde;
  @override
  GeneratedColumn<DateTime> get fechaDesde => _fechaDesde ??=
      GeneratedColumn<DateTime>('fecha_desde', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _fechaHastaMeta = const VerificationMeta('fechaHasta');
  GeneratedColumn<DateTime> _fechaHasta;
  @override
  GeneratedColumn<DateTime> get fechaHasta => _fechaHasta ??=
      GeneratedColumn<DateTime>('fecha_hasta', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _ignorarDemasBloqueosMeta =
      const VerificationMeta('ignorarDemasBloqueos');
  GeneratedColumn<int> _ignorarDemasBloqueos;
  @override
  GeneratedColumn<int> get ignorarDemasBloqueos => _ignorarDemasBloqueos ??=
      GeneratedColumn<int>('ignorar_demas_bloqueos', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descontarDelBloqueoGeneralMeta =
      const VerificationMeta('descontarDelBloqueoGeneral');
  GeneratedColumn<int> _descontarDelBloqueoGeneral;
  @override
  GeneratedColumn<int> get descontarDelBloqueoGeneral =>
      _descontarDelBloqueoGeneral ??= GeneratedColumn<int>(
          'descontar_del_bloqueo_general', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idBanca,
        idLoteria,
        idSorteo,
        jugada,
        monto,
        montoInicial,
        created_at,
        fechaDesde,
        fechaHasta,
        ignorarDemasBloqueos,
        status,
        idMoneda,
        descontarDelBloqueoGeneral
      ];
  @override
  String get aliasedName => _alias ?? 'blocksplays';
  @override
  String get actualTableName => 'blocksplays';
  @override
  VerificationContext validateIntegrity(Insertable<Blocksplay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_banca')) {
      context.handle(_idBancaMeta,
          idBanca.isAcceptableOrUnknown(data['id_banca'], _idBancaMeta));
    } else if (isInserting) {
      context.missing(_idBancaMeta);
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('jugada')) {
      context.handle(_jugadaMeta,
          jugada.isAcceptableOrUnknown(data['jugada'], _jugadaMeta));
    } else if (isInserting) {
      context.missing(_jugadaMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto'], _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('monto_inicial')) {
      context.handle(
          _montoInicialMeta,
          montoInicial.isAcceptableOrUnknown(
              data['monto_inicial'], _montoInicialMeta));
    } else if (isInserting) {
      context.missing(_montoInicialMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('fecha_desde')) {
      context.handle(
          _fechaDesdeMeta,
          fechaDesde.isAcceptableOrUnknown(
              data['fecha_desde'], _fechaDesdeMeta));
    }
    if (data.containsKey('fecha_hasta')) {
      context.handle(
          _fechaHastaMeta,
          fechaHasta.isAcceptableOrUnknown(
              data['fecha_hasta'], _fechaHastaMeta));
    }
    if (data.containsKey('ignorar_demas_bloqueos')) {
      context.handle(
          _ignorarDemasBloqueosMeta,
          ignorarDemasBloqueos.isAcceptableOrUnknown(
              data['ignorar_demas_bloqueos'], _ignorarDemasBloqueosMeta));
    } else if (isInserting) {
      context.missing(_ignorarDemasBloqueosMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    if (data.containsKey('descontar_del_bloqueo_general')) {
      context.handle(
          _descontarDelBloqueoGeneralMeta,
          descontarDelBloqueoGeneral.isAcceptableOrUnknown(
              data['descontar_del_bloqueo_general'],
              _descontarDelBloqueoGeneralMeta));
    } else if (isInserting) {
      context.missing(_descontarDelBloqueoGeneralMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blocksplay map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blocksplay.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlocksplaysTable createAlias(String alias) {
    return $BlocksplaysTable(_db, alias);
  }
}

class Blocksplaysgeneral extends DataClass
    implements Insertable<Blocksplaysgeneral> {
  final int id;
  final int idLoteria;
  final int idSorteo;
  final String jugada;
  final double monto;
  final double montoInicial;
  final DateTime created_at;
  final DateTime fechaDesde;
  final DateTime fechaHasta;
  final int ignorarDemasBloqueos;
  final int status;
  final int idMoneda;
  Blocksplaysgeneral(
      {@required this.id,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.jugada,
      @required this.monto,
      @required this.montoInicial,
      this.created_at,
      this.fechaDesde,
      this.fechaHasta,
      @required this.ignorarDemasBloqueos,
      @required this.status,
      @required this.idMoneda});
  factory Blocksplaysgeneral.fromData(Map<String, dynamic> data,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blocksplaysgeneral(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      jugada: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}jugada']),
      monto: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto']),
      montoInicial: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}monto_inicial']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      fechaDesde: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_desde']),
      fechaHasta: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_hasta']),
      ignorarDemasBloqueos: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}ignorar_demas_bloqueos']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || jugada != null) {
      map['jugada'] = Variable<String>(jugada);
    }
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || montoInicial != null) {
      map['monto_inicial'] = Variable<double>(montoInicial);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || fechaDesde != null) {
      map['fecha_desde'] = Variable<DateTime>(fechaDesde);
    }
    if (!nullToAbsent || fechaHasta != null) {
      map['fecha_hasta'] = Variable<DateTime>(fechaHasta);
    }
    if (!nullToAbsent || ignorarDemasBloqueos != null) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    return map;
  }

  BlocksplaysgeneralsCompanion toCompanion(bool nullToAbsent) {
    return BlocksplaysgeneralsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      jugada:
          jugada == null && nullToAbsent ? const Value.absent() : Value(jugada),
      monto:
          monto == null && nullToAbsent ? const Value.absent() : Value(monto),
      montoInicial: montoInicial == null && nullToAbsent
          ? const Value.absent()
          : Value(montoInicial),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      fechaDesde: fechaDesde == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaDesde),
      fechaHasta: fechaHasta == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHasta),
      ignorarDemasBloqueos: ignorarDemasBloqueos == null && nullToAbsent
          ? const Value.absent()
          : Value(ignorarDemasBloqueos),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
    );
  }

  factory Blocksplaysgeneral.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blocksplaysgeneral(
      id: serializer.fromJson<int>(json['id']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      jugada: serializer.fromJson<String>(json['jugada']),
      monto: serializer.fromJson<double>(json['monto']),
      montoInicial: serializer.fromJson<double>(json['montoInicial']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      fechaDesde: serializer.fromJson<DateTime>(json['fechaDesde']),
      fechaHasta: serializer.fromJson<DateTime>(json['fechaHasta']),
      ignorarDemasBloqueos:
          serializer.fromJson<int>(json['ignorarDemasBloqueos']),
      status: serializer.fromJson<int>(json['status']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'jugada': serializer.toJson<String>(jugada),
      'monto': serializer.toJson<double>(monto),
      'montoInicial': serializer.toJson<double>(montoInicial),
      'created_at': serializer.toJson<DateTime>(created_at),
      'fechaDesde': serializer.toJson<DateTime>(fechaDesde),
      'fechaHasta': serializer.toJson<DateTime>(fechaHasta),
      'ignorarDemasBloqueos': serializer.toJson<int>(ignorarDemasBloqueos),
      'status': serializer.toJson<int>(status),
      'idMoneda': serializer.toJson<int>(idMoneda),
    };
  }

  Blocksplaysgeneral copyWith(
          {int id,
          int idLoteria,
          int idSorteo,
          String jugada,
          double monto,
          double montoInicial,
          DateTime created_at,
          DateTime fechaDesde,
          DateTime fechaHasta,
          int ignorarDemasBloqueos,
          int status,
          int idMoneda}) =>
      Blocksplaysgeneral(
        id: id ?? this.id,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        jugada: jugada ?? this.jugada,
        monto: monto ?? this.monto,
        montoInicial: montoInicial ?? this.montoInicial,
        created_at: created_at ?? this.created_at,
        fechaDesde: fechaDesde ?? this.fechaDesde,
        fechaHasta: fechaHasta ?? this.fechaHasta,
        ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
        status: status ?? this.status,
        idMoneda: idMoneda ?? this.idMoneda,
      );
  @override
  String toString() {
    return (StringBuffer('Blocksplaysgeneral(')
          ..write('id: $id, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('monto: $monto, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('created_at: $created_at, ')
          ..write('fechaDesde: $fechaDesde, ')
          ..write('fechaHasta: $fechaHasta, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('status: $status, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      idLoteria,
      idSorteo,
      jugada,
      monto,
      montoInicial,
      created_at,
      fechaDesde,
      fechaHasta,
      ignorarDemasBloqueos,
      status,
      idMoneda);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocksplaysgeneral &&
          other.id == this.id &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.jugada == this.jugada &&
          other.monto == this.monto &&
          other.montoInicial == this.montoInicial &&
          other.created_at == this.created_at &&
          other.fechaDesde == this.fechaDesde &&
          other.fechaHasta == this.fechaHasta &&
          other.ignorarDemasBloqueos == this.ignorarDemasBloqueos &&
          other.status == this.status &&
          other.idMoneda == this.idMoneda);
}

class BlocksplaysgeneralsCompanion extends UpdateCompanion<Blocksplaysgeneral> {
  final Value<int> id;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<String> jugada;
  final Value<double> monto;
  final Value<double> montoInicial;
  final Value<DateTime> created_at;
  final Value<DateTime> fechaDesde;
  final Value<DateTime> fechaHasta;
  final Value<int> ignorarDemasBloqueos;
  final Value<int> status;
  final Value<int> idMoneda;
  const BlocksplaysgeneralsCompanion({
    this.id = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.jugada = const Value.absent(),
    this.monto = const Value.absent(),
    this.montoInicial = const Value.absent(),
    this.created_at = const Value.absent(),
    this.fechaDesde = const Value.absent(),
    this.fechaHasta = const Value.absent(),
    this.ignorarDemasBloqueos = const Value.absent(),
    this.status = const Value.absent(),
    this.idMoneda = const Value.absent(),
  });
  BlocksplaysgeneralsCompanion.insert({
    this.id = const Value.absent(),
    @required int idLoteria,
    @required int idSorteo,
    @required String jugada,
    @required double monto,
    @required double montoInicial,
    this.created_at = const Value.absent(),
    this.fechaDesde = const Value.absent(),
    this.fechaHasta = const Value.absent(),
    @required int ignorarDemasBloqueos,
    @required int status,
    @required int idMoneda,
  })  : idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        jugada = Value(jugada),
        monto = Value(monto),
        montoInicial = Value(montoInicial),
        ignorarDemasBloqueos = Value(ignorarDemasBloqueos),
        status = Value(status),
        idMoneda = Value(idMoneda);
  static Insertable<Blocksplaysgeneral> custom({
    Expression<int> id,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<String> jugada,
    Expression<double> monto,
    Expression<double> montoInicial,
    Expression<DateTime> created_at,
    Expression<DateTime> fechaDesde,
    Expression<DateTime> fechaHasta,
    Expression<int> ignorarDemasBloqueos,
    Expression<int> status,
    Expression<int> idMoneda,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (jugada != null) 'jugada': jugada,
      if (monto != null) 'monto': monto,
      if (montoInicial != null) 'monto_inicial': montoInicial,
      if (created_at != null) 'created_at': created_at,
      if (fechaDesde != null) 'fecha_desde': fechaDesde,
      if (fechaHasta != null) 'fecha_hasta': fechaHasta,
      if (ignorarDemasBloqueos != null)
        'ignorar_demas_bloqueos': ignorarDemasBloqueos,
      if (status != null) 'status': status,
      if (idMoneda != null) 'id_moneda': idMoneda,
    });
  }

  BlocksplaysgeneralsCompanion copyWith(
      {Value<int> id,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<String> jugada,
      Value<double> monto,
      Value<double> montoInicial,
      Value<DateTime> created_at,
      Value<DateTime> fechaDesde,
      Value<DateTime> fechaHasta,
      Value<int> ignorarDemasBloqueos,
      Value<int> status,
      Value<int> idMoneda}) {
    return BlocksplaysgeneralsCompanion(
      id: id ?? this.id,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      jugada: jugada ?? this.jugada,
      monto: monto ?? this.monto,
      montoInicial: montoInicial ?? this.montoInicial,
      created_at: created_at ?? this.created_at,
      fechaDesde: fechaDesde ?? this.fechaDesde,
      fechaHasta: fechaHasta ?? this.fechaHasta,
      ignorarDemasBloqueos: ignorarDemasBloqueos ?? this.ignorarDemasBloqueos,
      status: status ?? this.status,
      idMoneda: idMoneda ?? this.idMoneda,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (jugada.present) {
      map['jugada'] = Variable<String>(jugada.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (montoInicial.present) {
      map['monto_inicial'] = Variable<double>(montoInicial.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (fechaDesde.present) {
      map['fecha_desde'] = Variable<DateTime>(fechaDesde.value);
    }
    if (fechaHasta.present) {
      map['fecha_hasta'] = Variable<DateTime>(fechaHasta.value);
    }
    if (ignorarDemasBloqueos.present) {
      map['ignorar_demas_bloqueos'] = Variable<int>(ignorarDemasBloqueos.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksplaysgeneralsCompanion(')
          ..write('id: $id, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('jugada: $jugada, ')
          ..write('monto: $monto, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('created_at: $created_at, ')
          ..write('fechaDesde: $fechaDesde, ')
          ..write('fechaHasta: $fechaHasta, ')
          ..write('ignorarDemasBloqueos: $ignorarDemasBloqueos, ')
          ..write('status: $status, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }
}

class $BlocksplaysgeneralsTable extends Blocksplaysgenerals
    with TableInfo<$BlocksplaysgeneralsTable, Blocksplaysgeneral> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlocksplaysgeneralsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _jugadaMeta = const VerificationMeta('jugada');
  GeneratedColumn<String> _jugada;
  @override
  GeneratedColumn<String> get jugada =>
      _jugada ??= GeneratedColumn<String>('jugada', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _montoMeta = const VerificationMeta('monto');
  GeneratedColumn<double> _monto;
  @override
  GeneratedColumn<double> get monto =>
      _monto ??= GeneratedColumn<double>('monto', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _montoInicialMeta =
      const VerificationMeta('montoInicial');
  GeneratedColumn<double> _montoInicial;
  @override
  GeneratedColumn<double> get montoInicial => _montoInicial ??=
      GeneratedColumn<double>('monto_inicial', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _fechaDesdeMeta = const VerificationMeta('fechaDesde');
  GeneratedColumn<DateTime> _fechaDesde;
  @override
  GeneratedColumn<DateTime> get fechaDesde => _fechaDesde ??=
      GeneratedColumn<DateTime>('fecha_desde', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _fechaHastaMeta = const VerificationMeta('fechaHasta');
  GeneratedColumn<DateTime> _fechaHasta;
  @override
  GeneratedColumn<DateTime> get fechaHasta => _fechaHasta ??=
      GeneratedColumn<DateTime>('fecha_hasta', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _ignorarDemasBloqueosMeta =
      const VerificationMeta('ignorarDemasBloqueos');
  GeneratedColumn<int> _ignorarDemasBloqueos;
  @override
  GeneratedColumn<int> get ignorarDemasBloqueos => _ignorarDemasBloqueos ??=
      GeneratedColumn<int>('ignorar_demas_bloqueos', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idLoteria,
        idSorteo,
        jugada,
        monto,
        montoInicial,
        created_at,
        fechaDesde,
        fechaHasta,
        ignorarDemasBloqueos,
        status,
        idMoneda
      ];
  @override
  String get aliasedName => _alias ?? 'blocksplaysgenerals';
  @override
  String get actualTableName => 'blocksplaysgenerals';
  @override
  VerificationContext validateIntegrity(Insertable<Blocksplaysgeneral> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('jugada')) {
      context.handle(_jugadaMeta,
          jugada.isAcceptableOrUnknown(data['jugada'], _jugadaMeta));
    } else if (isInserting) {
      context.missing(_jugadaMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto'], _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('monto_inicial')) {
      context.handle(
          _montoInicialMeta,
          montoInicial.isAcceptableOrUnknown(
              data['monto_inicial'], _montoInicialMeta));
    } else if (isInserting) {
      context.missing(_montoInicialMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('fecha_desde')) {
      context.handle(
          _fechaDesdeMeta,
          fechaDesde.isAcceptableOrUnknown(
              data['fecha_desde'], _fechaDesdeMeta));
    }
    if (data.containsKey('fecha_hasta')) {
      context.handle(
          _fechaHastaMeta,
          fechaHasta.isAcceptableOrUnknown(
              data['fecha_hasta'], _fechaHastaMeta));
    }
    if (data.containsKey('ignorar_demas_bloqueos')) {
      context.handle(
          _ignorarDemasBloqueosMeta,
          ignorarDemasBloqueos.isAcceptableOrUnknown(
              data['ignorar_demas_bloqueos'], _ignorarDemasBloqueosMeta));
    } else if (isInserting) {
      context.missing(_ignorarDemasBloqueosMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blocksplaysgeneral map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blocksplaysgeneral.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlocksplaysgeneralsTable createAlias(String alias) {
    return $BlocksplaysgeneralsTable(_db, alias);
  }
}

class Draw extends DataClass implements Insertable<Draw> {
  final int id;
  final String descripcion;
  final DateTime created_at;
  final int bolos;
  final int cantidadNumeros;
  final int status;
  Draw(
      {@required this.id,
      @required this.descripcion,
      this.created_at,
      @required this.bolos,
      @required this.cantidadNumeros,
      @required this.status});
  factory Draw.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Draw(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      bolos: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bolos']),
      cantidadNumeros: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cantidad_numeros']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || bolos != null) {
      map['bolos'] = Variable<int>(bolos);
    }
    if (!nullToAbsent || cantidadNumeros != null) {
      map['cantidad_numeros'] = Variable<int>(cantidadNumeros);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    return map;
  }

  DrawsCompanion toCompanion(bool nullToAbsent) {
    return DrawsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      bolos:
          bolos == null && nullToAbsent ? const Value.absent() : Value(bolos),
      cantidadNumeros: cantidadNumeros == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidadNumeros),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Draw.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Draw(
      id: serializer.fromJson<int>(json['id']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      bolos: serializer.fromJson<int>(json['bolos']),
      cantidadNumeros: serializer.fromJson<int>(json['cantidadNumeros']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descripcion': serializer.toJson<String>(descripcion),
      'created_at': serializer.toJson<DateTime>(created_at),
      'bolos': serializer.toJson<int>(bolos),
      'cantidadNumeros': serializer.toJson<int>(cantidadNumeros),
      'status': serializer.toJson<int>(status),
    };
  }

  Draw copyWith(
          {int id,
          String descripcion,
          DateTime created_at,
          int bolos,
          int cantidadNumeros,
          int status}) =>
      Draw(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        created_at: created_at ?? this.created_at,
        bolos: bolos ?? this.bolos,
        cantidadNumeros: cantidadNumeros ?? this.cantidadNumeros,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Draw(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('bolos: $bolos, ')
          ..write('cantidadNumeros: $cantidadNumeros, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, descripcion, created_at, bolos, cantidadNumeros, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Draw &&
          other.id == this.id &&
          other.descripcion == this.descripcion &&
          other.created_at == this.created_at &&
          other.bolos == this.bolos &&
          other.cantidadNumeros == this.cantidadNumeros &&
          other.status == this.status);
}

class DrawsCompanion extends UpdateCompanion<Draw> {
  final Value<int> id;
  final Value<String> descripcion;
  final Value<DateTime> created_at;
  final Value<int> bolos;
  final Value<int> cantidadNumeros;
  final Value<int> status;
  const DrawsCompanion({
    this.id = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.created_at = const Value.absent(),
    this.bolos = const Value.absent(),
    this.cantidadNumeros = const Value.absent(),
    this.status = const Value.absent(),
  });
  DrawsCompanion.insert({
    this.id = const Value.absent(),
    @required String descripcion,
    this.created_at = const Value.absent(),
    @required int bolos,
    @required int cantidadNumeros,
    @required int status,
  })  : descripcion = Value(descripcion),
        bolos = Value(bolos),
        cantidadNumeros = Value(cantidadNumeros),
        status = Value(status);
  static Insertable<Draw> custom({
    Expression<int> id,
    Expression<String> descripcion,
    Expression<DateTime> created_at,
    Expression<int> bolos,
    Expression<int> cantidadNumeros,
    Expression<int> status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descripcion != null) 'descripcion': descripcion,
      if (created_at != null) 'created_at': created_at,
      if (bolos != null) 'bolos': bolos,
      if (cantidadNumeros != null) 'cantidad_numeros': cantidadNumeros,
      if (status != null) 'status': status,
    });
  }

  DrawsCompanion copyWith(
      {Value<int> id,
      Value<String> descripcion,
      Value<DateTime> created_at,
      Value<int> bolos,
      Value<int> cantidadNumeros,
      Value<int> status}) {
    return DrawsCompanion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      created_at: created_at ?? this.created_at,
      bolos: bolos ?? this.bolos,
      cantidadNumeros: cantidadNumeros ?? this.cantidadNumeros,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (bolos.present) {
      map['bolos'] = Variable<int>(bolos.value);
    }
    if (cantidadNumeros.present) {
      map['cantidad_numeros'] = Variable<int>(cantidadNumeros.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawsCompanion(')
          ..write('id: $id, ')
          ..write('descripcion: $descripcion, ')
          ..write('created_at: $created_at, ')
          ..write('bolos: $bolos, ')
          ..write('cantidadNumeros: $cantidadNumeros, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DrawsTable extends Draws with TableInfo<$DrawsTable, Draw> {
  final GeneratedDatabase _db;
  final String _alias;
  $DrawsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedColumn<String> _descripcion;
  @override
  GeneratedColumn<String> get descripcion => _descripcion ??=
      GeneratedColumn<String>('descripcion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _bolosMeta = const VerificationMeta('bolos');
  GeneratedColumn<int> _bolos;
  @override
  GeneratedColumn<int> get bolos =>
      _bolos ??= GeneratedColumn<int>('bolos', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _cantidadNumerosMeta =
      const VerificationMeta('cantidadNumeros');
  GeneratedColumn<int> _cantidadNumeros;
  @override
  GeneratedColumn<int> get cantidadNumeros => _cantidadNumeros ??=
      GeneratedColumn<int>('cantidad_numeros', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedColumn<int> _status;
  @override
  GeneratedColumn<int> get status =>
      _status ??= GeneratedColumn<int>('status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, descripcion, created_at, bolos, cantidadNumeros, status];
  @override
  String get aliasedName => _alias ?? 'draws';
  @override
  String get actualTableName => 'draws';
  @override
  VerificationContext validateIntegrity(Insertable<Draw> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('bolos')) {
      context.handle(
          _bolosMeta, bolos.isAcceptableOrUnknown(data['bolos'], _bolosMeta));
    } else if (isInserting) {
      context.missing(_bolosMeta);
    }
    if (data.containsKey('cantidad_numeros')) {
      context.handle(
          _cantidadNumerosMeta,
          cantidadNumeros.isAcceptableOrUnknown(
              data['cantidad_numeros'], _cantidadNumerosMeta));
    } else if (isInserting) {
      context.missing(_cantidadNumerosMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Draw map(Map<String, dynamic> data, {String tablePrefix}) {
    return Draw.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DrawsTable createAlias(String alias) {
    return $DrawsTable(_db, alias);
  }
}

class Blocksdirty extends DataClass implements Insertable<Blocksdirty> {
  final int id;
  final int idBanca;
  final int idLoteria;
  final int idSorteo;
  final int cantidad;
  final DateTime created_at;
  final int idMoneda;
  Blocksdirty(
      {@required this.id,
      @required this.idBanca,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.cantidad,
      this.created_at,
      @required this.idMoneda});
  factory Blocksdirty.fromData(Map<String, dynamic> data, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blocksdirty(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idBanca: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_banca']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      cantidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cantidad']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idBanca != null) {
      map['id_banca'] = Variable<int>(idBanca);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || cantidad != null) {
      map['cantidad'] = Variable<int>(cantidad);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    return map;
  }

  BlocksdirtysCompanion toCompanion(bool nullToAbsent) {
    return BlocksdirtysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idBanca: idBanca == null && nullToAbsent
          ? const Value.absent()
          : Value(idBanca),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      cantidad: cantidad == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidad),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
    );
  }

  factory Blocksdirty.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blocksdirty(
      id: serializer.fromJson<int>(json['id']),
      idBanca: serializer.fromJson<int>(json['idBanca']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBanca': serializer.toJson<int>(idBanca),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'cantidad': serializer.toJson<int>(cantidad),
      'created_at': serializer.toJson<DateTime>(created_at),
      'idMoneda': serializer.toJson<int>(idMoneda),
    };
  }

  Blocksdirty copyWith(
          {int id,
          int idBanca,
          int idLoteria,
          int idSorteo,
          int cantidad,
          DateTime created_at,
          int idMoneda}) =>
      Blocksdirty(
        id: id ?? this.id,
        idBanca: idBanca ?? this.idBanca,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        cantidad: cantidad ?? this.cantidad,
        created_at: created_at ?? this.created_at,
        idMoneda: idMoneda ?? this.idMoneda,
      );
  @override
  String toString() {
    return (StringBuffer('Blocksdirty(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('cantidad: $cantidad, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, idBanca, idLoteria, idSorteo, cantidad, created_at, idMoneda);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocksdirty &&
          other.id == this.id &&
          other.idBanca == this.idBanca &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.cantidad == this.cantidad &&
          other.created_at == this.created_at &&
          other.idMoneda == this.idMoneda);
}

class BlocksdirtysCompanion extends UpdateCompanion<Blocksdirty> {
  final Value<int> id;
  final Value<int> idBanca;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<int> cantidad;
  final Value<DateTime> created_at;
  final Value<int> idMoneda;
  const BlocksdirtysCompanion({
    this.id = const Value.absent(),
    this.idBanca = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.created_at = const Value.absent(),
    this.idMoneda = const Value.absent(),
  });
  BlocksdirtysCompanion.insert({
    this.id = const Value.absent(),
    @required int idBanca,
    @required int idLoteria,
    @required int idSorteo,
    @required int cantidad,
    this.created_at = const Value.absent(),
    @required int idMoneda,
  })  : idBanca = Value(idBanca),
        idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        cantidad = Value(cantidad),
        idMoneda = Value(idMoneda);
  static Insertable<Blocksdirty> custom({
    Expression<int> id,
    Expression<int> idBanca,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<int> cantidad,
    Expression<DateTime> created_at,
    Expression<int> idMoneda,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBanca != null) 'id_banca': idBanca,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (cantidad != null) 'cantidad': cantidad,
      if (created_at != null) 'created_at': created_at,
      if (idMoneda != null) 'id_moneda': idMoneda,
    });
  }

  BlocksdirtysCompanion copyWith(
      {Value<int> id,
      Value<int> idBanca,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<int> cantidad,
      Value<DateTime> created_at,
      Value<int> idMoneda}) {
    return BlocksdirtysCompanion(
      id: id ?? this.id,
      idBanca: idBanca ?? this.idBanca,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      cantidad: cantidad ?? this.cantidad,
      created_at: created_at ?? this.created_at,
      idMoneda: idMoneda ?? this.idMoneda,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBanca.present) {
      map['id_banca'] = Variable<int>(idBanca.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksdirtysCompanion(')
          ..write('id: $id, ')
          ..write('idBanca: $idBanca, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('cantidad: $cantidad, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }
}

class $BlocksdirtysTable extends Blocksdirtys
    with TableInfo<$BlocksdirtysTable, Blocksdirty> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlocksdirtysTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idBancaMeta = const VerificationMeta('idBanca');
  GeneratedColumn<int> _idBanca;
  @override
  GeneratedColumn<int> get idBanca =>
      _idBanca ??= GeneratedColumn<int>('id_banca', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _cantidadMeta = const VerificationMeta('cantidad');
  GeneratedColumn<int> _cantidad;
  @override
  GeneratedColumn<int> get cantidad =>
      _cantidad ??= GeneratedColumn<int>('cantidad', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idBanca, idLoteria, idSorteo, cantidad, created_at, idMoneda];
  @override
  String get aliasedName => _alias ?? 'blocksdirtys';
  @override
  String get actualTableName => 'blocksdirtys';
  @override
  VerificationContext validateIntegrity(Insertable<Blocksdirty> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_banca')) {
      context.handle(_idBancaMeta,
          idBanca.isAcceptableOrUnknown(data['id_banca'], _idBancaMeta));
    } else if (isInserting) {
      context.missing(_idBancaMeta);
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad'], _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blocksdirty map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blocksdirty.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlocksdirtysTable createAlias(String alias) {
    return $BlocksdirtysTable(_db, alias);
  }
}

class Blocksdirtygeneral extends DataClass
    implements Insertable<Blocksdirtygeneral> {
  final int id;
  final int idLoteria;
  final int idSorteo;
  final int cantidad;
  final DateTime created_at;
  final int idMoneda;
  Blocksdirtygeneral(
      {@required this.id,
      @required this.idLoteria,
      @required this.idSorteo,
      @required this.cantidad,
      this.created_at,
      @required this.idMoneda});
  factory Blocksdirtygeneral.fromData(Map<String, dynamic> data,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Blocksdirtygeneral(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idLoteria: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_loteria']),
      idSorteo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_sorteo']),
      cantidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cantidad']),
      created_at: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      idMoneda: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_moneda']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idLoteria != null) {
      map['id_loteria'] = Variable<int>(idLoteria);
    }
    if (!nullToAbsent || idSorteo != null) {
      map['id_sorteo'] = Variable<int>(idSorteo);
    }
    if (!nullToAbsent || cantidad != null) {
      map['cantidad'] = Variable<int>(cantidad);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || idMoneda != null) {
      map['id_moneda'] = Variable<int>(idMoneda);
    }
    return map;
  }

  BlocksdirtygeneralsCompanion toCompanion(bool nullToAbsent) {
    return BlocksdirtygeneralsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idLoteria: idLoteria == null && nullToAbsent
          ? const Value.absent()
          : Value(idLoteria),
      idSorteo: idSorteo == null && nullToAbsent
          ? const Value.absent()
          : Value(idSorteo),
      cantidad: cantidad == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidad),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      idMoneda: idMoneda == null && nullToAbsent
          ? const Value.absent()
          : Value(idMoneda),
    );
  }

  factory Blocksdirtygeneral.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Blocksdirtygeneral(
      id: serializer.fromJson<int>(json['id']),
      idLoteria: serializer.fromJson<int>(json['idLoteria']),
      idSorteo: serializer.fromJson<int>(json['idSorteo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      created_at: serializer.fromJson<DateTime>(json['created_at']),
      idMoneda: serializer.fromJson<int>(json['idMoneda']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idLoteria': serializer.toJson<int>(idLoteria),
      'idSorteo': serializer.toJson<int>(idSorteo),
      'cantidad': serializer.toJson<int>(cantidad),
      'created_at': serializer.toJson<DateTime>(created_at),
      'idMoneda': serializer.toJson<int>(idMoneda),
    };
  }

  Blocksdirtygeneral copyWith(
          {int id,
          int idLoteria,
          int idSorteo,
          int cantidad,
          DateTime created_at,
          int idMoneda}) =>
      Blocksdirtygeneral(
        id: id ?? this.id,
        idLoteria: idLoteria ?? this.idLoteria,
        idSorteo: idSorteo ?? this.idSorteo,
        cantidad: cantidad ?? this.cantidad,
        created_at: created_at ?? this.created_at,
        idMoneda: idMoneda ?? this.idMoneda,
      );
  @override
  String toString() {
    return (StringBuffer('Blocksdirtygeneral(')
          ..write('id: $id, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('cantidad: $cantidad, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idLoteria, idSorteo, cantidad, created_at, idMoneda);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocksdirtygeneral &&
          other.id == this.id &&
          other.idLoteria == this.idLoteria &&
          other.idSorteo == this.idSorteo &&
          other.cantidad == this.cantidad &&
          other.created_at == this.created_at &&
          other.idMoneda == this.idMoneda);
}

class BlocksdirtygeneralsCompanion extends UpdateCompanion<Blocksdirtygeneral> {
  final Value<int> id;
  final Value<int> idLoteria;
  final Value<int> idSorteo;
  final Value<int> cantidad;
  final Value<DateTime> created_at;
  final Value<int> idMoneda;
  const BlocksdirtygeneralsCompanion({
    this.id = const Value.absent(),
    this.idLoteria = const Value.absent(),
    this.idSorteo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.created_at = const Value.absent(),
    this.idMoneda = const Value.absent(),
  });
  BlocksdirtygeneralsCompanion.insert({
    this.id = const Value.absent(),
    @required int idLoteria,
    @required int idSorteo,
    @required int cantidad,
    this.created_at = const Value.absent(),
    @required int idMoneda,
  })  : idLoteria = Value(idLoteria),
        idSorteo = Value(idSorteo),
        cantidad = Value(cantidad),
        idMoneda = Value(idMoneda);
  static Insertable<Blocksdirtygeneral> custom({
    Expression<int> id,
    Expression<int> idLoteria,
    Expression<int> idSorteo,
    Expression<int> cantidad,
    Expression<DateTime> created_at,
    Expression<int> idMoneda,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idLoteria != null) 'id_loteria': idLoteria,
      if (idSorteo != null) 'id_sorteo': idSorteo,
      if (cantidad != null) 'cantidad': cantidad,
      if (created_at != null) 'created_at': created_at,
      if (idMoneda != null) 'id_moneda': idMoneda,
    });
  }

  BlocksdirtygeneralsCompanion copyWith(
      {Value<int> id,
      Value<int> idLoteria,
      Value<int> idSorteo,
      Value<int> cantidad,
      Value<DateTime> created_at,
      Value<int> idMoneda}) {
    return BlocksdirtygeneralsCompanion(
      id: id ?? this.id,
      idLoteria: idLoteria ?? this.idLoteria,
      idSorteo: idSorteo ?? this.idSorteo,
      cantidad: cantidad ?? this.cantidad,
      created_at: created_at ?? this.created_at,
      idMoneda: idMoneda ?? this.idMoneda,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idLoteria.present) {
      map['id_loteria'] = Variable<int>(idLoteria.value);
    }
    if (idSorteo.present) {
      map['id_sorteo'] = Variable<int>(idSorteo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (idMoneda.present) {
      map['id_moneda'] = Variable<int>(idMoneda.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksdirtygeneralsCompanion(')
          ..write('id: $id, ')
          ..write('idLoteria: $idLoteria, ')
          ..write('idSorteo: $idSorteo, ')
          ..write('cantidad: $cantidad, ')
          ..write('created_at: $created_at, ')
          ..write('idMoneda: $idMoneda')
          ..write(')'))
        .toString();
  }
}

class $BlocksdirtygeneralsTable extends Blocksdirtygenerals
    with TableInfo<$BlocksdirtygeneralsTable, Blocksdirtygeneral> {
  final GeneratedDatabase _db;
  final String _alias;
  $BlocksdirtygeneralsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idLoteriaMeta = const VerificationMeta('idLoteria');
  GeneratedColumn<int> _idLoteria;
  @override
  GeneratedColumn<int> get idLoteria =>
      _idLoteria ??= GeneratedColumn<int>('id_loteria', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _idSorteoMeta = const VerificationMeta('idSorteo');
  GeneratedColumn<int> _idSorteo;
  @override
  GeneratedColumn<int> get idSorteo =>
      _idSorteo ??= GeneratedColumn<int>('id_sorteo', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _cantidadMeta = const VerificationMeta('cantidad');
  GeneratedColumn<int> _cantidad;
  @override
  GeneratedColumn<int> get cantidad =>
      _cantidad ??= GeneratedColumn<int>('cantidad', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _created_atMeta = const VerificationMeta('created_at');
  GeneratedColumn<DateTime> _created_at;
  @override
  GeneratedColumn<DateTime> get created_at =>
      _created_at ??= GeneratedColumn<DateTime>('created_at', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _idMonedaMeta = const VerificationMeta('idMoneda');
  GeneratedColumn<int> _idMoneda;
  @override
  GeneratedColumn<int> get idMoneda =>
      _idMoneda ??= GeneratedColumn<int>('id_moneda', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idLoteria, idSorteo, cantidad, created_at, idMoneda];
  @override
  String get aliasedName => _alias ?? 'blocksdirtygenerals';
  @override
  String get actualTableName => 'blocksdirtygenerals';
  @override
  VerificationContext validateIntegrity(Insertable<Blocksdirtygeneral> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_loteria')) {
      context.handle(_idLoteriaMeta,
          idLoteria.isAcceptableOrUnknown(data['id_loteria'], _idLoteriaMeta));
    } else if (isInserting) {
      context.missing(_idLoteriaMeta);
    }
    if (data.containsKey('id_sorteo')) {
      context.handle(_idSorteoMeta,
          idSorteo.isAcceptableOrUnknown(data['id_sorteo'], _idSorteoMeta));
    } else if (isInserting) {
      context.missing(_idSorteoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad'], _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at'], _created_atMeta));
    }
    if (data.containsKey('id_moneda')) {
      context.handle(_idMonedaMeta,
          idMoneda.isAcceptableOrUnknown(data['id_moneda'], _idMonedaMeta));
    } else if (isInserting) {
      context.missing(_idMonedaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Blocksdirtygeneral map(Map<String, dynamic> data, {String tablePrefix}) {
    return Blocksdirtygeneral.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BlocksdirtygeneralsTable createAlias(String alias) {
    return $BlocksdirtygeneralsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  $PermissionsTable _permissions;
  $PermissionsTable get permissions => _permissions ??= $PermissionsTable(this);
  $DaysTable _days;
  $DaysTable get days => _days ??= $DaysTable(this);
  $LotteriesTable _lotteries;
  $LotteriesTable get lotteries => _lotteries ??= $LotteriesTable(this);
  $UsersTable _users;
  $UsersTable get users => _users ??= $UsersTable(this);
  $SettingsTable _settings;
  $SettingsTable get settings => _settings ??= $SettingsTable(this);
  $BranchsTable _branchs;
  $BranchsTable get branchs => _branchs ??= $BranchsTable(this);
  $ServersTable _servers;
  $ServersTable get servers => _servers ??= $ServersTable(this);
  $StocksTable _stocks;
  $StocksTable get stocks => _stocks ??= $StocksTable(this);
  $BlocksgeneralsTable _blocksgenerals;
  $BlocksgeneralsTable get blocksgenerals =>
      _blocksgenerals ??= $BlocksgeneralsTable(this);
  $BlockslotteriesTable _blockslotteries;
  $BlockslotteriesTable get blockslotteries =>
      _blockslotteries ??= $BlockslotteriesTable(this);
  $BlocksplaysTable _blocksplays;
  $BlocksplaysTable get blocksplays => _blocksplays ??= $BlocksplaysTable(this);
  $BlocksplaysgeneralsTable _blocksplaysgenerals;
  $BlocksplaysgeneralsTable get blocksplaysgenerals =>
      _blocksplaysgenerals ??= $BlocksplaysgeneralsTable(this);
  $DrawsTable _draws;
  $DrawsTable get draws => _draws ??= $DrawsTable(this);
  $BlocksdirtysTable _blocksdirtys;
  $BlocksdirtysTable get blocksdirtys =>
      _blocksdirtys ??= $BlocksdirtysTable(this);
  $BlocksdirtygeneralsTable _blocksdirtygenerals;
  $BlocksdirtygeneralsTable get blocksdirtygenerals =>
      _blocksdirtygenerals ??= $BlocksdirtygeneralsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tasks,
        permissions,
        days,
        lotteries,
        users,
        settings,
        branchs,
        servers,
        stocks,
        blocksgenerals,
        blockslotteries,
        blocksplays,
        blocksplaysgenerals,
        draws,
        blocksdirtys,
        blocksdirtygenerals
      ];
}
