import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final recipeProvider = RecipeProvider();
  await recipeProvider.loadRecipes();
  runApp(RecipeHubApp(provider: recipeProvider));
}

class RecipeHubApp extends StatelessWidget {
  const RecipeHubApp({super.key, required this.provider});

  final RecipeProvider provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RecipeHub',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
