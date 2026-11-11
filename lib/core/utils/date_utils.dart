/// Date helpers shared by the review scheduler and the UI.
abstract final class AppDateUtils {
  // TODO: return the first instant of the given day.
  static DateTime startOfDay(DateTime date) => throw UnimplementedError();

  // TODO: return the last instant of the given day.
  static DateTime endOfDay(DateTime date) => throw UnimplementedError();

  // TODO: return the whole days between two dates.
  static int daysBetween(DateTime from, DateTime to) =>
      throw UnimplementedError();

  // TODO: format a date for the active locale.
  static String formatDate(DateTime date) => throw UnimplementedError();
}
