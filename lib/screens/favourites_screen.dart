import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_tile.dart';
import 'recipe_detail_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = context.watch<RecipeProvider>().favourites;
    if (recipes.isEmpty) {
      return const Center(child: Text('No favourite recipes yet.'));
    }
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: recipes.map((recipe) => RecipeTile(
        recipe: recipe,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(recipeId: recipe.id))),
        onFavourite: () => context.read<RecipeProvider>().toggleFavourite(recipe.id),
      )).toList(),
    );
  }
}
