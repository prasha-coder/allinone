import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../models/food_model.dart';
import '../models/recipe_model.dart';

class ComprehensiveDataService {
  static final ComprehensiveDataService _instance = ComprehensiveDataService._internal();
  factory ComprehensiveDataService() => _instance;
  ComprehensiveDataService._internal();

  List<Patient>? _patients;
  List<Food>? _foods;
  List<Recipe>? _recipes;
  List<DietChartSummary>? _dietChartSummaries;
  List<DietChartMeal>? _dietChartMeals;

  // Load all data from CSV files
  Future<void> loadAllData() async {
    await Future.wait([
      _loadPatients(),
      _loadFoods(),
      _loadRecipes(),
      _loadDietChartSummaries(),
      _loadDietChartMeals(),
    ]);
  }

  // Load patients from CSV
  Future<void> _loadPatients() async {
    try {
      final String response = await rootBundle.loadString('Patient_Profile_1000 (1).csv');
      final List<String> lines = response.split('\n');
      
      _patients = [];
      for (int i = 1; i < lines.length; i++) { // Skip header
        if (lines[i].trim().isNotEmpty) {
          final List<String> values = _parseCSVLine(lines[i]);
          if (values.length >= 14) {
            _patients!.add(Patient(
              patientId: values[0],
              namePseudonym: values[1],
              age: int.tryParse(values[2]) ?? 0,
              gender: values[3],
              contactInfo: values[4],
              dietaryHabits: values[5],
              mealFrequencyPerDay: int.tryParse(values[6]) ?? 3,
              bowelMovements: values[7],
              waterIntakeLiters: double.tryParse(values[8]) ?? 2.0,
              physicalActivityLevel: values[9],
              sleepPatterns: values[10],
              stressLevels: values[11],
              allergies: values[12],
              comorbidities: values[13],
              doshaPrakritiAssessment: values.length > 14 ? values[14] : 'Balanced',
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading patients: $e');
      _patients = [];
    }
  }

  // Load foods from CSV
  Future<void> _loadFoods() async {
    try {
      final String response = await rootBundle.loadString('Food_Database_10000 (1).csv');
      final List<String> lines = response.split('\n');
      
      _foods = [];
      for (int i = 1; i < lines.length; i++) { // Skip header
        if (lines[i].trim().isNotEmpty) {
          final List<String> values = _parseCSVLine(lines[i]);
          if (values.length >= 18) {
            _foods!.add(Food(
              foodId: values[0],
              foodNameEnglish: values[1],
              foodNameLocal: values[2],
              baseItem: values[3],
              category: values[4],
              cuisine: values[5],
              scientificName: values[6],
              description: values[7],
              mealType: values[8],
              servingSizeG: double.tryParse(values[9]) ?? 100.0,
              rasa: values[10],
              virya: values[11],
              vipaka: values[12],
              guna: values[13],
              digestibility: values[14],
              doshaSuitability: values[15],
              allergenWarnings: values[16],
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading foods: $e');
      _foods = [];
    }
  }

  // Load recipes from CSV
  Future<void> _loadRecipes() async {
    try {
      final String response = await rootBundle.loadString('Recipe_Database_600 (1).csv');
      final List<String> lines = response.split('\n');
      
      _recipes = [];
      for (int i = 1; i < lines.length; i++) { // Skip header
        if (lines[i].trim().isNotEmpty) {
          final List<String> values = _parseCSVLine(lines[i]);
          if (values.length >= 18) {
            _recipes!.add(Recipe(
              recipeId: values[0],
              recipeName: values[1],
              recipeNameLocal: values[1], // Use same as English name
              cuisine: 'Indian', // Default cuisine
              category: 'Main Course', // Default category
              mealType: 'All', // Default meal type
              description: 'Ayurvedic recipe with comprehensive nutritional data',
              ingredients: _parseIngredients(values[2]),
              instructions: ['Follow traditional cooking method: ${values[3]}'],
              prepTimeMinutes: 15, // Default prep time
              cookTimeMinutes: 30, // Default cook time
              servings: 4, // Default servings
              difficulty: 'Medium', // Default difficulty
              tags: ['Ayurvedic', 'Healthy'],
              doshaSuitability: values[16],
              allergenWarnings: 'Check individual ingredients',
              imageUrl: '',
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading recipes: $e');
      _recipes = [];
    }
  }

  // Load diet chart summaries from CSV
  Future<void> _loadDietChartSummaries() async {
    try {
      final String response = await rootBundle.loadString('Diet_Charts_Summary_2000 (1).csv');
      final List<String> lines = response.split('\n');
      
      _dietChartSummaries = [];
      for (int i = 1; i < lines.length; i++) { // Skip header
        if (lines[i].trim().isNotEmpty) {
          final List<String> values = _parseCSVLine(lines[i]);
          if (values.length >= 9) {
            _dietChartSummaries!.add(DietChartSummary(
              chartId: values[0],
              patientId: values[1],
              date: DateTime.tryParse(values[2]) ?? DateTime.now(),
              totalCalories: double.tryParse(values[3]) ?? 0.0,
              totalProtein: double.tryParse(values[4]) ?? 0.0,
              totalFat: double.tryParse(values[5]) ?? 0.0,
              totalCarbs: double.tryParse(values[6]) ?? 0.0,
              totalFiber: double.tryParse(values[7]) ?? 0.0,
              clinicalNotes: values[8],
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading diet chart summaries: $e');
      _dietChartSummaries = [];
    }
  }

  // Load diet chart meals from CSV
  Future<void> _loadDietChartMeals() async {
    try {
      final String response = await rootBundle.loadString('Diet_Charts_Meals_~8000rows (1).csv');
      final List<String> lines = response.split('\n');
      
      _dietChartMeals = [];
      for (int i = 1; i < lines.length; i++) { // Skip header
        if (lines[i].trim().isNotEmpty) {
          final List<String> values = _parseCSVLine(lines[i]);
          if (values.length >= 13) {
            _dietChartMeals!.add(DietChartMeal(
              chartId: values[0],
              patientId: values[1],
              date: DateTime.tryParse(values[2]) ?? DateTime.now(),
              mealTime: values[3],
              itemType: values[4],
              itemId: values[5],
              portion: double.tryParse(values[6]) ?? 0.0,
              calories: double.tryParse(values[7]) ?? 0.0,
              protein: double.tryParse(values[8]) ?? 0.0,
              fat: double.tryParse(values[9]) ?? 0.0,
              carbs: double.tryParse(values[10]) ?? 0.0,
              fiber: double.tryParse(values[11]) ?? 0.0,
              ayurvedaNotes: values.length > 12 ? values[12] : '',
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading diet chart meals: $e');
      _dietChartMeals = [];
    }
  }

  // Parse CSV line handling commas within quotes
  List<String> _parseCSVLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    String current = '';
    
    for (int i = 0; i < line.length; i++) {
      String char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.trim());
        current = '';
      } else {
        current += char;
      }
    }
    result.add(current.trim());
    return result;
  }

  // Parse ingredients string
  List<RecipeIngredient> _parseIngredients(String ingredientsStr) {
    List<RecipeIngredient> ingredients = [];
    if (ingredientsStr.isNotEmpty) {
      final parts = ingredientsStr.split(',');
      for (final part in parts) {
        final itemParts = part.split(':');
        if (itemParts.length >= 2) {
          ingredients.add(RecipeIngredient(
            foodId: itemParts[0],
            foodName: itemParts[0], // Use ID as name for now
            quantity: double.tryParse(itemParts[1]) ?? 0.0,
            unit: 'g',
            notes: '',
          ));
        }
      }
    }
    return ingredients;
  }

  // Getters for data access
  List<Patient> get patients => _patients ?? [];
  List<Food> get foods => _foods ?? [];
  List<Recipe> get recipes => _recipes ?? [];
  List<DietChartSummary> get dietChartSummaries => _dietChartSummaries ?? [];
  List<DietChartMeal> get dietChartMeals => _dietChartMeals ?? [];

  // Get patient by ID
  Patient? getPatientById(String patientId) {
    return _patients?.firstWhere(
      (patient) => patient.patientId == patientId,
      orElse: () => throw StateError('Patient not found'),
    );
  }

  // Get diet charts for a patient
  List<DietChartSummary> getDietChartsForPatient(String patientId) {
    return _dietChartSummaries?.where((chart) => chart.patientId == patientId).toList() ?? [];
  }

  // Get meals for a diet chart
  List<DietChartMeal> getMealsForChart(String chartId) {
    return _dietChartMeals?.where((meal) => meal.chartId == chartId).toList() ?? [];
  }

  // Get food by ID
  Food? getFoodById(String foodId) {
    return _foods?.firstWhere(
      (food) => food.foodId == foodId,
      orElse: () => throw StateError('Food not found'),
    );
  }

  // Get recipe by ID
  Recipe? getRecipeById(String recipeId) {
    return _recipes?.firstWhere(
      (recipe) => recipe.recipeId == recipeId,
      orElse: () => throw StateError('Recipe not found'),
    );
  }
}

// Additional models for CSV data
class DietChartSummary {
  final String chartId;
  final String patientId;
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;
  final double totalFiber;
  final String clinicalNotes;

  const DietChartSummary({
    required this.chartId,
    required this.patientId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
    required this.totalFiber,
    required this.clinicalNotes,
  });
}

class DietChartMeal {
  final String chartId;
  final String patientId;
  final DateTime date;
  final String mealTime;
  final String itemType;
  final String itemId;
  final double portion;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final String ayurvedaNotes;

  const DietChartMeal({
    required this.chartId,
    required this.patientId,
    required this.date,
    required this.mealTime,
    required this.itemType,
    required this.itemId,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.ayurvedaNotes,
  });
}
