import 'package:flutter/material.dart';

import '../../../core/utils/shared_prefs_helper.dart';

class OnboardingProvider extends ChangeNotifier {
  // Navigation State
  final PageController pageController = PageController();
  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  // Onboarding Data State
  String? _gender;
  int? _age;
  double? _weight;
  double? _height;
  String? _goal;
  String? _activityLevel;
  String? _focusArea;
  int? _workoutDays;
  String? _diet;
  String? _medicalConditions;

  // Getters
  String? get gender => _gender;
  int? get age => _age;
  double? get weight => _weight;
  double? get height => _height;
  String? get goal => _goal;
  String? get activityLevel => _activityLevel;
  String? get focusArea => _focusArea;
  int? get workoutDays => _workoutDays;
  String? get diet => _diet;
  String? get medicalConditions => _medicalConditions;

  // Constructor loads existing data
  OnboardingProvider() {
    _loadData();
  }

  void _loadData() {
    _gender = SharedPrefsHelper.gender;
    _age = SharedPrefsHelper.age;
    _weight = SharedPrefsHelper.weight;
    _height = SharedPrefsHelper.height;
    _goal = SharedPrefsHelper.goal;
    _activityLevel = SharedPrefsHelper.activityLevel;
    _focusArea = SharedPrefsHelper.focusArea;
    _workoutDays = SharedPrefsHelper.workoutDays;
    _diet = SharedPrefsHelper.diet;
    _medicalConditions = SharedPrefsHelper.medicalConditions;
    notifyListeners();
  }

  // Setters with persistence
  void setGender(String value) {
    _gender = value;
    SharedPrefsHelper.setGender(value);
    notifyListeners();
  }

  void setAge(int value) {
    _age = value;
    SharedPrefsHelper.setAge(value);
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    SharedPrefsHelper.setWeight(value);
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    SharedPrefsHelper.setHeight(value);
    notifyListeners();
  }

  void setGoal(String value) {
    _goal = value;
    SharedPrefsHelper.setGoal(value);
    notifyListeners();
  }

  void setActivityLevel(String value) {
    _activityLevel = value;
    SharedPrefsHelper.setActivityLevel(value);
    notifyListeners();
  }

  void setFocusArea(String value) {
    _focusArea = value;
    SharedPrefsHelper.setFocusArea(value);
    notifyListeners();
  }

  void setWorkoutDays(int value) {
    _workoutDays = value;
    SharedPrefsHelper.setWorkoutDays(value);
    notifyListeners();
  }

  void setDiet(String value) {
    _diet = value;
    SharedPrefsHelper.setDiet(value);
    notifyListeners();
  }

  void setMedicalConditions(String value) {
    _medicalConditions = value;
    SharedPrefsHelper.setMedicalConditions(value);
    notifyListeners();
  }

  // Navigation Logic
  void onPageChanged(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void completeOnboarding() {
    SharedPrefsHelper.setOnboardingComplete(true);
    // You can handle navigation to Home here or in the UI layer
  }
}
