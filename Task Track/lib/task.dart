class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final bool isCompleted;
  final bool isRepeated;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.isRepeated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'is_completed': isCompleted ? 1 : 0,
      'is_repeated': isRepeated ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['due_date'],
      isCompleted: map['is_completed'] == 1,
      isRepeated: map['is_repeated'] == 1,
    );
  }
}
