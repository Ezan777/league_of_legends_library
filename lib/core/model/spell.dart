class Spell {
  final String id;
  final String name;
  final List<dynamic> cooldowns;
  final String description;

  Spell(
      {required this.id,
      required this.name,
      required this.cooldowns,
      required String description})
      : description = description.replaceAll(RegExp(r"<[^>]+>"), "");

  factory Spell.fromJson({required Map<String, dynamic> jsonData}) {
    String id = jsonData["id"];
    String name = jsonData["name"];
    List<dynamic> cooldowns = jsonData["cooldown"];
    String description = jsonData["description"];

    return Spell(
        id: id, name: name, cooldowns: cooldowns, description: description);
  }
}
