import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_hub/main.dart';
import 'package:recipe_hub/providers/recipe_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RecipeHub opens and displays its title', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final provider = RecipeProvider();
    await provider.loadRecipes();

    await tester.pumpWidget(RecipeHubApp(provider: provider));
    await tester.pumpAndSettle();

    expect(find.text('RecipeHub'), findsOneWidget);
    expect(find.text('No recipes yet. Tap “Add recipe” to begin.'), findsOneWidget);
  });
}
