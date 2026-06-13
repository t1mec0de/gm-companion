enum StatusType { buff, debuff, condition }

class StatusEffect {
  final String id;
  final String name;
  final String description;
  final StatusType type;

  StatusEffect({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });
}
