import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static late SharedPreferences _prefs;

  // Keys
  static const String _isOnboardingCompleteKey = 'is_onboarding_complete';
  static const String _genderKey = 'user_gender';
  static const String _ageKey = 'user_age';
  static const String _weightKey = 'user_weight';
  static const String _heightKey = 'user_height';
  static const String _goalKey = 'user_goal';
  static const String _activityLevelKey = 'user_activity_level';
  static const String _focusAreaKey = 'user_focus_area';
  static const String _workoutDaysKey = 'user_workout_days';
  static const String _dietKey = 'user_diet';
  static const String _medicalConditionsKey = 'user_medical_conditions';

  // Initialize
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getters
  static bool get isOnboardingComplete => _prefs.getBool(_isOnboardingCompleteKey) ?? false;
  static String? get gender => _prefs.getString(_genderKey);
  static int? get age => _prefs.getInt(_ageKey);
  static double? get weight => _prefs.getDouble(_weightKey);
  static double? get height => _prefs.getDouble(_heightKey);
  static String? get goal => _prefs.getString(_goalKey);
  static String? get activityLevel => _prefs.getString(_activityLevelKey);
  static String? get focusArea => _prefs.getString(_focusAreaKey);
  static int? get workoutDays => _prefs.getInt(_workoutDaysKey);
  static String? get diet => _prefs.getString(_dietKey);
  static String? get medicalConditions => _prefs.getString(_medicalConditionsKey);

  // Setters
  static Future<void> setOnboardingComplete(bool value) async => await _prefs.setBool(_isOnboardingCompleteKey, value);
  static Future<void> setGender(String value) async => await _prefs.setString(_genderKey, value);
  static Future<void> setAge(int value) async => await _prefs.setInt(_ageKey, value);
  static Future<void> setWeight(double value) async => await _prefs.setDouble(_weightKey, value);
  static Future<void> setHeight(double value) async => await _prefs.setDouble(_heightKey, value);
  static Future<void> setGoal(String value) async => await _prefs.setString(_goalKey, value);
  static Future<void> setActivityLevel(String value) async => await _prefs.setString(_activityLevelKey, value);
  static Future<void> setFocusArea(String value) async => await _prefs.setString(_focusAreaKey, value);
  static Future<void> setWorkoutDays(int value) async => await _prefs.setInt(_workoutDaysKey, value);
  static Future<void> setDiet(String value) async => await _prefs.setString(_dietKey, value);
  static Future<void> setMedicalConditions(String value) async => await _prefs.setString(_medicalConditionsKey, value);

  // Clear all data
  static Future<void> clearAll() async => await _prefs.clear();
}
