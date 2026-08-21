import 'package:flutter/material.dart';

class LoadingOverlay {
  static bool _isShowing = false;
  static BuildContext? _dialogContext;

  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext ctx) {
        _dialogContext = ctx;
        return const PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text(
                    'Loading Ad...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isShowing = false;
      _dialogContext = null;
    });
  }

  static void hide() {
    if (_isShowing && _dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _isShowing = false;
      _dialogContext = null;
    }
  }
}
