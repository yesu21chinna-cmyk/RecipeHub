import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<RecipeProvider>().recipes
        .where((item) => item.id == recipeId);
    final recipe = matches.isEmpty ? null : matches.first;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe details')),
        body: const Center(child: Text('This recipe is no longer available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
  title: Text(recipe.name),
  actions: [
    IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Edit',
      onPressed: () => _showEditDialog(context, recipe),
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Delete',
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete recipe?'),
            content: Text('Delete "${recipe.name}"? This cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await Provider.of<RecipeProvider>(context, listen: false)
              .deleteRecipe(recipe.id);
          if (context.mounted) Navigator.pop(context);
        }
      },
    ),
  ],
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            child: Icon(Icons.restaurant, size: 42,
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(recipe.name,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          Center(child: Chip(label: Text(recipe.category))),
          if (recipe.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(recipe.description),
          ],
          const SizedBox(height: 24),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...recipe.ingredients.map((item) => ListTile(
            dense: true,
            leading: const Icon(Icons.check_circle_outline),
            title: Text(item),
          )),
          const SizedBox(height: 16),
          Text('Preparation steps',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...recipe.steps.asMap().entries.map((entry) => ListTile(
            leading: CircleAvatar(child: Text('${entry.key + 1}')),
            title: Text(entry.value),
          )),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.read<RecipeProvider>()
                .toggleFavourite(recipe.id),
            icon: Icon(recipe.isFavourite ? Icons.favorite : Icons.favorite_border),
            label: Text(recipe.isFavourite
                ? 'Remove from favourites' : 'Add to favourites'),
          ),
        ],
      ),
    );
  }
  void _showEditDialog(BuildContext context, Recipe recipe) {
    final nameController = TextEditingController(text: recipe.name);
    final descController = TextEditingController(text: recipe.description);
    final categoryController = TextEditingController(text: recipe.category);
    final ingredientsController =
        TextEditingController(text: recipe.ingredients.join(', '));
    final stepsController =
        TextEditingController(text: recipe.steps.join('\n'));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Recipe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 14),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description')),
                  const SizedBox(height: 14),
              TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category')),
                  const SizedBox(height: 14),
              TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                      labelText: 'Ingredients (comma separated)')),
                  const SizedBox(height: 14),
              TextField(
                  controller: stepsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: 'Steps (one per line)')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updated = recipe.copyWith(
                name: nameController.text.trim(),
                description: descController.text.trim(),
                category: categoryController.text.trim(),
                ingredients: ingredientsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                steps: stepsController.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
              );
             Provider.of<RecipeProvider>(context, listen: false).updateRecipe(
  id: updated.id,
  name: updated.name,
  description: updated.description,
  category: updated.category,
  ingredients: updated.ingredients,
  steps: updated.steps,
);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
