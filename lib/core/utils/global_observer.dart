// import 'dart:async';
// import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:fitness_app/core/constants/routes/route_tracker.dart';
// import 'package:fitness_app/core/utils/context.dart';
// import 'package:fitness_app/features/splash/splash_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_fgbg/flutter_fgbg.dart';

// class GlobalAppLifecycleObserver {
//   bool _isBackgrounded = false;

//   // --- Connectivity Subscription ---
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

//   GlobalAppLifecycleObserver() {
//     _startNetworkListener();
//   }

//   // --- Listen for network changes while app is open ---
//   void _startNetworkListener() {
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
//       List<ConnectivityResult> results,
//     ) {
//       // Check if we have any valid connection type
//       final hasConnection = results.any((c) => c != ConnectivityResult.none);

//       if (hasConnection) {
//         if (!AppInitializer.isInitializedOnline) {
//           log(
//             "[Global] Internet connected actively. Retrying initialization...",
//           );
//           AppInitializer.retryOfflineInitialization();
//         }

//         final context = Ctx.context;
//         if (context != null) {
//           final userBloc = context.read<UserBloc>();
//           final userState = userBloc.state;
//           if (userState is UserNoInternet ||
//               userState is UserUnauthenticated ||
//               (userState.currentUser == null &&
//                   FirebaseAuth.instance.currentUser == null)) {
//             log(
//               "[Global] Internet connected & no authenticated user found. Auto-registering guest...",
//             );
//             userBloc.add(GuestSignInRequested());
//           }
//         }
//       }
//     });
//   }

//   // Clean up if this is ever disposed
//   void dispose() {
//     _connectivitySubscription?.cancel();
//   }
//   // ---------------------------------------------------------

//   void onLifecycleEvent(FGBGType event) {
//     try {
//       final route = RouteTracker.currentRoute;
//       final isSplash =
//           route == 'SplashScreen' ||
//           route == SplashScreen().runtimeType.toString() ||
//           route == null;
//       final isWelcomeBack =
//           route == 'WelcomeBackScreen' ||
//           route == WelcomeBackScreen().runtimeType.toString();
//       final isOnboarding =
//           route == 'OnboardingScreen' ||
//           route == OnboardingScreen().runtimeType.toString();
//       final isLanguage =
//           (route == 'LanguageScreen' ||
//               route == LanguageScreen().runtimeType.toString()) &&
//           storage.getString(PrefsKeys.languageCode).isEmpty;
//       final isPremium =
//           route == 'PremiumScreen' ||
//           route == PremiumScreen().runtimeType.toString();

//       final isAuth =
//           route == 'AuthScreen' ||
//           route == 'LoginScreen' ||
//           route == 'SignupScreen' ||
//           route == 'ForgotPasswordScreen' ||
//           route == 'ResetPasswordScreen' ||
//           route == 'VerifyOtpScreen';

//       final bool isUserPremium =
//           AppInitializer.adService.isPremium ||
//           IAPService.instance.isSubscribed.value ||
//           storage.getBool('isPremium') == true ||
//           storage.getBool('is_premium') == true;

//       if (event == FGBGType.background) {
//         if (isUserPremium ||
//             AppInitializer.adService.isShowingInterstitial ||
//             isSplash ||
//             isOnboarding ||
//             isPremium ||
//             isLanguage ||
//             isAuth ||
//             isWelcomeBack) {
//           log("[Global] Ad has been skipped $route");
//           _isBackgrounded = false;
//           return;
//         }
//         _isBackgrounded = true;
//         log("[Global] Ad has been paused ${RouteTracker.currentRoute}");

//         if (AppInitializer.adsConfig.appOpen.loadType == LoadType.preLoad) {
//           AppInitializer.adService.loadAppOpenAd();
//         }
//       } else if (event == FGBGType.foreground) {
//         // --- Retry initialization if app is foregrounded and wasn't initialized online ---
//         if (!AppInitializer.isInitializedOnline) {
//           log(
//             "[Global] App was offline during launch. Retrying initialization on resume...",
//           );
//           AppInitializer.retryOfflineInitialization();
//         }

