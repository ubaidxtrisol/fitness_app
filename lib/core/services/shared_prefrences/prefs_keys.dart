part of 'storage_services.dart';

class PrefsKeys {
  static const String isFirstTime = 'isFirstTime';
  static const String languageCode = 'languageCode';
  static const String rcPremiumScreenEnabled = 'rc_premium_screen';
  static const String interstitialCount = 'interstitial_count';
  static const String firstInterstitialShown = 'first_interstitial_shown';
  static const String appOpenCount = 'app_open_count';
  static const String urls = 'urls';

  static String cachedGuestUid = 'cached_guest_uid';
  static const String cachedUserData = 'cached_user_data';
  static const String outboxQueue = 'outbox_queue';

  static String acceptPrivacyPolicy = 'accept_privacy_policy';

  /// Last-known-good Pilates discover catalogue (raw JSON array) and the
  /// `ETag` it was served with — see [DiscoverRepository].
  static const String pilatesCategoriesCache = 'pilates_categories_cache';
  static const String pilatesCategoriesEtag = 'pilates_categories_etag';

  /// Same pattern as [pilatesCategoriesCache]/[pilatesCategoriesEtag] for
  /// Programs/Challenges/Body Focus. Programs/Body Focus cache the same
  /// [CategoryModel] list Discover does (no adapter); Challenges caches its
  /// own adapted `ChallengeProgramModel` list.
  static const String programsCache = 'programs_cache';
  static const String programsEtag = 'programs_etag';
  static const String challengesCache = 'challenges_cache';
  static const String challengesEtag = 'challenges_etag';
  static const String bodyFocusCache = 'body_focus_cache';
  static const String bodyFocusEtag = 'body_focus_etag';
}
