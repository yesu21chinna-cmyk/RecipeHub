import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/recipe_storage.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider({RecipeStorage? storage})
      : _storage = storage ?? RecipeStorage();

  final RecipeStorage _storage;
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<Recipe> get favourites =>
      _recipes.where((recipe) => recipe.isFavourite).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _recipes = await _storage.load();
    } catch (_) {
      _error = 'Could not load saved recipes. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe({
    required String name,
    required String description,
    required String category,
    required List<String> ingredients,
    required List<String> steps,
    String? imagePath,
  }) async {
    final recipe = Recipe(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      description: description.trim(),
      category: category.trim().isEmpty ? 'General' : category.trim(),
      ingredients: ingredients,
      steps: steps,
      imagePath: imagePath,
    );
    _recipes = [..._recipes, recipe];
    await _saveAndNotify();
  }

  Future<void> toggleFavourite(String id) async {
    _recipes = _recipes
        .map((recipe) => recipe.id == id
            ? recipe.copyWith(isFavourite: !recipe.isFavourite)
            : recipe)
        .toList();
    await _saveAndNotify();
  }

  Future<void> deleteRecipe(String id) async {
    _recipes = _recipes.where((recipe) => recipe.id != id).toList();
    await _saveAndNotify();
  }
   Future<void> updateRecipe({
    required String id,
    required String name,
    required String description,
    required String category,
    required List<String> ingredients,
    required List<String> steps,
  }) async {
    _recipes = _recipes
        .map((recipe) => recipe.id == id
            ? recipe.copyWith(
                name: name.trim(),
                description: description.trim(),
                category: category.trim().isEmpty ? 'General' : category.trim(),
                ingredients: ingredients,
                steps: steps,
              )
            : recipe)
        .toList();
    await _saveAndNotify();
  }

  Future<void> _saveAndNotify() async {
    try {
      await _storage.save(_recipes);
      _error = null;
    } catch (_) {
      _error = 'Changes could not be saved. Please check device storage.';
    }
    notifyListeners();
  }
}
