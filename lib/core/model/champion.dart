class Champion {
  /// Champion id
  String id;

  /// Champion name
  String name;

  /// Champion title
  String title;

  /// The lore of the champion
  String lore;

  Champion({
    required this.id,
    required this.name,
    required this.title,
    required this.lore,
  });

  /// Build the champion from it's corresponding JSON file. [id] is required in order to access JSON data.
  factory Champion.fromJson({required id, required Map<String, dynamic> json}) {
    String name = json["data"][id]["name"];
    String title = json["data"][id]["title"];
    String lore = json["data"][id]["lore"];

    return Champion(id: id, name: name, title: title, lore: lore);
  }
}
