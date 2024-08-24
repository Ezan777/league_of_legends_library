import 'package:league_of_legends_library/core/model/passive.dart';

class Spell extends Passive {
  final String id;
  final String cooldowns;

  Spell(
      {required this.id,
      required super.name,
      required this.cooldowns,
      required super.description,
      super.tileUrl});

  factory Spell.fromJson({required Map<String, dynamic> jsonData}) {
    String id = jsonData["id"];
    String name = jsonData["name"];
    String cooldowns = jsonData["cooldownBurn"];
    String description = jsonData["description"];

    return Spell(
        id: id, name: name, cooldowns: cooldowns, description: description);
  }
}
