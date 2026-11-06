import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeStorage {
  static const _storageKey = 'recipe_hub_recipes_v1';

  Future<List<Recipe>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Recipe.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> save(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(recipes.map((recipe) => recipe.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }
}
