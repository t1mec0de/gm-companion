import '../models/encounter.dart';
import '../models/participant.dart';
import '../models/status_effect.dart';

final demoEncounter = Encounter(
  id: 'enc_001',
  name: 'Goblin Ambush',
  participants: [
    Participant(
      id: 'p1',
      name: 'Knight',
      type: ParticipantType.player,
      maxHp: 100,
      currentHp: 100,
      initiative: 14,
      imagePath: null,
    ),

    Participant(
      id: 'p2',
      name: 'Mage',
      type: ParticipantType.player,
      maxHp: 60,
      currentHp: 60,
      initiative: 18,
      imagePath: null,
    ),

    Participant(
      id: 'e1',
      name: 'Goblin',
      type: ParticipantType.enemy,
      maxHp: 45,
      currentHp: 45,
      initiative: 12,
      imagePath: null,
    ),

    Participant(
      id: 'b1',
      name: 'Abyss Herald',
      type: ParticipantType.boss,
      maxHp: 250,
      currentHp: 250,
      initiative: 20,
      imagePath: null,
    ),
  ],
)..sortByInitiative();

final availableStatuses = [
  StatusEffect(
    id: 'burning',
    name: 'Burning',
    description: 'Takes fire damage over time.',
    type: StatusType.debuff,
  ),
  StatusEffect(
    id: 'poisoned',
    name: 'Poisoned',
    description: 'Weakened by poison.',
    type: StatusType.debuff,
  ),
  StatusEffect(
    id: 'stunned',
    name: 'Stunned',
    description: 'Cannot act normally.',
    type: StatusType.condition,
  ),
  StatusEffect(
    id: 'blessed',
    name: 'Blessed',
    description: 'Empowered by magic.',
    type: StatusType.buff,
  ),
];
