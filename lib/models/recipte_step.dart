class RecipeStep {
  final int stepNumber;
  final int stepTime; // in minutes
  final String description;
  final String? imageUrl;

  RecipeStep({
    required this.stepNumber,
    required this.stepTime,
    required this.description,
    this.imageUrl,
  });

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      stepNumber: map['stepNumber'] ?? 0,
      stepTime: map['stepTime'] ?? 0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stepNumber': stepNumber,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
