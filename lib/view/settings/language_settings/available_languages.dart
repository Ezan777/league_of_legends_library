enum AvailableLanguages {
  czech("cs_CZ"),
  german("de_DE"),
  greece("el_GR"),
  australianEnglish("en_AU"),
  ukEnglish("en_GB"),
  philippineEnglish("en_PH"),
  singaporeanEnglish("en_SG"),
  americanEnglish("en_US"),
  spanish("es_ES"),
  mexicanSpanish("es_MX"),
  argentinianSpanish("es_AR"),
  french("fr_FR"),
  italian("it_IT"),
  hungarian("hu_HU"),
  japanese("ja_JP"),
  korean("ko_KR"),
  polish("pl_PL"),
  romanian("ro_RO"),
  portuguese("pt_BR"),
  russian("ru_RU"),
  turkish("tr_TR"),
  vietnamese("vi_VN"),
  thai("th_TH"),
  chinese("zh_CN"),
  taiwaneseChinese("zh_TW");

  final String localeCode;
  const AvailableLanguages(this.localeCode);

  /// Given a [languageCode] will return the corresponding language.
  ///
  /// If the given [languageCode] is not valid or not available it will return american english (en_US).
  factory AvailableLanguages.fromLanguageCode(String languageCode) {
    final List<AvailableLanguages> compatibles = AvailableLanguages.values
        .where((language) => language.localeCode.contains(languageCode))
        .toList();

    if (compatibles.isEmpty || compatibles.length > 1) {
      return AvailableLanguages.americanEnglish;
    } else {
      return compatibles.first;
    }
  }

  String getLanguageCode() => localeCode.split("_")[0];
  String getCountryCode() => localeCode.split("_")[1];

  String displayName() => switch (this) {
        AvailableLanguages.czech => "Čeština",
        AvailableLanguages.german => "Deutsch",
        AvailableLanguages.greece => "Ελληνικά",
        AvailableLanguages.australianEnglish => "English (Australian)",
        AvailableLanguages.ukEnglish => "English (UK)",
        AvailableLanguages.philippineEnglish => "Filipino",
        AvailableLanguages.singaporeanEnglish => "English (Singapore)",
        AvailableLanguages.americanEnglish => "English (American)",
        AvailableLanguages.spanish => "Español (España)",
        AvailableLanguages.mexicanSpanish => "Español (México)",
        AvailableLanguages.argentinianSpanish => "Español (Argentina)",
        AvailableLanguages.french => "Français",
        AvailableLanguages.italian => "Italiano",
        AvailableLanguages.hungarian => "Magyar",
        AvailableLanguages.japanese => "日本語 (Nihongo)",
        AvailableLanguages.korean => "한국어 (Hangugeo)",
        AvailableLanguages.polish => "Polski",
        AvailableLanguages.romanian => "Română",
        AvailableLanguages.portuguese => "Português (Brasil)",
        AvailableLanguages.russian => "Русский",
        AvailableLanguages.turkish => "Türkçe",
        AvailableLanguages.vietnamese => "Tiếng Việt",
        AvailableLanguages.thai => "ภาษาไทย (Phasa Thai)",
        AvailableLanguages.chinese => "中文 (Zhōngwén)",
        AvailableLanguages.taiwaneseChinese => "繁體中文 (Fántǐ Zhōngwén)",
      };

  static bool isLanguageCodeAvailable(String languageCode) =>
      AvailableLanguages.values
          .map((language) => language.localeCode)
          .toList()
          .contains(languageCode);
}
