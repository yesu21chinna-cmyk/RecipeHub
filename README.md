# RecipeHub – Flutter Group Project Starter

A recipe application built with Flutter and Dart. Users can browse recipes they have added, view ingredients and preparation steps, add recipes through a validated form, and mark favourites. Recipe data is stored locally on the device using SharedPreferences and JSON.

## Requirements covered
- Four or more screens: recipe list, recipe details, add recipe, favourites, and about.
- User-created data saved locally and retained after app restart.
- Loading, error/retry, and empty states on the recipe list.
- Form validation and item detail view.
- Provider (`ChangeNotifier`) shared between screens.
- One consistent Material 3 theme.
- Widget test included.

## Setup
1. Install Flutter stable 3.35 or newer, Android Studio, and JDK 17.
2. Create the platform folders if needed:
   ```bash
   flutter create .
   ```
3. Install packages:
   ```bash
   flutter pub get
   ```
4. Run:
   ```bash
   flutter run
   ```
5. Run tests:
   ```bash
   flutter test
   ```
6. Build release APK:
   ```bash
   flutter build apk --release
   ```
   APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Suggested folder ownership
- Member 1: recipe list and search.
- Member 2: recipe details and favourites.
- Member 3: add-recipe form and local storage.
- All members: integration, testing, GitHub commits, README, and demo.

Update this README with your actual team members, assigned files, screenshots, defect log, and any changes made by your group. Each member should make regular commits and understand the code they submit.

## Important
This starter stores user-created recipes locally; it does not fetch recipes from an online API. This satisfies the project specification's local-data option. Do not claim that online API functionality is included unless your team implements and tests it.
