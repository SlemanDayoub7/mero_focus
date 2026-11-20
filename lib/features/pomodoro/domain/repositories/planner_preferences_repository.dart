import '../entities/planner_preferences.dart';

/// Persistence port for the Pomodoro slice of `AppSettings`.
abstract class PlannerPreferencesRepository {
  Stream<PlannerPreferences> watchPreferences();

  Future<void> savePreferences(PlannerPreferences preferences);
}
