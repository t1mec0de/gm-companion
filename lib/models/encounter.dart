import 'participant.dart';

class Encounter {
  final String id;
  final String name;
  final List<Participant> participants;

  int currentTurnIndex;
  int round;

  Encounter({
    required this.id,
    required this.name,
    required this.participants,
    this.currentTurnIndex = 0,
    this.round = 1,
  });

  Participant get currentParticipant => participants[currentTurnIndex];

  void sortByInitiative() {
    participants.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  void nextTurn() {
    if (participants.isEmpty) return;

    currentTurnIndex++;

    if (currentTurnIndex >= participants.length) {
      currentTurnIndex = 0;
      round++;
    }
  }
}
