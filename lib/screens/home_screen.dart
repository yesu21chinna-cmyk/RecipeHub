import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_tile.dart';
import 'add_recipe_screen.dart';
import 'favourites_screen.dart';
import 'recipe_detail_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildRecipeList(context),
      const FavouritesScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeHub'),
        actions: [
          IconButton(
            tooltip: 'Add recipe',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddRecipeScreen())),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddRecipeScreen())),
              icon: const Icon(Icons.add),
              label: const Text('Add recipe'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favourites'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'About'),
        ],
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final recipes = provider.recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(_search.toLowerCase()) ||
          recipe.category.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.recipes.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(provider.error!),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: provider.loadRecipes,
            child: const Text('Retry'),
          ),
        ]),
      );
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search recipes or categories',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _search = value),
        ),
      ),
      if (provider.error != null)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(provider.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      Expanded(
        child: recipes.isEmpty
            ? Center(
                child: Text(_search.isEmpty
                    ? 'No recipes yet. Tap “Add recipe” to begin.'
                    : 'No matching recipes found.'))
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 90),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final Recipe recipe = recipes[index];
                  return RecipeTile(
                    recipe: recipe,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                      ),
                    ),
                    onFavourite: () =>
                        context.read<RecipeProvider>().toggleFavourite(recipe.id),
                  );
                },
              ),
      ),
    ]);
  }
}
