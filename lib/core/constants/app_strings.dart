class AppStrings {
  /// Helper method to fetch translation safely
  // static String _t(String key, {Map<String, Object>? args}) {
  //   final ctx = Ctx.context;
  //   if (ctx != null) {
  //     try {
  //       if (args != null) {
  //         final namedArgs = args.map((k, v) => MapEntry(k, v.toString()));
  //         return key.tr(namedArgs: namedArgs, context: ctx);
  //       }
  //       return key.tr(context: ctx);
  //     } catch (_) {
  //       return key;
  //     }
  //   }
  //   return key;
  // }

  // ==================== App ====================
  static String fitness = 'Fitness';
  static String plus = 'Plus';

  static String moveBetterFeelStronger = 'Move Better, Feel Stronger.';

  // Onboarding Step 1: Motivation
  static String whatMotivatesYouTheMost = 'What motivates you the most?';
  static String chooseTheReasonThatInspireYou =
      'Choose The reason that inspire you';

  static String next = 'Next';

  static String getInShape = 'Get In Shape';
  static String getInShapeSubtitle =
      'Feel Better, boost energy and live a healthier life';

  static String lookBetter = 'Look Better';
  static String lookBetterSubtitle = 'Burn fat, loose and achieve ideal body';

  static String reduceStress = 'Reduce Stress';
  static String reduceStressSubtitle =
      'Reduce the stress clear my mind and feel relaxed';

  static String getEnoughSleep = 'Get Enough Sleep';
  static String getEnoughSleepSubtitle = 'Make your sleep better and relaxed';

  static String findSelfLove = 'Find Self Love';
  static String findSelfLoveSubtitle = 'Burn fat, loose and achieve ideal body';

  // Onboarding Step 2: Focus Area
  static String pleaseChooseYourFocusArea = 'Please choose your focus area';
  static String getAPlanThatBestSuit = 'Get a Plan that best suit your focus area';

  static String toneArm = 'Tone arm';
  static String flatBelly = 'Flat belly';
  static String roundButt = 'Round Butt';
  static String slimLeg = 'Slim Leg';
  static String fullBody = 'Full Body';

  // Onboarding Step 3: Main Goal
  static String whatIsYourMainGoal = 'What is your main goal?';

  static String looseWeight = 'Loose weight';
  static String toneMuscle = 'Tone Muscle';
  static String improveHealth = 'Improve health';
  static String improveFlexibility = 'Improve Flexibility';
  static String refinePosture = 'Refine posture';
}
