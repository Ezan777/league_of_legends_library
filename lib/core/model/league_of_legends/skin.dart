class Skin {
  final String name;
  final int skinCode;

  const Skin({required this.name, required this.skinCode});

  factory Skin.fromJson({required Map<String, dynamic> jsonData}) {
    final String name = jsonData["name"];
    final int skinCode = jsonData["num"];

    return Skin(name: name, skinCode: skinCode);
  }
}
