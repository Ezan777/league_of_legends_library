enum SharedPreferencesKeys {
  favorites(key: "FAVORITES"),
  recentlyViewed(key: "RECENTLY_VIEWED"),
  championsSkins(key: "CHAMPIONS_SKINS"),
  themeMode(key: "THEME_MODE");

  final String key;

  const SharedPreferencesKeys({required this.key});
}
