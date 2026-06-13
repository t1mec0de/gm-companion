import 'status_effect.dart';

enum ParticipantType { player, enemy, boss }

class Participant {
  final String id;
  final String name;
  final ParticipantType type;
  final int maxHp;
  int currentHp;
  int initiative;
  final List<StatusEffect> statuses;
  final String? imagePath;

  Participant({
    required this.id,
    required this.name,
    required this.type,
    required this.maxHp,
    required this.currentHp,
    required this.initiative,
    this.imagePath,
    this.statuses = const [],
  });

  void addStatus(StatusEffect status) {
    statuses.add(status);
  }

  void removeStatus(StatusEffect status) {
    statuses.remove(status);
  }

  void takeDamage(int amount) {
    currentHp -= amount;

    if (currentHp < 0) {
      currentHp = 0;
    }
  }

  void heal(int amount) {
    currentHp += amount;

    if (currentHp > maxHp) {
      currentHp = maxHp;
    }
  }

  bool get isDead => currentHp <= 0;

  double get hpPercent {
    if (maxHp <= 0) return 0;
    return currentHp / maxHp;
  }
}
