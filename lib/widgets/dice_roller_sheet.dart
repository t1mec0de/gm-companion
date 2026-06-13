import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DiceRollerSheet extends StatefulWidget {
  const DiceRollerSheet({super.key});

  @override
  State<DiceRollerSheet> createState() => _DiceRollerSheetState();
}

class _DiceRollerSheetState extends State<DiceRollerSheet> {
  final Random _random = Random();

  int selectedDie = 20;
  int currentValue = 20;
  bool isRolling = false;
  String resultText = 'Choose a die and roll';

  void _rollDie(int sides) {
    if (isRolling) return;

    selectedDie = sides;
    isRolling = true;
    resultText = 'Rolling d$sides...';

    int ticks = 0;

    Timer.periodic(const Duration(milliseconds: 70), (timer) {
      ticks++;

      setState(() {
        currentValue = _random.nextInt(sides) + 1;
      });

      if (ticks >= 12) {
        timer.cancel();

        setState(() {
          isRolling = false;

          if (currentValue == sides) {
            resultText = 'Critical Success!';
          } else if (currentValue == 1) {
            resultText = 'Critical Failure!';
          } else {
            resultText = 'Rolled d$sides';
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dice = [4, 6, 8, 10, 12, 20, 100];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('Dice Roller', style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 20, width: double.infinity),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            child: Text(
              '$currentValue',
              key: ValueKey(currentValue),
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8, width: double.infinity),

          Text('d$selectedDie', style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 8, width: double.infinity),

          Text(resultText, style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 20, width: double.infinity),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final die in dice)
                ElevatedButton(
                  onPressed: isRolling ? null : () => _rollDie(die),
                  child: Text('d$die'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
