import 'package:league_of_legends_library/core/model/passive.dart';

class Spell extends Passive {
  final String id;
  final String cooldowns;

  Spell(
      {required this.id,
      required String name,
      required this.cooldowns,
      required String description,
      String? tileUrl})
      : super(name: name, description: description, tileUrl: tileUrl);

  factory Spell.fromJson({required Map<String, dynamic> jsonData}) {
    String id = jsonData["id"];
    String name = jsonData["name"];
    String cooldowns = jsonData["cooldownBurn"];
    String description = jsonData["description"];

    return Spell(
        id: id, name: name, cooldowns: cooldowns, description: description);
  }
}
