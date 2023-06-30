class Friend {
  final int id;
  final String name;
  final DateTime? lastMessageAt;

  Friend({
    required this.id,
    required this.name,
    required this.lastMessageAt,
  });

  @override
  String toString() {
    return 'Friend(id: $id, name: $name, lastMessageAt: $lastMessageAt)';
  }
}
