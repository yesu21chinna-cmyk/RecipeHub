class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.isFavourite = false,
    this.imagePath,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavourite;
  final String? imagePath;

  Recipe copyWith({
    String? name,
    String? description,
    String? category,
    List<String>? ingredients,
    List<String>? steps,
    bool? isFavourite,
    String? imagePath,
  }) {
    return Recipe(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavourite: isFavourite ?? this.isFavourite,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'ingredients': ingredients,
        'steps': steps,
        'isFavourite': isFavourite,
        'imagePath': imagePath,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      ingredients: List<String>.from(json['ingredients'] as List? ?? const []),
      steps: List<String>.from(json['steps'] as List? ?? const []),
      isFavourite: json['isFavourite'] as bool? ?? false,
      imagePath: json['imagePath'] as String?,
    );
  }
}
