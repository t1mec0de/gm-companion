import 'package:flutter/material.dart';
import 'edit_encounter_template_screen.dart';
import '../models/encounter.dart';
import '../services/encounter_storage.dart';
import 'combat_tracker_screen.dart';

class EncounterTemplatesScreen extends StatefulWidget {
  const EncounterTemplatesScreen({super.key});

  @override
  State<EncounterTemplatesScreen> createState() =>
      _EncounterTemplatesScreenState();
}

class _EncounterTemplatesScreenState extends State<EncounterTemplatesScreen> {
  late Future<List<Encounter>> encountersFuture;

  @override
  void initState() {
    super.initState();
    reloadEncounters();
  }

  void reloadEncounters() {
    encountersFuture = EncounterStorage.loadEncounters();
  }

  void openEncounter(Encounter encounter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CombatTrackerScreen(encounter: encounter),
      ),
    );
  }

  Future<void> editEncounter(Encounter encounter) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditEncounterTemplateScreen(encounter: encounter),
      ),
    );

    if (result == true) {
      setState(() {
        reloadEncounters();
      });
    }
  }

  Future<void> duplicateEncounter(Encounter encounter) async {
    await EncounterStorage.duplicateEncounter(encounter);

    setState(() {
      reloadEncounters();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${encounter.name} duplicated')));
  }

  Future<void> deleteEncounter(Encounter encounter) async {
    await EncounterStorage.deleteEncounterById(encounter.id);

    setState(() {
      reloadEncounters();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${encounter.name} deleted')));
  }

  Future<void> confirmDelete(Encounter encounter) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Encounter Template?'),
        content: Text('Delete "${encounter.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await deleteEncounter(encounter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Encounter Templates')),
      body: FutureBuilder<List<Encounter>>(
        future: encountersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final encounters = snapshot.data!;

          if (encounters.isEmpty) {
            return const Center(child: Text('No saved encounters yet.'));
          }

          return ListView.builder(
            itemCount: encounters.length,
            itemBuilder: (context, index) {
              final encounter = encounters[index];

              return Card(
                child: ListTile(
                  title: Text(encounter.name),
                  subtitle: Text(
                    '${encounter.participants.length} participants',
                  ),
                  onTap: () => openEncounter(encounter),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editEncounter(encounter),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => duplicateEncounter(encounter),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => confirmDelete(encounter),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
