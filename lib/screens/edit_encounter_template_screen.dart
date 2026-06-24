import 'package:flutter/material.dart';

import '../models/encounter.dart';
import '../services/encounter_storage.dart';

class EditEncounterTemplateScreen extends StatefulWidget {
  final Encounter encounter;

  const EditEncounterTemplateScreen({super.key, required this.encounter});

  @override
  State<EditEncounterTemplateScreen> createState() =>
      _EditEncounterTemplateScreenState();
}

class _EditEncounterTemplateScreenState
    extends State<EditEncounterTemplateScreen> {
  late TextEditingController nameController;
  late Encounter encounter;

  @override
  void initState() {
    super.initState();

    encounter = widget.encounter;

    nameController = TextEditingController(text: encounter.name);
  }

  Future<void> saveChanges() async {
    final updatedEncounter = Encounter(
      id: encounter.id,
      name: nameController.text.trim(),
      participants: encounter.participants,
      currentTurnIndex: encounter.currentTurnIndex,
      round: encounter.round,
    );

    await EncounterStorage.updateEncounter(updatedEncounter);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  void removeParticipant(int index) {
    setState(() {
      encounter.participants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Template'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: saveChanges),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Encounter Name'),
          ),

          const SizedBox(height: 24),

          const Text(
            'Participants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          for (int i = 0; i < encounter.participants.length; i++)
            Card(
              child: ListTile(
                title: Text(encounter.participants[i].name),
                subtitle: Text(encounter.participants[i].type.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeParticipant(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
