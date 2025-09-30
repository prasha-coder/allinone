import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../models/patient_model.dart';
import 'nutrition_service.dart';

class DietChartService {
  final NutritionService _nutritionService = NutritionService();

  // Generate Ayurvedic diet chart based on patient profile
  Future<DietChart> generateDietChart(Patient patient) async {
    try {
      // Get foods suitable for patient's dosha
      final suitableFoods = await _getDoshaSuitableFoods(patient.doshaPrakritiAssessment);
      
      // Generate meal plan based on patient's meal frequency
      final mealPlan = _generateMealPlan(patient, suitableFoods);
      
      // Calculate nutritional analysis
      final nutritionalAnalysis = await _calculateNutritionalAnalysis(mealPlan);
      
      // Generate Ayurvedic recommendations
      final ayurvedicRecommendations = _generateAyurvedicRecommendations(patient);
      
      return DietChart(
        patientId: patient.patientId,
        patientName: patient.namePseudonym,
        doshaType: patient.doshaPrakritiAssessment,
        mealPlan: mealPlan,
        nutritionalAnalysis: nutritionalAnalysis,
        ayurvedicRecommendations: ayurvedicRecommendations,
        generatedDate: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(days: 7)),
      );
    } catch (e) {
      debugPrint('Error generating diet chart: $e');
      rethrow;
    }
  }

  // Get foods suitable for specific dosha
  Future<List<Food>> _getDoshaSuitableFoods(String doshaAssessment) async {
    final allFoods = await _nutritionService.getAllFoods();
    
    return allFoods.where((food) {
      final doshaSuitability = food.doshaSuitability.toLowerCase();
      
      if (doshaAssessment.toLowerCase().contains('vata')) {
        return doshaSuitability.contains('vata:favorable');
      } else if (doshaAssessment.toLowerCase().contains('pitta')) {
        return doshaSuitability.contains('pitta:favorable');
      } else if (doshaAssessment.toLowerCase().contains('kapha')) {
        return doshaSuitability.contains('kapha:favorable');
      }
      
      return true; // If dosha not specified, include all foods
    }).toList();
  }

  // Generate meal plan based on patient preferences
  Map<String, List<MealItem>> _generateMealPlan(Patient patient, List<Food> suitableFoods) {
    final mealPlan = <String, List<MealItem>>{};
    
    // Filter foods based on dietary restrictions
    final filteredFoods = _filterFoodsByRestrictions(suitableFoods, patient);
    
    // Generate meals for each day of the week
    for (int day = 0; day < 7; day++) {
      final dayName = _getDayName(day);
      mealPlan[dayName] = _generateDayMeals(patient, filteredFoods, day);
    }
    
    return mealPlan;
  }

  // Filter foods based on patient restrictions
  List<Food> _filterFoodsByRestrictions(List<Food> foods, Patient patient) {
    return foods.where((food) {
      // Check for allergies
      if (patient.allergies.toLowerCase() != 'none' && 
          food.allergenWarnings.toLowerCase() != 'none') {
        final allergies = patient.allergies.toLowerCase().split(',');
        final foodAllergens = food.allergenWarnings.toLowerCase().split(',');
        
        for (final allergy in allergies) {
          for (final allergen in foodAllergens) {
            if (allergy.trim() == allergen.trim()) {
              return false;
            }
          }
        }
      }
      
      // Check dietary habits
      if (patient.dietaryHabits.toLowerCase().contains('vegetarian') && 
          food.category.toLowerCase() == 'meat') {
        return false;
      }
      
      if (patient.dietaryHabits.toLowerCase().contains('vegan') && 
          (food.category.toLowerCase() == 'meat' || 
           food.category.toLowerCase() == 'dairy' || 
           food.category.toLowerCase() == 'seafood')) {
        return false;
      }
      
      return true;
    }).toList();
  }

  // Generate meals for a specific day
  List<MealItem> _generateDayMeals(Patient patient, List<Food> foods, int day) {
    final meals = <MealItem>[];
    final mealFrequency = patient.mealFrequencyPerDay;
    
    // Breakfast
    if (mealFrequency >= 1) {
      meals.add(_generateMeal('Breakfast', foods.where((f) => 
          f.mealType.toLowerCase() == 'breakfast' || 
          f.mealType.toLowerCase() == 'all').toList()));
    }
    
    // Lunch
    if (mealFrequency >= 2) {
      meals.add(_generateMeal('Lunch', foods.where((f) => 
          f.mealType.toLowerCase() == 'lunch' || 
          f.mealType.toLowerCase() == 'all').toList()));
    }
    
    // Dinner
    if (mealFrequency >= 3) {
      meals.add(_generateMeal('Dinner', foods.where((f) => 
          f.mealType.toLowerCase() == 'dinner' || 
          f.mealType.toLowerCase() == 'all').toList()));
    }
    
    // Snacks
    if (mealFrequency >= 4) {
      meals.add(_generateMeal('Snack', foods.where((f) => 
          f.mealType.toLowerCase() == 'snack' || 
          f.mealType.toLowerCase() == 'all').toList()));
    }
    
    return meals;
  }

  // Generate a specific meal
  MealItem _generateMeal(String mealType, List<Food> availableFoods) {
    if (availableFoods.isEmpty) {
      return MealItem(
        mealType: mealType,
        foods: [],
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFat: 0,
      );
    }
    
    // Select 2-4 foods for the meal
    final selectedFoods = <Food>[];
    final shuffledFoods = List<Food>.from(availableFoods)..shuffle();
    
    final maxFoods = mealType == 'Snack' ? 2 : 4;
    for (int i = 0; i < maxFoods && i < shuffledFoods.length; i++) {
      selectedFoods.add(shuffledFoods[i]);
    }
    
    // Calculate nutritional totals
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    
    for (final food in selectedFoods) {
      // Use serving size for calculations
      final multiplier = food.servingSizeG / 100.0;
      totalCalories += 130 * multiplier; // Approximate calories
      totalProtein += 2.7 * multiplier; // Approximate protein
      totalCarbs += 28 * multiplier; // Approximate carbs
      totalFat += 0.3 * multiplier; // Approximate fat
    }
    
    return MealItem(
      mealType: mealType,
      foods: selectedFoods,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
    );
  }

  // Calculate nutritional analysis for the entire meal plan
  Future<NutritionalAnalysis> _calculateNutritionalAnalysis(Map<String, List<MealItem>> mealPlan) async {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;
    
    for (final dayMeals in mealPlan.values) {
      for (final meal in dayMeals) {
        totalCalories += meal.totalCalories;
        totalProtein += meal.totalProtein;
        totalCarbs += meal.totalCarbs;
        totalFat += meal.totalFat;
        totalFiber += meal.totalFiber;
      }
    }
    
    // Calculate daily averages
    final dailyCalories = totalCalories / 7;
    final dailyProtein = totalProtein / 7;
    final dailyCarbs = totalCarbs / 7;
    final dailyFat = totalFat / 7;
    final dailyFiber = totalFiber / 7;
    
    return NutritionalAnalysis(
      dailyCalories: dailyCalories,
      dailyProtein: dailyProtein,
      dailyCarbs: dailyCarbs,
      dailyFat: dailyFat,
      dailyFiber: dailyFiber,
      weeklyCalories: totalCalories,
      weeklyProtein: totalProtein,
      weeklyCarbs: totalCarbs,
      weeklyFat: totalFat,
      weeklyFiber: totalFiber,
    );
  }

  // Generate Ayurvedic recommendations
  List<String> _generateAyurvedicRecommendations(Patient patient) {
    final recommendations = <String>[];
    
    // Water intake recommendations
    if (patient.waterIntakeLiters < 2.0) {
      recommendations.add('Increase water intake to 2.5-3 liters daily for better digestion');
    }
    
    // Meal timing recommendations
    if (patient.mealFrequencyPerDay < 3) {
      recommendations.add('Consider having 3 regular meals daily for better metabolism');
    }
    
    // Sleep recommendations
    if (patient.sleepPatterns.toLowerCase().contains('disturbed') || 
        patient.sleepPatterns.toLowerCase().contains('poor')) {
      recommendations.add('Improve sleep quality with regular bedtime routine and avoid heavy meals before sleep');
    }
    
    // Stress management
    if (patient.stressLevels.toLowerCase().contains('high')) {
      recommendations.add('Practice stress management techniques like meditation and deep breathing');
    }
    
    // Physical activity
    if (patient.physicalActivityLevel.toLowerCase().contains('low') || 
        patient.physicalActivityLevel.toLowerCase().contains('sedentary')) {
      recommendations.add('Increase physical activity with daily walks or yoga practice');
    }
    
    // Dosha-specific recommendations
    if (patient.doshaPrakritiAssessment.toLowerCase().contains('vata')) {
      recommendations.add('Vata: Favor warm, cooked foods and regular meal times');
    } else if (patient.doshaPrakritiAssessment.toLowerCase().contains('pitta')) {
      recommendations.add('Pitta: Include cooling foods and avoid spicy, hot foods');
    } else if (patient.doshaPrakritiAssessment.toLowerCase().contains('kapha')) {
      recommendations.add('Kapha: Include light, warm foods and avoid heavy, oily foods');
    }
    
    return recommendations;
  }

  // Helper method to get day name
  String _getDayName(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day];
  }
}

// Diet Chart Model
class DietChart {
  final String patientId;
  final String patientName;
  final String doshaType;
  final Map<String, List<MealItem>> mealPlan;
  final NutritionalAnalysis nutritionalAnalysis;
  final List<String> ayurvedicRecommendations;
  final DateTime generatedDate;
  final DateTime validUntil;

  DietChart({
    required this.patientId,
    required this.patientName,
    required this.doshaType,
    required this.mealPlan,
    required this.nutritionalAnalysis,
    required this.ayurvedicRecommendations,
    required this.generatedDate,
    required this.validUntil,
  });
}

// Meal Item Model
class MealItem {
  final String mealType;
  final List<Food> foods;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;

  MealItem({
    required this.mealType,
    required this.foods,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.totalFiber = 0,
  });
}

// Nutritional Analysis Model
class NutritionalAnalysis {
  final double dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final double dailyFiber;
  final double weeklyCalories;
  final double weeklyProtein;
  final double weeklyCarbs;
  final double weeklyFat;
  final double weeklyFiber;

  NutritionalAnalysis({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.dailyFiber,
    required this.weeklyCalories,
    required this.weeklyProtein,
    required this.weeklyCarbs,
    required this.weeklyFat,
    required this.weeklyFiber,
  });
}
