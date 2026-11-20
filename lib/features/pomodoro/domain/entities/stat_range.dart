/// Granularity used by the reports and statistics.
enum StatRange {
  day,
  week,
  month,
  year;

  /// Number of chart buckets needed for this range.
  int bucketCount(DateTime now) => switch (this) {
    StatRange.day => 24,
    StatRange.week => 7,
    StatRange.month => DateTime(now.year, now.month + 1, 0).day,
    StatRange.year => 12,
  };
}
