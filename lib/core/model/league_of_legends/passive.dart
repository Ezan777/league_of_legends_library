import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class Passive {
  final String name;
  final String description;
  final String? tileUrl;

  Passive({required this.name, required String description, this.tileUrl})
      : description = description.replaceAll(RegExp(r"<[^>]+>"), "");

  factory Passive.fromJson({required Map<String, dynamic> jsonData}) {
    String name = jsonData["name"];
    String description = jsonData["description"];
    String tileUrl =
        "${ChampionRepository.baseUrl}/${ChampionRepository.version}/img/passive/${jsonData["image"]["full"]}";

    return Passive(name: name, description: description, tileUrl: tileUrl);
  }
}
