class Task {
  int id;
  String title;
  String description;
  int priority = 0;
  String createdOn;
  DateTime remainder;
  bool isDone = false;
  Task({
    this.title,
    this.description,
    this.priority,
    this.createdOn,
    this.remainder,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "priority": priority,
      "createdOn": createdOn,
      "remainder": remainder != null ? remainder.toString() : null,
      "isDone": isDone ? 1 : 0,
    };
  }

  Task.fromMap(Map<String, dynamic> task) {
    id = task["id"];
    title = task["title"];
    description = task["description"];
    priority = task["priority"];
    createdOn = task["createdOn"];
    remainder =
        task["remainder"] != null ? DateTime.parse(task["remainder"]) : null;
    isDone = task["isDone"] == 1;
  }
}
