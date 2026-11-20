/// Stable priority values persisted as integers in `Tasks.priority`.
enum TaskPriority {
  low,
  medium,
  high;

  int get storageValue => switch (this) {
    TaskPriority.low => 0,
    TaskPriority.medium => 1,
    TaskPriority.high => 2,
  };

  static TaskPriority fromStorage(int value) => switch (value) {
    0 => TaskPriority.low,
    2 => TaskPriority.high,
    _ => TaskPriority.medium,
  };
}
