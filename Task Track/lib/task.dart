class Task {
  int? id;
  String name;
  String description;
  bool isCompleted;
  bool isRepeated; // Added repeat flag

  Task({
    this.id,
    required this.name,
    required this.description,
    this.isCompleted = false,
    this.isRepeated = false, // Default is false
  });

  // Convert Task object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // Store as 1 for true, 0 for false
      'isRepeated': isRepeated ? 1 : 0,   // Store repeat flag
    };
  }

  // Convert Map to Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1, // Convert from int to bool
      isRepeated: map['isRepeated'] == 1,   // Convert from int to bool
    );
  }
}
