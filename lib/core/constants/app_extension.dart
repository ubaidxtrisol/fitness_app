import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

extension StringExtensions on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidUrl {
    final urlRegex = RegExp(
      r"^(https?:\/\/)?([A-Za-z0-9-]+\.)+[A-Za-z]{2,}(\/[A-Za-z0-9._~:/?#[\]@!$&\'()*+,;=-]*)?$",
    );
    return urlRegex.hasMatch(this);
  }

  String truncate({int maxLength = 20, String trailing = '...'}) {
    if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)}$trailing';
    }
  }

  String removeTrailingDigit() {
    // Check if the last character is a digit
    if (isNotEmpty && int.tryParse(substring(length - 1)) != null) {
      // Remove the last character
      return substring(0, length - 1).toTitleCase();
    } else {
      return toTitleCase();
    }
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<double> get imageWidth async {
    Completer<double> completer = Completer();
    FileImage(File(this))
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info.image.width.toDouble());
          }),
        );
    return completer.future;
  }

  Future<double> get imageHeight async {
    Completer<double> completer = Completer();
    FileImage(File(this))
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info.image.height.toDouble());
          }),
        );
    return completer.future;
  }
}

extension Boxes on num {
  SizedBox get heightBox => SizedBox(height: toDouble());
  SizedBox get widthBox => SizedBox(width: toDouble());
}

extension TextStyleExtension on BuildContext {
  /// Display styles
  TextStyle get displayLarge =>
      Theme.of(this).textTheme.displayLarge ?? const TextStyle();
  TextStyle get displayMedium =>
      Theme.of(this).textTheme.displayMedium ?? const TextStyle();
  TextStyle get displaySmall =>
      Theme.of(this).textTheme.displaySmall ?? const TextStyle();

  /// Headline styles
  TextStyle get headlineLarge =>
      Theme.of(this).textTheme.headlineLarge ?? const TextStyle();
  TextStyle get headlineMedium =>
      Theme.of(this).textTheme.headlineMedium ?? const TextStyle();
  TextStyle get headlineSmall =>
      Theme.of(this).textTheme.headlineSmall ?? const TextStyle();

  /// Title styles
  TextStyle get titleLarge =>
      Theme.of(this).textTheme.titleLarge ?? const TextStyle();
  TextStyle get titleMedium =>
      Theme.of(this).textTheme.titleMedium ?? const TextStyle();
  TextStyle get titleSmall =>
      Theme.of(this).textTheme.titleSmall ?? const TextStyle();

  /// Body styles
  TextStyle get bodyLarge =>
      Theme.of(this).textTheme.bodyLarge ?? const TextStyle();
  TextStyle get bodyMedium =>
      Theme.of(this).textTheme.bodyMedium ?? const TextStyle();
  TextStyle get bodySmall =>
      Theme.of(this).textTheme.bodySmall ?? const TextStyle();

  /// Label styles
  TextStyle get labelLarge =>
      Theme.of(this).textTheme.labelLarge ?? const TextStyle();
  TextStyle get labelMedium =>
      Theme.of(this).textTheme.labelMedium ?? const TextStyle();
  TextStyle get labelSmall =>
      Theme.of(this).textTheme.labelSmall ?? const TextStyle();

  /// Access to theme and color scheme
  ThemeData get theme => Theme.of(this);
  ColorScheme get color => Theme.of(this).colorScheme;

  //heght and width of screen
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

/// An elegant extension pack to eliminate WidgetStateProperty boilerplate
/// and simplify ButtonStyle configurations.
extension ButtonStyleExtension on ButtonStyle {
  /// Directly sets the background color without dealing with WidgetStateProperty.
  ButtonStyle withBackgroundColor(Color color) {
    return copyWith(backgroundColor: WidgetStateProperty.all<Color>(color));
  }

  /// Directly sets the foreground (text/icon) color.
  ButtonStyle withForegroundColor(Color color) {
    return copyWith(foregroundColor: WidgetStateProperty.all<Color>(color));
  }

  /// Sets a strict, explicit height for the button by applying it
  ButtonStyle withHeight(double height) {
    // We use double.infinity for max width so it can still expand horizontally if needed
    return copyWith(
      minimumSize: WidgetStateProperty.all<Size>(Size(0, height)),
      maximumSize: WidgetStateProperty.all<Size>(Size(double.infinity, height)),
      fixedSize: WidgetStateProperty.all<Size>(Size.fromHeight(height)),
    );
  }

  /// STRICTLY forces both the exact width and height of the button.
  /// This will completely override any default padding or text constraints.
  ButtonStyle withFixedSize(double width, double height) {
    final exactSize = Size(width, height);
    return copyWith(
      minimumSize: WidgetStateProperty.all<Size>(exactSize),
      maximumSize: WidgetStateProperty.all<Size>(exactSize),
      fixedSize: WidgetStateProperty.all<Size>(exactSize),
    );
  }

  /// Changes the border radius of the button while preserving its shape structure.
  ButtonStyle withRadius(double radius) {
    return copyWith(
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }

  /// Overrides the internal text style (font size, weight, etc.)
  ButtonStyle withTextStyle(TextStyle style) {
    return copyWith(textStyle: WidgetStateProperty.all<TextStyle>(style));
  }

  /// Removes standard elevations/shadows seamlessly.
  ButtonStyle flat() {
    return copyWith(elevation: WidgetStateProperty.all<double>(0));
  }
}

extension FileTypeIconExtension on String {
  String get fileTypeIcon {
    final ext = p.extension(this).toLowerCase();

    switch (ext) {
      // PDF
      case '.pdf':
        return 'assets/icons/color/pdf.svg';

      // Word Documents
      case '.doc':
      case '.docx':
        return 'assets/icons/color/docx.svg';

      // Excel Files
      case '.xls':
      case '.xlsx':
      case '.csv':
        return 'assets/icons/color/xlsx.svg';

      // PowerPoint Files
      case '.ppt':
      case '.pptx':
        return 'assets/icons/color/pptx.svg';

      // Audio Files
      case '.mp3':
      case '.wav':
      case '.aac':
      case '.m4a':
      case '.ogg':
      case '.flac':
        return 'assets/icons/color/audio_2.svg';

      // Archives
      case '.zip':
      case '.rar':
      case '.7z':
      case '.tar':
      case '.gz':
        return 'assets/icons/color/archive.svg';

      // APK
      case '.apk':
        return 'assets/icons/color/apk.svg';

      case '.txt':
        return 'assets/icons/color/txt.svg';

      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
      case '.bmp':
      case '.svg':
        return 'assets/icons/color/photo.svg';

      // Videos
      case '.mp4':
      case '.mkv':
      case '.avi':
      case '.mov':
      case '.wmv':
      case '.webm':
        return 'assets/icons/color/video_2.svg';

      default:
        return 'assets/icons/color/file_g.svg';
    }
  }
}
