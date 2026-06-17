import 'package:flutter/material.dart';
import '../data/demo_encounter.dart';
import '../models/encounter.dart';
import '../widgets/dice_roller_sheet.dart';

class CombatTrackerScreen extends StatefulWidget {
  final Encounter? encounter;

  const CombatTrackerScreen({super.key, this.encounter});

  @override
  State<CombatTrackerScreen> createState() => _CombatTrackerScreenState();
}

class _CombatTrackerScreenState extends State<CombatTrackerScreen> {
  late final Encounter encounter;
  bool initiativeConfirmed = false;

  @override
  void initState() {
    super.initState();
    encounter = widget.encounter ?? demoEncounter;
  }

  @override
  Widget build(BuildContext context) {
    return initiativeConfirmed
        ? _buildCombatScreen()
        : _buildInitiativeScreen();
  }

  Widget _buildInitiativeScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Initiative')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Enter initiative for each participant',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),

          for (final p in encounter.participants)
            Card(
              child: ListTile(
                title: Text(p.name),
                subtitle: Text(p.type.name),
                trailing: SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: p.initiative.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Init'),
                    onChanged: (value) {
                      p.initiative = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ),
            ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _confirmInitiative,
            child: const Text('Confirm Initiative'),
          ),
        ],
      ),
    );
  }

  Widget _buildCombatScreen() {
    final current = encounter.currentParticipant;

    return Scaffold(
      appBar: AppBar(title: Text(encounter.name)),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Round ${encounter.round}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Current Turn: ${current.name}',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 16),

          for (final p in encounter.participants)
            Card(
              child: ListTile(
                leading: p.id == current.id
                    ? const Icon(Icons.play_arrow)
                    : null,

                title: Text(p.name),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HP: ${p.currentHp}/${p.maxHp}'),

                    const SizedBox(height: 6),

                    LinearProgressIndicator(value: p.hpPercent, minHeight: 8),

                    const SizedBox(height: 6),

                    Text('Initiative: ${p.initiative}'),

                    if (p.statuses.isNotEmpty) ...[
                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 6,
                        children: [
                          for (final status in p.statuses)
                            Chip(label: Text(status.name)),
                        ],
                      ),
                    ],
                  ],
                ),

                trailing: p.isDead
                    ? const Icon(Icons.close, color: Colors.red)
                    : null,

                onTap: () => _openParticipantActions(p),
              ),
            ),

          const SizedBox(height: 12),

          ElevatedButton(onPressed: _nextTurn, child: const Text('Next Turn')),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openDiceRoller,
        icon: const Icon(Icons.casino),
        label: const Text('Roll Dice'),
      ),
    );
  }

  void _confirmInitiative() {
    setState(() {
      encounter.sortByInitiative();
      encounter.currentTurnIndex = 0;
      encounter.round = 1;
      initiativeConfirmed = true;
    });
  }

  void _nextTurn() {
    setState(encounter.nextTurn);
  }

  void _openParticipantActions(dynamic p) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('Damage 5 HP'),
              onTap: () {
                setState(() {
                  p.takeDamage(5);
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text('Add Status'),
              onTap: () {
                Navigator.pop(context);
                _openStatusPicker(p);
              },
            ),

            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Heal 5 HP'),
              onTap: () {
                setState(() {
                  p.heal(5);
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Mark as Dead'),
              onTap: () {
                setState(() {
                  p.takeDamage(p.currentHp);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openStatusPicker(dynamic p) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            for (final status in availableStatuses)
              ListTile(
                title: Text(status.name),
                subtitle: Text(status.description),
                onTap: () {
                  setState(() {
                    p.addStatus(status);
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openDiceRoller() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const DiceRollerSheet(),
    );
  }
}
