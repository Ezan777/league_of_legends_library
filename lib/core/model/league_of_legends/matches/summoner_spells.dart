enum SummonerSpells {
  barrier("SummonerBarrier", "Barrier", 21),
  cleanse("SummonerBoost", "Cleanse", 1),
  ignite("SummonerDot", "Ignite", 14),
  exhaust("SummonerExhaust", "Exhaust", 3),
  ghost("SummonerHaste", "Ghost", 6),
  heal("SummonerHeal", "Heal", 7),
  clarity("SummonerMana", "Clarity", 13),
  smite("SummonerSmite", "Smite", 11),
  teleport("SummonerTeleport", "Teleport", 12),
  flash("SummonerFlash", "Flash", 4);

  const SummonerSpells(this.spellId, this.name, this.key);

  final String name;
  final int key;
  final String spellId;

  factory SummonerSpells.fromKey(int key) =>
      SummonerSpells.values.firstWhere((test) => test.key == key);
}
