import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavourite,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.restaurant_menu),
        ),
        title: Text(recipe.name,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${recipe.category} • ${recipe.ingredients.length} ingredients'),
        trailing: IconButton(
          tooltip: recipe.isFavourite ? 'Remove favourite' : 'Add favourite',
          onPressed: onFavourite,
          icon: Icon(
            recipe.isFavourite ? Icons.favorite : Icons.favorite_border,
            color: recipe.isFavourite ? Colors.red : null,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
