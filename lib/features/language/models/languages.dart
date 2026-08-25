/// ---- LANGUAGE MODEL ----
class LanguageModel {
  final String code;
  final String country;
  final String name;

  const LanguageModel({
    required this.code,
    required this.country,
    required this.name,
  });
}

/// List of supported languages
List<LanguageModel> languages = [
  LanguageModel(code: 'es', country: 'ES', name: 'Spanish'),
  LanguageModel(code: 'zh', country: 'CN', name: 'Chinese'),
  LanguageModel(code: 'fr', country: 'FR', name: 'French'),
  LanguageModel(code: 'ar', country: 'SA', name: 'Arabic'),
  LanguageModel(code: 'en', country: 'US', name: 'English'),
  LanguageModel(code: 'pt', country: 'PT', name: 'Portuguese'),
  LanguageModel(code: 'de', country: 'DE', name: 'German'),
  LanguageModel(code: 'ru', country: 'RU', name: 'Russian'),
]..sort((a, b) => a.name.compareTo(b.name));
