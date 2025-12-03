class Users {
  final String userId;
  final String name;
  final String email;
  final List<String> myRecipes;
  final List<String> favoriteRecipes;
  Users({
    required this.userId,
    required this.name,
    required this.email,
    required this.myRecipes,
    required this.favoriteRecipes,
  });

  Users copyWith({
    String? userId,
    String? name,
    String? email,
    List<String>? myRecipes,
    List<String>? favoriteRecipes,
  }) {
    return Users(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      myRecipes: myRecipes ?? this.myRecipes,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'myRecipes': myRecipes,
      'favoriteRecipes': favoriteRecipes,
    };
  }
}
