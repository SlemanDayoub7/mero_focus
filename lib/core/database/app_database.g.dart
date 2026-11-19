// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorHex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final String colorHex;
  const Tag({required this.id, required this.name, required this.colorHex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
    };
  }

  Tag copyWith({int? id, String? name, String? colorHex}) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorHex;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String colorHex,
  }) : name = Value(name),
       colorHex = Value(colorHex);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? colorHex,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
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
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationSecondsMeta =
      const VerificationMeta('plannedDurationSeconds');
  @override
  late final GeneratedColumn<int> plannedDurationSeconds = GeneratedColumn<int>(
    'planned_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDurationSecondsMeta =
      const VerificationMeta('actualDurationSeconds');
  @override
  late final GeneratedColumn<int> actualDurationSeconds = GeneratedColumn<int>(
    'actual_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionTypeMeta = const VerificationMeta(
    'sessionType',
  );
  @override
  late final GeneratedColumn<int> sessionType = GeneratedColumn<int>(
    'session_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _completionPercentageMeta =
      const VerificationMeta('completionPercentage');
  @override
  late final GeneratedColumn<int> completionPercentage = GeneratedColumn<int>(
    'completion_percentage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startTime,
    endTime,
    plannedDurationSeconds,
    actualDurationSeconds,
    sessionType,
    completed,
    completionPercentage,
    tagId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('planned_duration_seconds')) {
      context.handle(
        _plannedDurationSecondsMeta,
        plannedDurationSeconds.isAcceptableOrUnknown(
          data['planned_duration_seconds']!,
          _plannedDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationSecondsMeta);
    }
    if (data.containsKey('actual_duration_seconds')) {
      context.handle(
        _actualDurationSecondsMeta,
        actualDurationSeconds.isAcceptableOrUnknown(
          data['actual_duration_seconds']!,
          _actualDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualDurationSecondsMeta);
    }
    if (data.containsKey('session_type')) {
      context.handle(
        _sessionTypeMeta,
        sessionType.isAcceptableOrUnknown(
          data['session_type']!,
          _sessionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionTypeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completion_percentage')) {
      context.handle(
        _completionPercentageMeta,
        completionPercentage.isAcceptableOrUnknown(
          data['completion_percentage']!,
          _completionPercentageMeta,
        ),
      );
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      plannedDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_seconds'],
      )!,
      actualDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_seconds'],
      )!,
      sessionType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_type'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completionPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion_percentage'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      ),
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final int plannedDurationSeconds;
  final int actualDurationSeconds;
  final int sessionType;
  final bool completed;
  final int completionPercentage;
  final int? tagId;
  const FocusSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.plannedDurationSeconds,
    required this.actualDurationSeconds,
    required this.sessionType,
    required this.completed,
    required this.completionPercentage,
    this.tagId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['planned_duration_seconds'] = Variable<int>(plannedDurationSeconds);
    map['actual_duration_seconds'] = Variable<int>(actualDurationSeconds);
    map['session_type'] = Variable<int>(sessionType);
    map['completed'] = Variable<bool>(completed);
    map['completion_percentage'] = Variable<int>(completionPercentage);
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<int>(tagId);
    }
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      plannedDurationSeconds: Value(plannedDurationSeconds),
      actualDurationSeconds: Value(actualDurationSeconds),
      sessionType: Value(sessionType),
      completed: Value(completed),
      completionPercentage: Value(completionPercentage),
      tagId: tagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tagId),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      plannedDurationSeconds: serializer.fromJson<int>(
        json['plannedDurationSeconds'],
      ),
      actualDurationSeconds: serializer.fromJson<int>(
        json['actualDurationSeconds'],
      ),
      sessionType: serializer.fromJson<int>(json['sessionType']),
      completed: serializer.fromJson<bool>(json['completed']),
      completionPercentage: serializer.fromJson<int>(
        json['completionPercentage'],
      ),
      tagId: serializer.fromJson<int?>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'plannedDurationSeconds': serializer.toJson<int>(plannedDurationSeconds),
      'actualDurationSeconds': serializer.toJson<int>(actualDurationSeconds),
      'sessionType': serializer.toJson<int>(sessionType),
      'completed': serializer.toJson<bool>(completed),
      'completionPercentage': serializer.toJson<int>(completionPercentage),
      'tagId': serializer.toJson<int?>(tagId),
    };
  }

  FocusSession copyWith({
    int? id,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    int? plannedDurationSeconds,
    int? actualDurationSeconds,
    int? sessionType,
    bool? completed,
    int? completionPercentage,
    Value<int?> tagId = const Value.absent(),
  }) => FocusSession(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    plannedDurationSeconds:
        plannedDurationSeconds ?? this.plannedDurationSeconds,
    actualDurationSeconds: actualDurationSeconds ?? this.actualDurationSeconds,
    sessionType: sessionType ?? this.sessionType,
    completed: completed ?? this.completed,
    completionPercentage: completionPercentage ?? this.completionPercentage,
    tagId: tagId.present ? tagId.value : this.tagId,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      plannedDurationSeconds: data.plannedDurationSeconds.present
          ? data.plannedDurationSeconds.value
          : this.plannedDurationSeconds,
      actualDurationSeconds: data.actualDurationSeconds.present
          ? data.actualDurationSeconds.value
          : this.actualDurationSeconds,
      sessionType: data.sessionType.present
          ? data.sessionType.value
          : this.sessionType,
      completed: data.completed.present ? data.completed.value : this.completed,
      completionPercentage: data.completionPercentage.present
          ? data.completionPercentage.value
          : this.completionPercentage,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('plannedDurationSeconds: $plannedDurationSeconds, ')
          ..write('actualDurationSeconds: $actualDurationSeconds, ')
          ..write('sessionType: $sessionType, ')
          ..write('completed: $completed, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startTime,
    endTime,
    plannedDurationSeconds,
    actualDurationSeconds,
    sessionType,
    completed,
    completionPercentage,
    tagId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.plannedDurationSeconds == this.plannedDurationSeconds &&
          other.actualDurationSeconds == this.actualDurationSeconds &&
          other.sessionType == this.sessionType &&
          other.completed == this.completed &&
          other.completionPercentage == this.completionPercentage &&
          other.tagId == this.tagId);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> plannedDurationSeconds;
  final Value<int> actualDurationSeconds;
  final Value<int> sessionType;
  final Value<bool> completed;
  final Value<int> completionPercentage;
  final Value<int?> tagId;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.plannedDurationSeconds = const Value.absent(),
    this.actualDurationSeconds = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.completed = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.tagId = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    required int plannedDurationSeconds,
    required int actualDurationSeconds,
    required int sessionType,
    this.completed = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.tagId = const Value.absent(),
  }) : startTime = Value(startTime),
       plannedDurationSeconds = Value(plannedDurationSeconds),
       actualDurationSeconds = Value(actualDurationSeconds),
       sessionType = Value(sessionType);
  static Insertable<FocusSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? plannedDurationSeconds,
    Expression<int>? actualDurationSeconds,
    Expression<int>? sessionType,
    Expression<bool>? completed,
    Expression<int>? completionPercentage,
    Expression<int>? tagId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (plannedDurationSeconds != null)
        'planned_duration_seconds': plannedDurationSeconds,
      if (actualDurationSeconds != null)
        'actual_duration_seconds': actualDurationSeconds,
      if (sessionType != null) 'session_type': sessionType,
      if (completed != null) 'completed': completed,
      if (completionPercentage != null)
        'completion_percentage': completionPercentage,
      if (tagId != null) 'tag_id': tagId,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int>? plannedDurationSeconds,
    Value<int>? actualDurationSeconds,
    Value<int>? sessionType,
    Value<bool>? completed,
    Value<int>? completionPercentage,
    Value<int?>? tagId,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      plannedDurationSeconds:
          plannedDurationSeconds ?? this.plannedDurationSeconds,
      actualDurationSeconds:
          actualDurationSeconds ?? this.actualDurationSeconds,
      sessionType: sessionType ?? this.sessionType,
      completed: completed ?? this.completed,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      tagId: tagId ?? this.tagId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (plannedDurationSeconds.present) {
      map['planned_duration_seconds'] = Variable<int>(
        plannedDurationSeconds.value,
      );
    }
    if (actualDurationSeconds.present) {
      map['actual_duration_seconds'] = Variable<int>(
        actualDurationSeconds.value,
      );
    }
    if (sessionType.present) {
      map['session_type'] = Variable<int>(sessionType.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completionPercentage.present) {
      map['completion_percentage'] = Variable<int>(completionPercentage.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('plannedDurationSeconds: $plannedDurationSeconds, ')
          ..write('actualDurationSeconds: $actualDurationSeconds, ')
          ..write('sessionType: $sessionType, ')
          ..write('completed: $completed, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyTypeMeta = const VerificationMeta(
    'frequencyType',
  );
  @override
  late final GeneratedColumn<int> frequencyType = GeneratedColumn<int>(
    'frequency_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyConfigMeta = const VerificationMeta(
    'frequencyConfig',
  );
  @override
  late final GeneratedColumn<String> frequencyConfig = GeneratedColumn<String>(
    'frequency_config',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    frequencyType,
    frequencyConfig,
    createdAt,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('frequency_type')) {
      context.handle(
        _frequencyTypeMeta,
        frequencyType.isAcceptableOrUnknown(
          data['frequency_type']!,
          _frequencyTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyTypeMeta);
    }
    if (data.containsKey('frequency_config')) {
      context.handle(
        _frequencyConfigMeta,
        frequencyConfig.isAcceptableOrUnknown(
          data['frequency_config']!,
          _frequencyConfigMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyConfigMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      frequencyType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_type'],
      )!,
      frequencyConfig: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_config'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String name;
  final String icon;
  final int frequencyType;
  final String frequencyConfig;
  final DateTime createdAt;
  final bool archived;
  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.frequencyType,
    required this.frequencyConfig,
    required this.createdAt,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['frequency_type'] = Variable<int>(frequencyType);
    map['frequency_config'] = Variable<String>(frequencyConfig);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      frequencyType: Value(frequencyType),
      frequencyConfig: Value(frequencyConfig),
      createdAt: Value(createdAt),
      archived: Value(archived),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      frequencyType: serializer.fromJson<int>(json['frequencyType']),
      frequencyConfig: serializer.fromJson<String>(json['frequencyConfig']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'frequencyType': serializer.toJson<int>(frequencyType),
      'frequencyConfig': serializer.toJson<String>(frequencyConfig),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    String? icon,
    int? frequencyType,
    String? frequencyConfig,
    DateTime? createdAt,
    bool? archived,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    frequencyType: frequencyType ?? this.frequencyType,
    frequencyConfig: frequencyConfig ?? this.frequencyConfig,
    createdAt: createdAt ?? this.createdAt,
    archived: archived ?? this.archived,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      frequencyType: data.frequencyType.present
          ? data.frequencyType.value
          : this.frequencyType,
      frequencyConfig: data.frequencyConfig.present
          ? data.frequencyConfig.value
          : this.frequencyConfig,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyConfig: $frequencyConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    frequencyType,
    frequencyConfig,
    createdAt,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.frequencyType == this.frequencyType &&
          other.frequencyConfig == this.frequencyConfig &&
          other.createdAt == this.createdAt &&
          other.archived == this.archived);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> frequencyType;
  final Value<String> frequencyConfig;
  final Value<DateTime> createdAt;
  final Value<bool> archived;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.frequencyConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archived = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required int frequencyType,
    required String frequencyConfig,
    this.createdAt = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       frequencyType = Value(frequencyType),
       frequencyConfig = Value(frequencyConfig);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? frequencyType,
    Expression<String>? frequencyConfig,
    Expression<DateTime>? createdAt,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (frequencyConfig != null) 'frequency_config': frequencyConfig,
      if (createdAt != null) 'created_at': createdAt,
      if (archived != null) 'archived': archived,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? frequencyType,
    Value<String>? frequencyConfig,
    Value<DateTime>? createdAt,
    Value<bool>? archived,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyConfig: frequencyConfig ?? this.frequencyConfig,
      createdAt: createdAt ?? this.createdAt,
      archived: archived ?? this.archived,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<int>(frequencyType.value);
    }
    if (frequencyConfig.present) {
      map['frequency_config'] = Variable<String>(frequencyConfig.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyConfig: $frequencyConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $HabitLogsTable extends HabitLogs
    with TableInfo<$HabitLogsTable, HabitLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, habitId, date, completed, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, date},
  ];
  @override
  HabitLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $HabitLogsTable createAlias(String alias) {
    return $HabitLogsTable(attachedDatabase, alias);
  }
}

class HabitLog extends DataClass implements Insertable<HabitLog> {
  final int id;
  final int habitId;
  final DateTime date;
  final bool completed;
  final double? value;
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
    this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['date'] = Variable<DateTime>(date);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    return map;
  }

  HabitLogsCompanion toCompanion(bool nullToAbsent) {
    return HabitLogsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      completed: Value(completed),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory HabitLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLog(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<int>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      value: serializer.fromJson<double?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<int>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'completed': serializer.toJson<bool>(completed),
      'value': serializer.toJson<double?>(value),
    };
  }

  HabitLog copyWith({
    int? id,
    int? habitId,
    DateTime? date,
    bool? completed,
    Value<double?> value = const Value.absent(),
  }) => HabitLog(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    completed: completed ?? this.completed,
    value: value.present ? value.value : this.value,
  );
  HabitLog copyWithCompanion(HabitLogsCompanion data) {
    return HabitLog(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLog(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, date, completed, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLog &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.value == this.value);
}

class HabitLogsCompanion extends UpdateCompanion<HabitLog> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<DateTime> date;
  final Value<bool> completed;
  final Value<double?> value;
  const HabitLogsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.value = const Value.absent(),
  });
  HabitLogsCompanion.insert({
    this.id = const Value.absent(),
    required int habitId,
    required DateTime date,
    required bool completed,
    this.value = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       completed = Value(completed);
  static Insertable<HabitLog> custom({
    Expression<int>? id,
    Expression<int>? habitId,
    Expression<DateTime>? date,
    Expression<bool>? completed,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (value != null) 'value': value,
    });
  }

  HabitLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? habitId,
    Value<DateTime>? date,
    Value<bool>? completed,
    Value<double?>? value,
  }) {
    return HabitLogsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $AppLockRulesTable extends AppLockRules
    with TableInfo<$AppLockRulesTable, AppLockRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppLockRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_lock_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppLockRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  AppLockRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppLockRule(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $AppLockRulesTable createAlias(String alias) {
    return $AppLockRulesTable(attachedDatabase, alias);
  }
}

class AppLockRule extends DataClass implements Insertable<AppLockRule> {
  final String packageName;
  final bool enabled;
  const AppLockRule({required this.packageName, required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AppLockRulesCompanion toCompanion(bool nullToAbsent) {
    return AppLockRulesCompanion(
      packageName: Value(packageName),
      enabled: Value(enabled),
    );
  }

  factory AppLockRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppLockRule(
      packageName: serializer.fromJson<String>(json['packageName']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  AppLockRule copyWith({String? packageName, bool? enabled}) => AppLockRule(
    packageName: packageName ?? this.packageName,
    enabled: enabled ?? this.enabled,
  );
  AppLockRule copyWithCompanion(AppLockRulesCompanion data) {
    return AppLockRule(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppLockRule(')
          ..write('packageName: $packageName, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppLockRule &&
          other.packageName == this.packageName &&
          other.enabled == this.enabled);
}

class AppLockRulesCompanion extends UpdateCompanion<AppLockRule> {
  final Value<String> packageName;
  final Value<bool> enabled;
  final Value<int> rowid;
  const AppLockRulesCompanion({
    this.packageName = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppLockRulesCompanion.insert({
    required String packageName,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName);
  static Insertable<AppLockRule> custom({
    Expression<String>? packageName,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppLockRulesCompanion copyWith({
    Value<String>? packageName,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return AppLockRulesCompanion(
      packageName: packageName ?? this.packageName,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppLockRulesCompanion(')
          ..write('packageName: $packageName, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workDurationSecMeta = const VerificationMeta(
    'workDurationSec',
  );
  @override
  late final GeneratedColumn<int> workDurationSec = GeneratedColumn<int>(
    'work_duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.workDurationSec),
  );
  static const VerificationMeta _shortBreakSecMeta = const VerificationMeta(
    'shortBreakSec',
  );
  @override
  late final GeneratedColumn<int> shortBreakSec = GeneratedColumn<int>(
    'short_break_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.shortBreakSec),
  );
  static const VerificationMeta _longBreakSecMeta = const VerificationMeta(
    'longBreakSec',
  );
  @override
  late final GeneratedColumn<int> longBreakSec = GeneratedColumn<int>(
    'long_break_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.longBreakSec),
  );
  static const VerificationMeta _roundsBeforeLongBreakMeta =
      const VerificationMeta('roundsBeforeLongBreak');
  @override
  late final GeneratedColumn<int> roundsBeforeLongBreak = GeneratedColumn<int>(
    'rounds_before_long_break',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.roundsBeforeLongBreak),
  );
  static const VerificationMeta _themeIdMeta = const VerificationMeta(
    'themeId',
  );
  @override
  late final GeneratedColumn<String> themeId = GeneratedColumn<String>(
    'theme_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.themeId),
  );
  static const VerificationMeta _backgroundIdMeta = const VerificationMeta(
    'backgroundId',
  );
  @override
  late final GeneratedColumn<String> backgroundId = GeneratedColumn<String>(
    'background_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.backgroundId),
  );
  static const VerificationMeta _whiteNoiseSoundIdMeta = const VerificationMeta(
    'whiteNoiseSoundId',
  );
  @override
  late final GeneratedColumn<String> whiteNoiseSoundId =
      GeneratedColumn<String>(
        'white_noise_sound_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timerEndSoundIdMeta = const VerificationMeta(
    'timerEndSoundId',
  );
  @override
  late final GeneratedColumn<String> timerEndSoundId = GeneratedColumn<String>(
    'timer_end_sound_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppDefaults.timerEndSoundId),
  );
  static const VerificationMeta _appLockEnabledMeta = const VerificationMeta(
    'appLockEnabled',
  );
  @override
  late final GeneratedColumn<bool> appLockEnabled = GeneratedColumn<bool>(
    'app_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("app_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workDurationSec,
    shortBreakSec,
    longBreakSec,
    roundsBeforeLongBreak,
    themeId,
    backgroundId,
    whiteNoiseSoundId,
    timerEndSoundId,
    appLockEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_duration_sec')) {
      context.handle(
        _workDurationSecMeta,
        workDurationSec.isAcceptableOrUnknown(
          data['work_duration_sec']!,
          _workDurationSecMeta,
        ),
      );
    }
    if (data.containsKey('short_break_sec')) {
      context.handle(
        _shortBreakSecMeta,
        shortBreakSec.isAcceptableOrUnknown(
          data['short_break_sec']!,
          _shortBreakSecMeta,
        ),
      );
    }
    if (data.containsKey('long_break_sec')) {
      context.handle(
        _longBreakSecMeta,
        longBreakSec.isAcceptableOrUnknown(
          data['long_break_sec']!,
          _longBreakSecMeta,
        ),
      );
    }
    if (data.containsKey('rounds_before_long_break')) {
      context.handle(
        _roundsBeforeLongBreakMeta,
        roundsBeforeLongBreak.isAcceptableOrUnknown(
          data['rounds_before_long_break']!,
          _roundsBeforeLongBreakMeta,
        ),
      );
    }
    if (data.containsKey('theme_id')) {
      context.handle(
        _themeIdMeta,
        themeId.isAcceptableOrUnknown(data['theme_id']!, _themeIdMeta),
      );
    }
    if (data.containsKey('background_id')) {
      context.handle(
        _backgroundIdMeta,
        backgroundId.isAcceptableOrUnknown(
          data['background_id']!,
          _backgroundIdMeta,
        ),
      );
    }
    if (data.containsKey('white_noise_sound_id')) {
      context.handle(
        _whiteNoiseSoundIdMeta,
        whiteNoiseSoundId.isAcceptableOrUnknown(
          data['white_noise_sound_id']!,
          _whiteNoiseSoundIdMeta,
        ),
      );
    }
    if (data.containsKey('timer_end_sound_id')) {
      context.handle(
        _timerEndSoundIdMeta,
        timerEndSoundId.isAcceptableOrUnknown(
          data['timer_end_sound_id']!,
          _timerEndSoundIdMeta,
        ),
      );
    }
    if (data.containsKey('app_lock_enabled')) {
      context.handle(
        _appLockEnabledMeta,
        appLockEnabled.isAcceptableOrUnknown(
          data['app_lock_enabled']!,
          _appLockEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workDurationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_duration_sec'],
      )!,
      shortBreakSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_sec'],
      )!,
      longBreakSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_sec'],
      )!,
      roundsBeforeLongBreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds_before_long_break'],
      )!,
      themeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_id'],
      )!,
      backgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_id'],
      )!,
      whiteNoiseSoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}white_noise_sound_id'],
      ),
      timerEndSoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timer_end_sound_id'],
      )!,
      appLockEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}app_lock_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int workDurationSec;
  final int shortBreakSec;
  final int longBreakSec;
  final int roundsBeforeLongBreak;
  final String themeId;
  final String backgroundId;
  final String? whiteNoiseSoundId;
  final String timerEndSoundId;
  final bool appLockEnabled;
  const AppSetting({
    required this.id,
    required this.workDurationSec,
    required this.shortBreakSec,
    required this.longBreakSec,
    required this.roundsBeforeLongBreak,
    required this.themeId,
    required this.backgroundId,
    this.whiteNoiseSoundId,
    required this.timerEndSoundId,
    required this.appLockEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_duration_sec'] = Variable<int>(workDurationSec);
    map['short_break_sec'] = Variable<int>(shortBreakSec);
    map['long_break_sec'] = Variable<int>(longBreakSec);
    map['rounds_before_long_break'] = Variable<int>(roundsBeforeLongBreak);
    map['theme_id'] = Variable<String>(themeId);
    map['background_id'] = Variable<String>(backgroundId);
    if (!nullToAbsent || whiteNoiseSoundId != null) {
      map['white_noise_sound_id'] = Variable<String>(whiteNoiseSoundId);
    }
    map['timer_end_sound_id'] = Variable<String>(timerEndSoundId);
    map['app_lock_enabled'] = Variable<bool>(appLockEnabled);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      workDurationSec: Value(workDurationSec),
      shortBreakSec: Value(shortBreakSec),
      longBreakSec: Value(longBreakSec),
      roundsBeforeLongBreak: Value(roundsBeforeLongBreak),
      themeId: Value(themeId),
      backgroundId: Value(backgroundId),
      whiteNoiseSoundId: whiteNoiseSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(whiteNoiseSoundId),
      timerEndSoundId: Value(timerEndSoundId),
      appLockEnabled: Value(appLockEnabled),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      workDurationSec: serializer.fromJson<int>(json['workDurationSec']),
      shortBreakSec: serializer.fromJson<int>(json['shortBreakSec']),
      longBreakSec: serializer.fromJson<int>(json['longBreakSec']),
      roundsBeforeLongBreak: serializer.fromJson<int>(
        json['roundsBeforeLongBreak'],
      ),
      themeId: serializer.fromJson<String>(json['themeId']),
      backgroundId: serializer.fromJson<String>(json['backgroundId']),
      whiteNoiseSoundId: serializer.fromJson<String?>(
        json['whiteNoiseSoundId'],
      ),
      timerEndSoundId: serializer.fromJson<String>(json['timerEndSoundId']),
      appLockEnabled: serializer.fromJson<bool>(json['appLockEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workDurationSec': serializer.toJson<int>(workDurationSec),
      'shortBreakSec': serializer.toJson<int>(shortBreakSec),
      'longBreakSec': serializer.toJson<int>(longBreakSec),
      'roundsBeforeLongBreak': serializer.toJson<int>(roundsBeforeLongBreak),
      'themeId': serializer.toJson<String>(themeId),
      'backgroundId': serializer.toJson<String>(backgroundId),
      'whiteNoiseSoundId': serializer.toJson<String?>(whiteNoiseSoundId),
      'timerEndSoundId': serializer.toJson<String>(timerEndSoundId),
      'appLockEnabled': serializer.toJson<bool>(appLockEnabled),
    };
  }

  AppSetting copyWith({
    int? id,
    int? workDurationSec,
    int? shortBreakSec,
    int? longBreakSec,
    int? roundsBeforeLongBreak,
    String? themeId,
    String? backgroundId,
    Value<String?> whiteNoiseSoundId = const Value.absent(),
    String? timerEndSoundId,
    bool? appLockEnabled,
  }) => AppSetting(
    id: id ?? this.id,
    workDurationSec: workDurationSec ?? this.workDurationSec,
    shortBreakSec: shortBreakSec ?? this.shortBreakSec,
    longBreakSec: longBreakSec ?? this.longBreakSec,
    roundsBeforeLongBreak: roundsBeforeLongBreak ?? this.roundsBeforeLongBreak,
    themeId: themeId ?? this.themeId,
    backgroundId: backgroundId ?? this.backgroundId,
    whiteNoiseSoundId: whiteNoiseSoundId.present
        ? whiteNoiseSoundId.value
        : this.whiteNoiseSoundId,
    timerEndSoundId: timerEndSoundId ?? this.timerEndSoundId,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      workDurationSec: data.workDurationSec.present
          ? data.workDurationSec.value
          : this.workDurationSec,
      shortBreakSec: data.shortBreakSec.present
          ? data.shortBreakSec.value
          : this.shortBreakSec,
      longBreakSec: data.longBreakSec.present
          ? data.longBreakSec.value
          : this.longBreakSec,
      roundsBeforeLongBreak: data.roundsBeforeLongBreak.present
          ? data.roundsBeforeLongBreak.value
          : this.roundsBeforeLongBreak,
      themeId: data.themeId.present ? data.themeId.value : this.themeId,
      backgroundId: data.backgroundId.present
          ? data.backgroundId.value
          : this.backgroundId,
      whiteNoiseSoundId: data.whiteNoiseSoundId.present
          ? data.whiteNoiseSoundId.value
          : this.whiteNoiseSoundId,
      timerEndSoundId: data.timerEndSoundId.present
          ? data.timerEndSoundId.value
          : this.timerEndSoundId,
      appLockEnabled: data.appLockEnabled.present
          ? data.appLockEnabled.value
          : this.appLockEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('workDurationSec: $workDurationSec, ')
          ..write('shortBreakSec: $shortBreakSec, ')
          ..write('longBreakSec: $longBreakSec, ')
          ..write('roundsBeforeLongBreak: $roundsBeforeLongBreak, ')
          ..write('themeId: $themeId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('whiteNoiseSoundId: $whiteNoiseSoundId, ')
          ..write('timerEndSoundId: $timerEndSoundId, ')
          ..write('appLockEnabled: $appLockEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workDurationSec,
    shortBreakSec,
    longBreakSec,
    roundsBeforeLongBreak,
    themeId,
    backgroundId,
    whiteNoiseSoundId,
    timerEndSoundId,
    appLockEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.workDurationSec == this.workDurationSec &&
          other.shortBreakSec == this.shortBreakSec &&
          other.longBreakSec == this.longBreakSec &&
          other.roundsBeforeLongBreak == this.roundsBeforeLongBreak &&
          other.themeId == this.themeId &&
          other.backgroundId == this.backgroundId &&
          other.whiteNoiseSoundId == this.whiteNoiseSoundId &&
          other.timerEndSoundId == this.timerEndSoundId &&
          other.appLockEnabled == this.appLockEnabled);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int> workDurationSec;
  final Value<int> shortBreakSec;
  final Value<int> longBreakSec;
  final Value<int> roundsBeforeLongBreak;
  final Value<String> themeId;
  final Value<String> backgroundId;
  final Value<String?> whiteNoiseSoundId;
  final Value<String> timerEndSoundId;
  final Value<bool> appLockEnabled;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.workDurationSec = const Value.absent(),
    this.shortBreakSec = const Value.absent(),
    this.longBreakSec = const Value.absent(),
    this.roundsBeforeLongBreak = const Value.absent(),
    this.themeId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.whiteNoiseSoundId = const Value.absent(),
    this.timerEndSoundId = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.workDurationSec = const Value.absent(),
    this.shortBreakSec = const Value.absent(),
    this.longBreakSec = const Value.absent(),
    this.roundsBeforeLongBreak = const Value.absent(),
    this.themeId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.whiteNoiseSoundId = const Value.absent(),
    this.timerEndSoundId = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? workDurationSec,
    Expression<int>? shortBreakSec,
    Expression<int>? longBreakSec,
    Expression<int>? roundsBeforeLongBreak,
    Expression<String>? themeId,
    Expression<String>? backgroundId,
    Expression<String>? whiteNoiseSoundId,
    Expression<String>? timerEndSoundId,
    Expression<bool>? appLockEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDurationSec != null) 'work_duration_sec': workDurationSec,
      if (shortBreakSec != null) 'short_break_sec': shortBreakSec,
      if (longBreakSec != null) 'long_break_sec': longBreakSec,
      if (roundsBeforeLongBreak != null)
        'rounds_before_long_break': roundsBeforeLongBreak,
      if (themeId != null) 'theme_id': themeId,
      if (backgroundId != null) 'background_id': backgroundId,
      if (whiteNoiseSoundId != null) 'white_noise_sound_id': whiteNoiseSoundId,
      if (timerEndSoundId != null) 'timer_end_sound_id': timerEndSoundId,
      if (appLockEnabled != null) 'app_lock_enabled': appLockEnabled,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? workDurationSec,
    Value<int>? shortBreakSec,
    Value<int>? longBreakSec,
    Value<int>? roundsBeforeLongBreak,
    Value<String>? themeId,
    Value<String>? backgroundId,
    Value<String?>? whiteNoiseSoundId,
    Value<String>? timerEndSoundId,
    Value<bool>? appLockEnabled,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      workDurationSec: workDurationSec ?? this.workDurationSec,
      shortBreakSec: shortBreakSec ?? this.shortBreakSec,
      longBreakSec: longBreakSec ?? this.longBreakSec,
      roundsBeforeLongBreak:
          roundsBeforeLongBreak ?? this.roundsBeforeLongBreak,
      themeId: themeId ?? this.themeId,
      backgroundId: backgroundId ?? this.backgroundId,
      whiteNoiseSoundId: whiteNoiseSoundId ?? this.whiteNoiseSoundId,
      timerEndSoundId: timerEndSoundId ?? this.timerEndSoundId,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workDurationSec.present) {
      map['work_duration_sec'] = Variable<int>(workDurationSec.value);
    }
    if (shortBreakSec.present) {
      map['short_break_sec'] = Variable<int>(shortBreakSec.value);
    }
    if (longBreakSec.present) {
      map['long_break_sec'] = Variable<int>(longBreakSec.value);
    }
    if (roundsBeforeLongBreak.present) {
      map['rounds_before_long_break'] = Variable<int>(
        roundsBeforeLongBreak.value,
      );
    }
    if (themeId.present) {
      map['theme_id'] = Variable<String>(themeId.value);
    }
    if (backgroundId.present) {
      map['background_id'] = Variable<String>(backgroundId.value);
    }
    if (whiteNoiseSoundId.present) {
      map['white_noise_sound_id'] = Variable<String>(whiteNoiseSoundId.value);
    }
    if (timerEndSoundId.present) {
      map['timer_end_sound_id'] = Variable<String>(timerEndSoundId.value);
    }
    if (appLockEnabled.present) {
      map['app_lock_enabled'] = Variable<bool>(appLockEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('workDurationSec: $workDurationSec, ')
          ..write('shortBreakSec: $shortBreakSec, ')
          ..write('longBreakSec: $longBreakSec, ')
          ..write('roundsBeforeLongBreak: $roundsBeforeLongBreak, ')
          ..write('themeId: $themeId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('whiteNoiseSoundId: $whiteNoiseSoundId, ')
          ..write('timerEndSoundId: $timerEndSoundId, ')
          ..write('appLockEnabled: $appLockEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitLogsTable habitLogs = $HabitLogsTable(this);
  late final $AppLockRulesTable appLockRules = $AppLockRulesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index idxSessionStart = Index(
    'idx_session_start',
    'CREATE INDEX idx_session_start ON focus_sessions (start_time)',
  );
  late final Index idxHabitlogDate = Index(
    'idx_habitlog_date',
    'CREATE INDEX idx_habitlog_date ON habit_logs (date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tags,
    focusSessions,
    habits,
    habitLogs,
    appLockRules,
    appSettings,
    idxSessionStart,
    idxHabitlogDate,
  ];
}

typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String name,
      required String colorHex,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> colorHex,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'tags__id__focus_sessions__tag_id',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool focusSessionsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
              }) => TagsCompanion(id: id, name: name, colorHex: colorHex),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String colorHex,
              }) =>
                  TagsCompanion.insert(id: id, name: name, colorHex: colorHex),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({focusSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (focusSessionsRefs) db.focusSessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focusSessionsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, FocusSession>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._focusSessionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TagsTableReferences(
                        db,
                        table,
                        p0,
                      ).focusSessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool focusSessionsRefs})
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      required DateTime startTime,
      Value<DateTime?> endTime,
      required int plannedDurationSeconds,
      required int actualDurationSeconds,
      required int sessionType,
      Value<bool> completed,
      Value<int> completionPercentage,
      Value<int?> tagId,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int> plannedDurationSeconds,
      Value<int> actualDurationSeconds,
      Value<int> sessionType,
      Value<bool> completed,
      Value<int> completionPercentage,
      Value<int?> tagId,
    });

final class $$FocusSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('focus_sessions__tag_id__tags__id');

  $$TagsTableProcessedTableManager? get tagId {
    final $_column = $_itemColumn<int>('tag_id');
    if ($_column == null) return null;
    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationSeconds => $composableBuilder(
    column: $table.actualDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completionPercentage => $composableBuilder(
    column: $table.completionPercentage,
    builder: (column) => ColumnFilters(column),
  );

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationSeconds => $composableBuilder(
    column: $table.actualDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completionPercentage => $composableBuilder(
    column: $table.completionPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationSeconds => $composableBuilder(
    column: $table.actualDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get completionPercentage => $composableBuilder(
    column: $table.completionPercentage,
    builder: (column) => column,
  );

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({bool tagId})
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int> plannedDurationSeconds = const Value.absent(),
                Value<int> actualDurationSeconds = const Value.absent(),
                Value<int> sessionType = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> completionPercentage = const Value.absent(),
                Value<int?> tagId = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                startTime: startTime,
                endTime: endTime,
                plannedDurationSeconds: plannedDurationSeconds,
                actualDurationSeconds: actualDurationSeconds,
                sessionType: sessionType,
                completed: completed,
                completionPercentage: completionPercentage,
                tagId: tagId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                required int plannedDurationSeconds,
                required int actualDurationSeconds,
                required int sessionType,
                Value<bool> completed = const Value.absent(),
                Value<int> completionPercentage = const Value.absent(),
                Value<int?> tagId = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                startTime: startTime,
                endTime: endTime,
                plannedDurationSeconds: plannedDurationSeconds,
                actualDurationSeconds: actualDurationSeconds,
                sessionType: sessionType,
                completed: completed,
                completionPercentage: completionPercentage,
                tagId: tagId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$FocusSessionsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$FocusSessionsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({bool tagId})
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      required int frequencyType,
      required String frequencyConfig,
      Value<DateTime> createdAt,
      Value<bool> archived,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<int> frequencyType,
      Value<String> frequencyConfig,
      Value<DateTime> createdAt,
      Value<bool> archived,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogsTable, List<HabitLog>>
  _habitLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogs,
    aliasName: 'habits__id__habit_logs__habit_id',
  );

  $$HabitLogsTableProcessedTableManager get habitLogsRefs {
    final manager = $$HabitLogsTableTableManager(
      $_db,
      $_db.habitLogs,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyConfig => $composableBuilder(
    column: $table.frequencyConfig,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogsRefs(
    Expression<bool> Function($$HabitLogsTableFilterComposer f) f,
  ) {
    final $$HabitLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableFilterComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyConfig => $composableBuilder(
    column: $table.frequencyConfig,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequencyConfig => $composableBuilder(
    column: $table.frequencyConfig,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> habitLogsRefs<T extends Object>(
    Expression<T> Function($$HabitLogsTableAnnotationComposer a) f,
  ) {
    final $$HabitLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool habitLogsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> frequencyType = const Value.absent(),
                Value<String> frequencyConfig = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                icon: icon,
                frequencyType: frequencyType,
                frequencyConfig: frequencyConfig,
                createdAt: createdAt,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                required int frequencyType,
                required String frequencyConfig,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                frequencyType: frequencyType,
                frequencyConfig: frequencyConfig,
                createdAt: createdAt,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitLogsRefs) db.habitLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogsRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, HabitLog>(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HabitsTableReferences(db, table, p0).habitLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool habitLogsRefs})
    >;
typedef $$HabitLogsTableCreateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<int> id,
      required int habitId,
      required DateTime date,
      required bool completed,
      Value<double?> value,
    });
typedef $$HabitLogsTableUpdateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<int> id,
      Value<int> habitId,
      Value<DateTime> date,
      Value<bool> completed,
      Value<double?> value,
    });

final class $$HabitLogsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitLogsTable, HabitLog> {
  $$HabitLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_logs__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogsTable,
          HabitLog,
          $$HabitLogsTableFilterComposer,
          $$HabitLogsTableOrderingComposer,
          $$HabitLogsTableAnnotationComposer,
          $$HabitLogsTableCreateCompanionBuilder,
          $$HabitLogsTableUpdateCompanionBuilder,
          (HabitLog, $$HabitLogsTableReferences),
          HabitLog,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitLogsTableTableManager(_$AppDatabase db, $HabitLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<double?> value = const Value.absent(),
              }) => HabitLogsCompanion(
                id: id,
                habitId: habitId,
                date: date,
                completed: completed,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int habitId,
                required DateTime date,
                required bool completed,
                Value<double?> value = const Value.absent(),
              }) => HabitLogsCompanion.insert(
                id: id,
                habitId: habitId,
                date: date,
                completed: completed,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$HabitLogsTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$HabitLogsTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogsTable,
      HabitLog,
      $$HabitLogsTableFilterComposer,
      $$HabitLogsTableOrderingComposer,
      $$HabitLogsTableAnnotationComposer,
      $$HabitLogsTableCreateCompanionBuilder,
      $$HabitLogsTableUpdateCompanionBuilder,
      (HabitLog, $$HabitLogsTableReferences),
      HabitLog,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$AppLockRulesTableCreateCompanionBuilder =
    AppLockRulesCompanion Function({
      required String packageName,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$AppLockRulesTableUpdateCompanionBuilder =
    AppLockRulesCompanion Function({
      Value<String> packageName,
      Value<bool> enabled,
      Value<int> rowid,
    });

class $$AppLockRulesTableFilterComposer
    extends Composer<_$AppDatabase, $AppLockRulesTable> {
  $$AppLockRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppLockRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppLockRulesTable> {
  $$AppLockRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppLockRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppLockRulesTable> {
  $$AppLockRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$AppLockRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppLockRulesTable,
          AppLockRule,
          $$AppLockRulesTableFilterComposer,
          $$AppLockRulesTableOrderingComposer,
          $$AppLockRulesTableAnnotationComposer,
          $$AppLockRulesTableCreateCompanionBuilder,
          $$AppLockRulesTableUpdateCompanionBuilder,
          (
            AppLockRule,
            BaseReferences<_$AppDatabase, $AppLockRulesTable, AppLockRule>,
          ),
          AppLockRule,
          PrefetchHooks Function()
        > {
  $$AppLockRulesTableTableManager(_$AppDatabase db, $AppLockRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppLockRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppLockRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppLockRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppLockRulesCompanion(
                packageName: packageName,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppLockRulesCompanion.insert(
                packageName: packageName,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppLockRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppLockRulesTable,
      AppLockRule,
      $$AppLockRulesTableFilterComposer,
      $$AppLockRulesTableOrderingComposer,
      $$AppLockRulesTableAnnotationComposer,
      $$AppLockRulesTableCreateCompanionBuilder,
      $$AppLockRulesTableUpdateCompanionBuilder,
      (
        AppLockRule,
        BaseReferences<_$AppDatabase, $AppLockRulesTable, AppLockRule>,
      ),
      AppLockRule,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> workDurationSec,
      Value<int> shortBreakSec,
      Value<int> longBreakSec,
      Value<int> roundsBeforeLongBreak,
      Value<String> themeId,
      Value<String> backgroundId,
      Value<String?> whiteNoiseSoundId,
      Value<String> timerEndSoundId,
      Value<bool> appLockEnabled,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> workDurationSec,
      Value<int> shortBreakSec,
      Value<int> longBreakSec,
      Value<int> roundsBeforeLongBreak,
      Value<String> themeId,
      Value<String> backgroundId,
      Value<String?> whiteNoiseSoundId,
      Value<String> timerEndSoundId,
      Value<bool> appLockEnabled,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workDurationSec => $composableBuilder(
    column: $table.workDurationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakSec => $composableBuilder(
    column: $table.shortBreakSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakSec => $composableBuilder(
    column: $table.longBreakSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundsBeforeLongBreak => $composableBuilder(
    column: $table.roundsBeforeLongBreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeId => $composableBuilder(
    column: $table.themeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whiteNoiseSoundId => $composableBuilder(
    column: $table.whiteNoiseSoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timerEndSoundId => $composableBuilder(
    column: $table.timerEndSoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workDurationSec => $composableBuilder(
    column: $table.workDurationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakSec => $composableBuilder(
    column: $table.shortBreakSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakSec => $composableBuilder(
    column: $table.longBreakSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundsBeforeLongBreak => $composableBuilder(
    column: $table.roundsBeforeLongBreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeId => $composableBuilder(
    column: $table.themeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whiteNoiseSoundId => $composableBuilder(
    column: $table.whiteNoiseSoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timerEndSoundId => $composableBuilder(
    column: $table.timerEndSoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workDurationSec => $composableBuilder(
    column: $table.workDurationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakSec => $composableBuilder(
    column: $table.shortBreakSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakSec => $composableBuilder(
    column: $table.longBreakSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roundsBeforeLongBreak => $composableBuilder(
    column: $table.roundsBeforeLongBreak,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeId =>
      $composableBuilder(column: $table.themeId, builder: (column) => column);

  GeneratedColumn<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whiteNoiseSoundId => $composableBuilder(
    column: $table.whiteNoiseSoundId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timerEndSoundId => $composableBuilder(
    column: $table.timerEndSoundId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workDurationSec = const Value.absent(),
                Value<int> shortBreakSec = const Value.absent(),
                Value<int> longBreakSec = const Value.absent(),
                Value<int> roundsBeforeLongBreak = const Value.absent(),
                Value<String> themeId = const Value.absent(),
                Value<String> backgroundId = const Value.absent(),
                Value<String?> whiteNoiseSoundId = const Value.absent(),
                Value<String> timerEndSoundId = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                workDurationSec: workDurationSec,
                shortBreakSec: shortBreakSec,
                longBreakSec: longBreakSec,
                roundsBeforeLongBreak: roundsBeforeLongBreak,
                themeId: themeId,
                backgroundId: backgroundId,
                whiteNoiseSoundId: whiteNoiseSoundId,
                timerEndSoundId: timerEndSoundId,
                appLockEnabled: appLockEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workDurationSec = const Value.absent(),
                Value<int> shortBreakSec = const Value.absent(),
                Value<int> longBreakSec = const Value.absent(),
                Value<int> roundsBeforeLongBreak = const Value.absent(),
                Value<String> themeId = const Value.absent(),
                Value<String> backgroundId = const Value.absent(),
                Value<String?> whiteNoiseSoundId = const Value.absent(),
                Value<String> timerEndSoundId = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                workDurationSec: workDurationSec,
                shortBreakSec: shortBreakSec,
                longBreakSec: longBreakSec,
                roundsBeforeLongBreak: roundsBeforeLongBreak,
                themeId: themeId,
                backgroundId: backgroundId,
                whiteNoiseSoundId: whiteNoiseSoundId,
                timerEndSoundId: timerEndSoundId,
                appLockEnabled: appLockEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitLogsTableTableManager get habitLogs =>
      $$HabitLogsTableTableManager(_db, _db.habitLogs);
  $$AppLockRulesTableTableManager get appLockRules =>
      $$AppLockRulesTableTableManager(_db, _db.appLockRules);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
