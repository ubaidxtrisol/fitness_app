/// The Phases program's 4 fixed stages — Figma 11:732 ("Phase n" text
/// style) / 11:733 ("Phase Name" static text). Static by design: the names
/// and day ranges are fixed UI structure, not data from the API. Actual
/// day content (`WorkoutRepository.loadPrograms()`) is bucketed into these
/// ranges by its flat position — see `ProgramsProgress`.
class PhaseDefinition {
  final String title;
  final String subtitle;

  /// 1-based, inclusive.
  final int startDay;
  final int endDay;

  const PhaseDefinition({
    required this.title,
    required this.subtitle,
    required this.startDay,
    required this.endDay,
  });

  int get dayCount => endDay - startDay + 1;
}

/// The Phases program's own brand name — Figma 10:509's hero banner
/// ("Pilates" / "Premier"). Static, like the phase names: one fixed program,
/// not derived from whatever category title the JSON/API happens to ship.
const String kPhasesProgramTitle = 'Pilates Premier';

/// The 30-day program's stages, in order.
const List<PhaseDefinition> kPhaseDefinitions = [
  PhaseDefinition(title: 'Phase 1', subtitle: 'Gentle Beginning', startDay: 1, endDay: 3),
  PhaseDefinition(title: 'Phase 2', subtitle: 'Easy Sequences', startDay: 4, endDay: 10),
  PhaseDefinition(title: 'Phase 3', subtitle: 'Practice Basics', startDay: 11, endDay: 20),
  PhaseDefinition(title: 'Phase 4', subtitle: 'Build Endurance', startDay: 21, endDay: 30),
];

/// The fixed length of the program the "Overall Days Done" stat (Figma
/// 11:763) counts against — 30, regardless of how many days are actually
/// authored/loaded yet.
const int kPhasesProgramTotalDays = 30;
