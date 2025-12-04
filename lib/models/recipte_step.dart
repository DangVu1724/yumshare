class RecipeStep {
  int stepNumber;
  String description;
  final String? imageUrl;

  RecipeStep({required this.stepNumber, required this.description, this.imageUrl});

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      stepNumber: map['stepNumber'] ?? 0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'stepNumber': stepNumber, 'description': description, 'imageUrl': imageUrl};
  }
}
