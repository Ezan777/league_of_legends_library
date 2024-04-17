enum SharedPreferencesKeys {
  favorites(key: "FAVORITES"),
  recentlyViewed(key: "RECENTLY_VIEWED");

  final String key;

  const SharedPreferencesKeys({required this.key});
}
