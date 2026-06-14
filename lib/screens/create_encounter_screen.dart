import 'package:flutter/material.dart';

class CreateEncounterScreen extends StatefulWidget {
  const CreateEncounterScreen({super.key});

  @override
  State<CreateEncounterScreen> createState() => _CreateEncounterScreenState();
}

class _CreateEncounterScreenState extends State<CreateEncounterScreen> {
  final TextEditingController nameController = TextEditingController();

  final List<String> participants = [];
  String notes = '';

  void addPlayer() {
    setState(() {
      participants.add('Player ${participants.length + 1}');
    });
  }

  void addEnemy() {
    setState(() {
      participants.add('Enemy ${participants.length + 1}');
    });
  }

  void addBoss() {
    setState(() {
      participants.add('Boss');
    });
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature coming soon')));
  }

  void openNotesDialog() {
    final controller = TextEditingController(text: notes);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Encounter Notes'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Write GM notes here...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notes = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

          for (final participant in participants)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(participant),
              ),
            ),

          if (participants.isEmpty)
            const Text(
              'No participants yet.',
              style: TextStyle(color: Colors.grey),
            ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: addPlayer,
                icon: const Icon(Icons.person_add),
                label: const Text('Player'),
              ),
              ElevatedButton.icon(
                onPressed: addEnemy,
                icon: const Icon(Icons.shield),
                label: const Text('Enemy'),
              ),
              ElevatedButton.icon(
                onPressed: addBoss,
                icon: const Icon(Icons.warning),
                label: const Text('Boss'),
              ),
              OutlinedButton.icon(
                onPressed: () => showComingSoon('Library import'),
                icon: const Icon(Icons.menu_book),
                label: const Text('Library'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Encounter Assets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('GM Notes'),
              subtitle: Text(
                notes.isEmpty ? 'No notes added' : notes,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: openNotesDialog,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Encounter Image'),
              subtitle: const Text('Add map, scene or creature art later'),
              onTap: () => showComingSoon('Image picker'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Music Preset'),
              subtitle: const Text('Attach combat music later'),
              onTap: () => showComingSoon('Music preset'),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Combat'),
            ),
          ),
        ],
      ),
    );
  }
}
