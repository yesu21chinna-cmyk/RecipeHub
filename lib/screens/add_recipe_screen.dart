import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _ingredients = TextEditingController();
  final _steps = TextEditingController();
  bool _saving = false;
   String? _imagePath;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _category.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredients.text
        .split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final steps = _steps.text
        .split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (ingredients.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one ingredient and one step.')),
      );
      return;
    }

    setState(() => _saving = true);
    await context.read<RecipeProvider>().addRecipe(
      name: _name.text,
      description: _description.text,
      category: _category.text,
      ingredients: ingredients,
      steps: steps,
      imagePath: _imagePath,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Recipe name'),
              validator: _required,
              maxLength: 80,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _category,
              decoration: const InputDecoration(labelText: 'Category (e.g. Breakfast)'),
              validator: _required,
              maxLength: 40,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Short description'),
              maxLength: 300,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ingredients,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                hintText: 'Enter one ingredient per line',
                alignLabelWithHint: true,
              ),
              validator: _required,
              maxLines: 5,
              maxLength: 1000,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _steps,
              decoration: const InputDecoration(
                labelText: 'Preparation steps',
                hintText: 'Enter one step per line',
                alignLabelWithHint: true,
              ),
              validator: _required,
              maxLines: 6,
              maxLength: 2000,
            ),
            const SizedBox(height: 16),
      GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _imagePath == null
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40),
                    SizedBox(height: 8),
                    Text('Tap to add photo'),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
      ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving...' : 'Save recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
