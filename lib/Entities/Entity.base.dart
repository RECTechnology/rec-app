abstract class Entity {
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  Entity(
    this.id,
    String createdAt,
    String updatedAt,
  ) {
    this.createdAt =
        createdAt != null ? DateTime.parse(createdAt) : DateTime.now();
    this.updatedAt =
        updatedAt != null ? DateTime.parse(updatedAt) : DateTime.now();
  }

  bool equals(Entity other) {
    return id == other.id;
  }

  Map<String, dynamic> toJson() {
    return Map.from({});
  }
}
