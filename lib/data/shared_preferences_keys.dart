enum SharedPreferencesKeys {
  favorites(key: "FAVORITES"),
  recentlyViewed(key: "RECENTLY_VIEWED"),
  championsSkins(key: "CHAMPIONS_SKINS"),
  themeMode(key: "THEME_MODE"),
  language(key: "LANGUAGE");

  final String key;

  const SharedPreferencesKeys({required this.key});
}
