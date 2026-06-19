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

  factory Encounter.fromJson(Map<String, dynamic> json) {
    return Encounter(
      id: json['id'],
      name: json['name'],
      participants: (json['participants'] as List)
          .map((item) => Participant.fromJson(item))
          .toList(),
      currentTurnIndex: json['currentTurnIndex'] ?? 0,
      round: json['round'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants.map((p) => p.toJson()).toList(),
      'currentTurnIndex': currentTurnIndex,
      'round': round,
    };
  }

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

  void addParticipant(Participant participant) {
    participants.add(participant);
  }

  void removeParticipant(Participant participant) {
    participants.remove(participant);
  }
}
