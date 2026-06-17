import 'package:flutter/material.dart';
import '../models/encounter.dart';
import '../models/participant.dart';
import 'combat_tracker_screen.dart';

class CreateEncounterScreen extends StatefulWidget {
  const CreateEncounterScreen({super.key});

  @override
  State<CreateEncounterScreen> createState() => _CreateEncounterScreenState();
}

class _CreateEncounterScreenState extends State<CreateEncounterScreen> {
  final nameController = TextEditingController();
  final List<Participant> participants = [];

  void openParticipantDialog(ParticipantType type) {
    final participantNameController = TextEditingController();
    final hpController = TextEditingController(text: '100');
    final initiativeController = TextEditingController(text: '10');

    if (type == ParticipantType.enemy) {
      hpController.text = '40';
    }

    if (type == ParticipantType.boss) {
      hpController.text = '200';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add ${type.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: participantNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: hpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max HP'),
            ),
            TextField(
              controller: initiativeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Initiative'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              addParticipant(
                type,
                participantNameController.text,
                int.tryParse(hpController.text) ?? 1,
                int.tryParse(initiativeController.text) ?? 0,
              );

              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void addParticipant(
    ParticipantType type,
    String name,
    int maxHp,
    int initiative,
  ) {
    final fallbackName = switch (type) {
      ParticipantType.player => 'Player ${participants.length + 1}',
      ParticipantType.enemy => 'Enemy ${participants.length + 1}',
      ParticipantType.boss => 'Boss ${participants.length + 1}',
    };

    setState(() {
      participants.add(
        Participant(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.trim().isEmpty ? fallbackName : name.trim(),
          type: type,
          maxHp: maxHp,
          currentHp: maxHp,
          initiative: initiative,
        ),
      );
    });
  }

  void startCombat() {
    final encounterName = nameController.text.trim().isEmpty
        ? 'Untitled Encounter'
        : nameController.text.trim();

    final encounter = Encounter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: encounterName,
      participants: participants,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CombatTrackerScreen(encounter: encounter),
      ),
    );
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final canStart = participants.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Encounter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Encounter Name'),
          ),

          const SizedBox(height: 20),

          const Text(
            'Participants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (participants.isEmpty)
            const Text(
              'No participants yet.',
              style: TextStyle(color: Colors.grey),
            ),

          for (final p in participants)
            Card(
              child: ListTile(
                leading: Icon(
                  p.type == ParticipantType.player
                      ? Icons.person
                      : p.type == ParticipantType.enemy
                      ? Icons.shield
                      : Icons.warning,
                ),
                title: Text(p.name),
                subtitle: Text(
                  '${p.type.name} • HP: ${p.currentHp}/${p.maxHp} • Initiative: ${p.initiative}',
                ),
              ),
            ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => openParticipantDialog(ParticipantType.player),
                icon: const Icon(Icons.person_add),
                label: const Text('Player'),
              ),
              ElevatedButton.icon(
                onPressed: () => openParticipantDialog(ParticipantType.enemy),
                icon: const Icon(Icons.shield),
                label: const Text('Enemy'),
              ),
              ElevatedButton.icon(
                onPressed: () => openParticipantDialog(ParticipantType.boss),
                icon: const Icon(Icons.warning),
                label: const Text('Boss'),
              ),
              OutlinedButton.icon(
                onPressed: () => showComingSoon('Library'),
                icon: const Icon(Icons.menu_book),
                label: const Text('Library'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('GM Notes'),
              subtitle: const Text('Coming soon'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Encounter Image'),
              subtitle: const Text('Coming soon'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Music Preset'),
              subtitle: const Text('Coming soon'),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canStart ? startCombat : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Combat'),
            ),
          ),
        ],
      ),
    );
  }
}
