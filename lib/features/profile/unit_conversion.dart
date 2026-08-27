/// Metric is the stored unit — the user info flow collects cm and kg and
/// `UserProfiles` keeps them that way. Imperial exists only for display and
/// editing on the profile screen, and converts back before anything is written,
/// so toggling units never rewrites what the user chose.
library;

int kgToLbs(int kg) => (kg * 2.20462).round();

int lbsToKg(int lbs) => (lbs / 2.20462).round();

int cmToInches(int cm) => (cm / 2.54).round();

int inchesToCm(int inches) => (inches * 2.54).round();

/// 165cm -> 5'5"
String feetInches(int cm) {
  final inches = cmToInches(cm);
  return "${inches ~/ 12}'${inches % 12}\"";
}
