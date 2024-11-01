class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  late final bool isCompleted;
  final bool isRepeated;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isRepeated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
    );
  }
}
