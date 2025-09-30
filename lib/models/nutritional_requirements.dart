class NutritionalRequirements {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double calcium;
  final double iron;
  final double vitaminA;
  final double vitaminC;
  final double vitaminD;
  final double vitaminE;
  final double vitaminB1;
  final double potassium;

  const NutritionalRequirements({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.calcium,
    required this.iron,
    required this.vitaminA,
    required this.vitaminC,
    required this.vitaminD,
    required this.vitaminE,
    required this.vitaminB1,
    required this.potassium,
  });

  // Get nutritional requirements based on age, gender, and activity level
  static NutritionalRequirements getRequirements({
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    // Base requirements by age and gender
    final baseRequirements = _getBaseRequirements(age, gender);
    
    // Adjust for activity level
    final activityMultiplier = _getActivityMultiplier(activityLevel);
    
    return NutritionalRequirements(
      calories: baseRequirements.calories * activityMultiplier,
      protein: baseRequirements.protein * activityMultiplier,
      carbs: baseRequirements.carbs * activityMultiplier,
      fat: baseRequirements.fat * activityMultiplier,
      fiber: baseRequirements.fiber,
      calcium: baseRequirements.calcium,
      iron: baseRequirements.iron,
      vitaminA: baseRequirements.vitaminA,
      vitaminC: baseRequirements.vitaminC,
      vitaminD: baseRequirements.vitaminD,
      vitaminE: baseRequirements.vitaminE,
      vitaminB1: baseRequirements.vitaminB1,
      potassium: baseRequirements.potassium,
    );
  }

  static NutritionalRequirements _getBaseRequirements(int age, String gender) {
    // Children (1-18 years)
    if (age >= 1 && age <= 3) {
      return const NutritionalRequirements(
        calories: 1000, protein: 13, carbs: 130, fat: 30, fiber: 14,
        calcium: 700, iron: 7, vitaminA: 300, vitaminC: 15, vitaminD: 15,
        vitaminE: 6, vitaminB1: 0.5, potassium: 3000,
      );
    } else if (age >= 4 && age <= 8) {
      return const NutritionalRequirements(
        calories: 1200, protein: 19, carbs: 130, fat: 25, fiber: 20,
        calcium: 1000, iron: 10, vitaminA: 400, vitaminC: 25, vitaminD: 15,
        vitaminE: 7, vitaminB1: 0.6, potassium: 3800,
      );
    } else if (age >= 9 && age <= 13) {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 1800, protein: 34, carbs: 130, fat: 25, fiber: 25,
          calcium: 1300, iron: 8, vitaminA: 600, vitaminC: 45, vitaminD: 15,
          vitaminE: 11, vitaminB1: 0.9, potassium: 4500,
        );
      } else {
        return const NutritionalRequirements(
          calories: 1600, protein: 34, carbs: 130, fat: 25, fiber: 25,
          calcium: 1300, iron: 8, vitaminA: 600, vitaminC: 45, vitaminD: 15,
          vitaminE: 11, vitaminB1: 0.9, potassium: 4500,
        );
      }
    } else if (age >= 14 && age <= 18) {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 2400, protein: 52, carbs: 130, fat: 30, fiber: 30,
          calcium: 1300, iron: 11, vitaminA: 900, vitaminC: 75, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.2, potassium: 4700,
        );
      } else {
        return const NutritionalRequirements(
          calories: 2000, protein: 46, carbs: 130, fat: 25, fiber: 25,
          calcium: 1300, iron: 15, vitaminA: 700, vitaminC: 65, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.0, potassium: 4700,
        );
      }
    }
    // Adults (19+ years)
    else if (age >= 19 && age <= 30) {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 2400, protein: 56, carbs: 130, fat: 30, fiber: 35,
          calcium: 1000, iron: 8, vitaminA: 900, vitaminC: 90, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.2, potassium: 4700,
        );
      } else {
        return const NutritionalRequirements(
          calories: 2000, protein: 46, carbs: 130, fat: 25, fiber: 25,
          calcium: 1000, iron: 18, vitaminA: 700, vitaminC: 75, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.1, potassium: 4700,
        );
      }
    } else if (age >= 31 && age <= 50) {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 2200, protein: 56, carbs: 130, fat: 30, fiber: 35,
          calcium: 1000, iron: 8, vitaminA: 900, vitaminC: 90, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.2, potassium: 4700,
        );
      } else {
        return const NutritionalRequirements(
          calories: 1800, protein: 46, carbs: 130, fat: 25, fiber: 25,
          calcium: 1000, iron: 18, vitaminA: 700, vitaminC: 75, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.1, potassium: 4700,
        );
      }
    } else if (age >= 51 && age <= 70) {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 2000, protein: 56, carbs: 130, fat: 30, fiber: 30,
          calcium: 1000, iron: 8, vitaminA: 900, vitaminC: 90, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.2, potassium: 4700,
        );
      } else {
        return const NutritionalRequirements(
          calories: 1600, protein: 46, carbs: 130, fat: 25, fiber: 25,
          calcium: 1200, iron: 8, vitaminA: 700, vitaminC: 75, vitaminD: 15,
          vitaminE: 15, vitaminB1: 1.1, potassium: 4700,
        );
      }
    }
    // Seniors (70+ years)
    else {
      if (gender.toLowerCase() == 'male') {
        return const NutritionalRequirements(
          calories: 1800, protein: 56, carbs: 130, fat: 30, fiber: 30,
          calcium: 1200, iron: 8, vitaminA: 900, vitaminC: 90, vitaminD: 20,
          vitaminE: 15, vitaminB1: 1.2, potassium: 4700,
        );
      } else {
        return const NutritionalRequirements(
          calories: 1600, protein: 46, carbs: 130, fat: 25, fiber: 25,
          calcium: 1200, iron: 8, vitaminA: 700, vitaminC: 75, vitaminD: 20,
          vitaminE: 15, vitaminB1: 1.1, potassium: 4700,
        );
      }
    }
  }

  static double _getActivityMultiplier(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'sedentary - no exercise':
        return 1.0;
      case 'light - 15 mins daily':
        return 1.2;
      case 'moderate - 30 mins daily':
        return 1.4;
      case 'active - 45 mins daily':
        return 1.6;
      case 'very active - 60+ mins daily':
        return 1.8;
      default:
        return 1.2;
    }
  }

  // Calculate percentage of daily requirements met
  Map<String, double> calculatePercentageMet(NutritionalRequirements actual) {
    return {
      'calories': (actual.calories / calories * 100).clamp(0, 200),
      'protein': (actual.protein / protein * 100).clamp(0, 200),
      'carbs': (actual.carbs / carbs * 100).clamp(0, 200),
      'fat': (actual.fat / fat * 100).clamp(0, 200),
      'fiber': (actual.fiber / fiber * 100).clamp(0, 200),
      'calcium': (actual.calcium / calcium * 100).clamp(0, 200),
      'iron': (actual.iron / iron * 100).clamp(0, 200),
      'vitaminA': (actual.vitaminA / vitaminA * 100).clamp(0, 200),
      'vitaminC': (actual.vitaminC / vitaminC * 100).clamp(0, 200),
      'vitaminD': (actual.vitaminD / vitaminD * 100).clamp(0, 200),
      'vitaminE': (actual.vitaminE / vitaminE * 100).clamp(0, 200),
      'vitaminB1': (actual.vitaminB1 / vitaminB1 * 100).clamp(0, 200),
      'potassium': (actual.potassium / potassium * 100).clamp(0, 200),
    };
  }
}