//         final context = Ctx.context;
//         if (context != null) {
//           final userBloc = context.read<UserBloc>();
//           final userState = userBloc.state;
//           if (userState is UserNoInternet ||
//               userState is UserUnauthenticated ||
//               (userState.currentUser == null &&
//                   FirebaseAuth.instance.currentUser == null)) {
//             log(
//               "[Global] Resumed with no authenticated user. Triggering guest registration...",
//             );
//             userBloc.add(GuestSignInRequested());
//           }
//         }

//         final route = RouteTracker.currentRoute;
//         final isSplash =
//             route == 'SplashScreen' ||
//             route == SplashScreen().runtimeType.toString() ||
//             route == null;
//         final isWelcomeBack =
//             route == 'WelcomeBackScreen' ||
//             route == WelcomeBackScreen().runtimeType.toString();
//         final isOnboarding =
//             route == 'OnboardingScreen' ||
//             route == OnboardingScreen().runtimeType.toString();
//         final isLanguage =
//             (route == 'LanguageScreen' ||
//                 route == LanguageScreen().runtimeType.toString()) &&
//             storage.getString(PrefsKeys.languageCode).isEmpty;
//         final isPremium =
//             route == 'PremiumScreen' ||
//             route == PremiumScreen().runtimeType.toString();

//         final isAuth =
//             route == 'AuthScreen' ||
//             route == 'LoginView' ||
//             route == 'SignupView' ||
//             route == 'ForgotPasswordScreen' ||
//             route == 'ResetPasswordScreen' ||
//             route == 'VerifyOtpScreen';

//         if (isUserPremium ||
//             AppInitializer.adService.isShowingInterstitial ||
//             isSplash ||
//             isWelcomeBack ||
//             isOnboarding ||
//             isLanguage ||
//             isPremium ||
//             isAuth) {
//           log("[Global] Ad has been skipped $route");
//           _isBackgrounded = false;
//           return;
//         }
//         print('[Global] Resumed from background $_isBackgrounded');
//         if (_isBackgrounded) {
//           if (AppInitializer.adsConfig.appOpen.enabled) {
//             _showOpenAppAd();
//           } else {
//             Navigator.of(Ctx.context!).push(
//               CupertinoPageRoute(
//                 builder: (context) => WelcomeBackScreen(),
//                 fullscreenDialog: true,
//               ),
//             );
//           }
//           _isBackgrounded = false;
//         }
//       }
//     } catch (e, s) {
//       log('Global lifecycle observer ignored error: $e', stackTrace: s);
//     }
//   }

//   void _showOpenAppAd() {
//     if (AppInitializer.adService.isShowingInterstitial ||
//         AppInitializer.adService.isShowingAppOpen) {
//       return;
//     }

//     final route = RouteTracker.currentRoute;
//     if (route == null ||
//         route == 'SplashScreen' ||
//         route == SplashScreen().runtimeType.toString()) {
//       log("Skip AppOpen: Splash");
//       return;
//     }

//     if (route == 'OnboardingScreen' ||
//         route == OnboardingScreen().runtimeType.toString()) {
//       log("Skip AppOpen: Onboarding");
//       return;
//     }

//     if ((route == 'LanguageScreen' ||
//             route == LanguageScreen().runtimeType.toString()) &&
//         storage.getString(PrefsKeys.languageCode).isEmpty) {
//       log("Skip AppOpen: Language");
//       return;
//     }
//     final isAuth =
//         route == 'AuthScreen' ||
//         route == 'LoginView' ||
//         route == 'SignupView' ||
//         route == 'ForgotPasswordScreen' ||
//         route == 'ResetPasswordScreen' ||
//         route == 'VerifyOtpScreen';
//     if (isAuth) {
//       log("Skip AppOpen: Auth");
//       return;
//     }
//     AppInitializer.adService.showAppOpenAd();
//   }
// }
