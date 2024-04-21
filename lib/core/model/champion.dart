import 'package:league_of_legends_library/core/model/passive.dart';
import 'package:league_of_legends_library/core/model/skin.dart';
import 'package:league_of_legends_library/core/model/spell.dart';

class Champion {
  /// Champion id
  final String id;

  /// Champion name
  final String name;

  /// Champion title
  final String title;

  /// The lore of the champion
  final String lore;

  /// The list of tips for players using Annie
  final List<dynamic> allyTips;

  /// The list of tips for players that are against Annie
  final List<dynamic> enemyTips;

  /// The list of spells
  final List<Spell> spells;

  /// The passive ability
  final Passive passive;

  /// List of available skins for this champion
  final List<Skin> skins;

  const Champion({
    required this.id,
    required this.name,
    required this.title,
    required this.lore,
    required this.allyTips,
    required this.enemyTips,
    required this.spells,
    required this.passive,
    required this.skins,
  });

  /// Build the champion from it's corresponding JSON file. [id] is required in order to access JSON data.
  factory Champion.fromJson({
    required id,
    required Map<String, dynamic> json,
  }) {
    String name = json["data"][id]["name"];
    String title = json["data"][id]["title"];
    String lore = json["data"][id]["lore"];
    List<dynamic> allyTips = json["data"][id]["allytips"];
    List<dynamic> enemyTips = json["data"][id]["enemytips"];
    List<Spell> spells = (json["data"][id]["spells"] as List<dynamic>)
        .map((spellData) => Spell.fromJson(jsonData: spellData))
        .toList();
    Passive passive = Passive.fromJson(jsonData: json["data"][id]["passive"]);
    List<Skin> skins = (json["data"][id]["skins"] as List<dynamic>)
        .map((skinData) => Skin.fromJson(jsonData: skinData))
        .toList();

    // Akshan has bugged tips, the allyTips are only the description of the champ
    if (id == "Akshan") {
      allyTips = List.empty();
      enemyTips = List.empty();
    }

    return Champion(
      id: id,
      name: name,
      title: title,
      lore: lore,
      allyTips: allyTips,
      enemyTips: enemyTips,
      spells: spells,
      passive: passive,
      skins: skins,
    );
  }

  @override
  String toString() => id;

  @override
  bool operator ==(Object other) =>
      other is Champion && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
