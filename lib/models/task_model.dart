class TaskModel {
  String id;
  String name;
  bool completed;

  TaskModel({
    required this.id,
    required this.name,
    required this.completed,
  });

  TaskModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        completed = map["completed"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "completed": completed,
    };
  }
}
