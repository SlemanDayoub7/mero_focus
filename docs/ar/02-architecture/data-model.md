# نموذج البيانات (Drift Schema)

راجع ADR-0004 لأسباب اختيار Drift، وADR-0005 لمبدأ "البيانات الخام فقط" الذي بُني عليه هذا التصميم.

## الجداول

### `FocusSessions`
السجل الخام لكل جلسة بومودورو. هذا الجدول هو مصدر الحقيقة الوحيد لكل الإحصائيات.

```dart
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get plannedDurationSeconds => integer()();
  IntColumn get actualDurationSeconds => integer()();
  IntColumn get sessionType => integer()(); // 0=work, 1=shortBreak, 2=longBreak
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  IntColumn get completionPercentage => integer().withDefault(const Constant(100))();
  IntColumn get tagId => integer().nullable().references(Tags, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

@TableIndex(name: 'idx_session_start', columns: {#startTime})
```

### `Tags`
تصنيف اختياري للجلسات (دراسة، شغل، قراءة...).

```dart
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
}
```

### `Habits`
```dart
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get frequencyType => integer()(); // daily / weeklyXDays / customMask
  TextColumn get frequencyConfig => text()(); // JSON بسيط
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}
```

### `HabitLogs`
```dart
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  DateTimeColumn get date => dateTime()(); // بداية اليوم فقط (00:00)
  BoolColumn get completed => boolean()();
  RealColumn get value => real().nullable()(); // لعادات قابلة للقياس

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

@TableIndex(name: 'idx_habitlog_date', columns: {#date})
```

### `AppLockRules`
```dart
class AppLockRules extends Table {
  TextColumn get packageName => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {packageName};
}
```

### `AppSettings`
صف واحد دائمًا (id = 0).

```dart
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get workDurationSec => integer().withDefault(const Constant(1500))();
  IntColumn get shortBreakSec => integer().withDefault(const Constant(300))();
  IntColumn get longBreakSec => integer().withDefault(const Constant(900))();
  IntColumn get roundsBeforeLongBreak => integer().withDefault(const Constant(4))();
  TextColumn get themeId => text().withDefault(const Constant('default'))();
  TextColumn get backgroundId => text().withDefault(const Constant('default'))();
  TextColumn get whiteNoiseSoundId => text().nullable()();
  TextColumn get timerEndSoundId => text().withDefault(const Constant('default_bell'))();
  BoolColumn get appLockEnabled => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

## مبدأ أساسي: لا تخزين لأي حالة "مود/مستوى"

انظر ADR-0005. أي ميزة مستقبلية من نوع جيمفكيشن تُبنى كطبقة حساب فوق `FocusSessions` و`HabitLogs`، وليس كجدول إضافي يخزّن حالة.

## أمثلة استعلامات التجميع (Statistics)

### إحصائية يومية
```dart
Future<List<DailyFocusStat>> getDailyStats(DateTime from, DateTime to) {
  final query = customSelect(
    '''
    SELECT date(start_time) as day, SUM(actual_duration_seconds) as total
    FROM focus_sessions
    WHERE start_time BETWEEN ? AND ? AND session_type = 0 AND completed = 1
    GROUP BY day ORDER BY day
    ''',
    variables: [Variable.withDateTime(from), Variable.withDateTime(to)],
    readsFrom: {focusSessions},
  );
  return query.map((row) => DailyFocusStat(
    day: DateTime.parse(row.read<String>('day')),
    totalSeconds: row.read<int>('total'),
  )).get();
}
```

> **ملاحظة تنفيذية:** Drift يخزّن `DateTime` كعدد صحيح (milliseconds) وليس كنص ISO. عند كتابة أول استعلام إحصائي فعلي يجب تكييف دوال SQLite الزمنية (مثل `datetime(start_time / 1000, 'unixepoch')` أو عمود مشتق `expressed column`) بدل افتراض أن `date(start_time)` تعمل مباشرة. يُحدَّث هذا المستند عند تثبيت الصيغة النهائية للاستعلامات.

نفس النمط ينطبق على:
- **إحصائية بالساعة:** `strftime('%H', start_time)` بدل `date(start_time)`.
- **إحصائية أسبوعية:** `strftime('%Y-%W', start_time)`.
- **إحصائية شهرية:** `strftime('%Y-%m', start_time)`.
- **إحصائية سنوية:** `strftime('%Y', start_time)`.
- **فترة مخصصة:** نفس استعلام `WHERE start_time BETWEEN ? AND ?` بدون `GROUP BY` يومي، مع `SUM` مباشر.
