import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Icon(Icons.menu_book, size: 64),
        SizedBox(height: 16),
        Text('About RecipeHub',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text(
          'RecipeHub helps you create, organise and revisit your favourite recipes. '
          'Recipes are saved on this device and remain available after restarting the app.',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('Browse your recipe collection'),
        ),
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text('Add recipes with ingredients and steps'),
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Save favourite recipes'),
        ),
      ],
    );
  }
}
