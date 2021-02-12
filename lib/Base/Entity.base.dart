abstract class Entity {
  String createdAt;
  String updatedAt;
  String id;

  Entity(
    this.id,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, dynamic> toJson() {
    return Map.from({});
  }
}
