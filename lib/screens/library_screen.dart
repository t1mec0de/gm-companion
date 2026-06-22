import 'package:flutter/material.dart';

import 'encounter_templates_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      'Monsters',
      'Bosses',
      'NPC',
      'Players',
      'Status Effects',
      'Music Presets',
      'Encounter Templates',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];

          return Card(
            child: ListTile(
              title: Text(section),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (section == 'Encounter Templates') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EncounterTemplatesScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$section coming soon')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
