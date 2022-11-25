class PopActors {
  final int id;
  final String name;

  PopActors(
      {required this.id,
      required this.name});
  factory PopActors.fromJson(Map<String, dynamic> json) {
    return PopActors(
        id: json['person_id'],
        name: json['person_name'],);
  }
  @override
  String toString() {
    return name;
  }
}
