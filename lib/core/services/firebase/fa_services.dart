import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FAServices {
  // Private constructor
  FAServices._();

  // Singleton instance
  static final FAServices instance = FAServices._();

  // Firebase Analytics instance
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Initializer
  static Future<void> init() async {
    await instance._analytics.setAnalyticsCollectionEnabled(
      kDebugMode ? false : true,
    );

    debugPrint('[FAServices] Initialized');
  }

  void setUserProperties(Map<String, String> map) {
    map.forEach((key, value) {
      debugPrint('[FAServices] Setting user property: $key = $value');
      try {
        instance._analytics.setUserProperty(name: key, value: value);
      } catch (e) {
        debugPrint('[FAServices] Error setting user property: $e');
      }
    });
  }

  // Helper for logging screens
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
    debugPrint('[FAServices] Screen Viewed: $screenName');
  }

  // Helper for logging custom events
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
    debugPrint('[FAServices] Event Logged: $name with parameters: $parameters');
  }

  // --- Specific Event Methods ---

  // Onboarding
  Future<void> logOnboardingStarted() async =>
      await logEvent('onboarding_started');
  Future<void> logOnboardingCompleted() async =>
      await logEvent('onboarding_completed');

  // Business Profile
  Future<void> logBusinessCreated() async => await logEvent('business_created');
  Future<void> logBusinessUpdated() async => await logEvent('business_updated');
  Future<void> logBusinessDeleted() async => await logEvent('business_deleted');

  // Clients
  Future<void> logClientCreated() async => await logEvent('client_created');
  Future<void> logClientUpdated() async => await logEvent('client_updated');
  Future<void> logClientDeleted() async => await logEvent('client_deleted');
  Future<void> logClientFromContactList() async =>
      await logEvent('client_from_contact_list');

  // Items
  Future<void> logItemCreated() async => await logEvent('item_created');
  Future<void> logItemUpdated() async => await logEvent('item_updated');
  Future<void> logItemDeleted() async => await logEvent('item_deleted');

  // Invoices
  Future<void> logInvoiceCreated({double? amount, String? currency}) async {
    await logEvent(
      'invoice_created',
      parameters: {'value': ?amount, 'currency': ?currency},
    );
  }

  Future<void> logInvoiceUpdated() async => await logEvent('invoice_updated');
  Future<void> logInvoiceDeleted() async => await logEvent('invoice_deleted');
  Future<void> logInvoiceShared() async => await logEvent('invoice_shared');
  Future<void> logInvoiceDownloaded() async =>
      await logEvent('invoice_downloaded');
  Future<void> logInvoicePreviewed() async =>
      await logEvent('invoice_previewed');

  // Estimates
  Future<void> logEstimateCreated() async => await logEvent('estimate_created');
  Future<void> logEstimateUpdated() async => await logEvent('estimate_updated');
  Future<void> logEstimateConverted() async =>
      await logEvent('estimate_converted_to_invoice');

  // Premium / RevenueCat
  Future<void> logPremiumScreenViewed() async =>
      await logEvent('premium_screen_viewed');
  Future<void> logPurchaseStarted(String productId) async {
    await logEvent('purchase_started', parameters: {'product_id': productId});
  }

  Future<void> logPurchaseSuccess(String productId) async {
    await logEvent('purchase_success', parameters: {'product_id': productId});
  }

  Future<void> logPurchaseFailed(String productId, String error) async {
    await logEvent(
      'purchase_failed',
      parameters: {'product_id': productId, 'error': error},
    );
  }

  // AI Features
  Future<void> logAIChatStarted() async => await logEvent('ai_chat_started');
  Future<void> logAIInvoiceGenerated() async =>
      await logEvent('ai_invoice_generated');
  Future<void> logAIEstimateGenerated() async =>
      await logEvent('ai_estimate_generated');
  Future<void> logAIError(String error) async {
    await logEvent('ai_error', parameters: {'error': error});
  }

  // Settings & Navigation
  Future<void> logSettingsViewed() async => await logEvent('settings_viewed');
  Future<void> logSupportContacted() async =>
      await logEvent('support_contacted');
  Future<void> logFeedbackSubmitted() async =>
      await logEvent('feedback_submitted');
  Future<void> logAppShared() async => await logEvent('app_shared');
  Future<void> logAppRated() async => await logEvent('app_rated');
}
