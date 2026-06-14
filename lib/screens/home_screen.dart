import 'package:flutter/material.dart';
import 'combat_tracker_screen.dart';
import 'create_encounter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildSessionPage(),
      _buildCompendiumPage(),
      _buildMusicPage(),
      _buildSettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('GM Companion')),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Session'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSessionPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Game Master',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text('Manage combat, music and sessions.'),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Demo Combat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CombatTrackerScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('Solo Mode'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateEncounterScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Online Session'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompendiumPage() {
    return const Center(child: Text('Compendium Coming Soon'));
  }

  Widget _buildMusicPage() {
    return const Center(child: Text('Music Engine Coming Soon'));
  }

  Widget _buildSettingsPage() {
    return const Center(child: Text('Settings Coming Soon'));
  }
}
