import 'dart:convert';
import '../models/participant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/encounter.dart';

class EncounterStorage {
  static const String _key = 'saved_encounters';

  static Future<void> saveEncounter(Encounter encounter) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEncounters = prefs.getStringList(_key) ?? [];

    savedEncounters.add(jsonEncode(encounter.toJson()));

    await prefs.setStringList(_key, savedEncounters);
  }

  static Future<List<Encounter>> loadEncounters() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEncounters = prefs.getStringList(_key) ?? [];

    return savedEncounters
        .map((item) => Encounter.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> deleteEncounterById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEncounters = prefs.getStringList(_key) ?? [];

    final filteredEncounters = savedEncounters.where((item) {
      final json = jsonDecode(item);
      return json['id'] != id;
    }).toList();

    await prefs.setStringList(_key, filteredEncounters);
  }

  static Future<void> updateEncounter(Encounter updatedEncounter) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEncounters = prefs.getStringList(_key) ?? [];

    final updatedEncounters = savedEncounters.map((item) {
      final json = jsonDecode(item);

      if (json['id'] == updatedEncounter.id) {
        return jsonEncode(updatedEncounter.toJson());
      }

      return item;
    }).toList();

    await prefs.setStringList(_key, updatedEncounters);
  }

  static Future<void> clearEncounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> duplicateEncounter(Encounter encounter) async {
    final duplicatedEncounter = Encounter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${encounter.name} Copy',
      participants: encounter.participants.map((participant) {
        return Participant(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: participant.name,
          type: participant.type,
          maxHp: participant.maxHp,
          currentHp: participant.maxHp,
          initiative: participant.initiative,
          imagePath: participant.imagePath,
        );
      }).toList(),
    );

    await saveEncounter(duplicatedEncounter);
  }
}
