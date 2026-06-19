import 'package:flutter/material.dart';

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
          return Card(
            child: ListTile(
              title: Text(sections[index]),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
