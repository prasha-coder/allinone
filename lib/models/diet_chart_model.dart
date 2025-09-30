class DietChart {
  final String dietChartId;
  final String patientId;
  final String patientName;
  final DateTime createdDate;
  final DateTime validUntil;
  final Map<String, List<MealItem>> mealPlan;
  final NutritionalAnalysis nutritionalAnalysis;
  final List<String> ayurvedicRecommendations;
  final String notes;
  final String status;

  const DietChart({
    required this.dietChartId,
    required this.patientId,
    required this.patientName,
    required this.createdDate,
    required this.validUntil,
    required this.mealPlan,
    required this.nutritionalAnalysis,
    required this.ayurvedicRecommendations,
    required this.notes,
    required this.status,
  });

  factory DietChart.fromMap(Map<String, dynamic> map) {
    return DietChart(
      dietChartId: map['dietChartId'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      createdDate: DateTime.parse(map['createdDate'] ?? DateTime.now().toIso8601String()),
      validUntil: DateTime.parse(map['validUntil'] ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
      mealPlan: (map['mealPlan'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => MealItem.fromMap(e)).toList(),
        ),
      ) ?? {},
      nutritionalAnalysis: NutritionalAnalysis.fromMap(map['nutritionalAnalysis'] ?? {}),
      ayurvedicRecommendations: (map['ayurvedicRecommendations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dietChartId': dietChartId,
      'patientId': patientId,
      'patientName': patientName,
      'createdDate': createdDate.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'mealPlan': mealPlan.map(
        (key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()),
      ),
      'nutritionalAnalysis': nutritionalAnalysis.toMap(),
      'ayurvedicRecommendations': ayurvedicRecommendations,
      'notes': notes,
      'status': status,
    };
  }
}

class MealItem {
  final String mealType;
  final List<FoodItem> foods;
  final double totalCalories;
  final String notes;

  const MealItem({
    required this.mealType,
    required this.foods,
    required this.totalCalories,
    required this.notes,
  });

  factory MealItem.fromMap(Map<String, dynamic> map) {
    return MealItem(
      mealType: map['mealType'] ?? '',
      foods: (map['foods'] as List<dynamic>?)
          ?.map((e) => FoodItem.fromMap(e))
          .toList() ?? [],
      totalCalories: (map['totalCalories'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'foods': foods.map((e) => e.toMap()).toList(),
      'totalCalories': totalCalories,
      'notes': notes,
    };
  }
}

class FoodItem {
  final String foodId;
  final String foodNameEnglish;
  final String foodNameLocal;
  final double quantity;
  final String unit;
  final double calories;

  const FoodItem({
    required this.foodId,
    required this.foodNameEnglish,
    required this.foodNameLocal,
    required this.quantity,
    required this.unit,
    required this.calories,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      foodId: map['foodId'] ?? '',
      foodNameEnglish: map['foodNameEnglish'] ?? '',
      foodNameLocal: map['foodNameLocal'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      calories: (map['calories'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodNameEnglish': foodNameEnglish,
      'foodNameLocal': foodNameLocal,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
    };
  }
}

class NutritionalAnalysis {
  final double dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final double dailyFiber;
  final double dailyCalcium;
  final double dailyIron;
  final double dailyVitaminA;
  final double dailyVitaminC;
  final double dailyVitaminD;
  final double dailyVitaminE;
  final double dailyVitaminB1;
  final double dailyPotassium;

  const NutritionalAnalysis({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.dailyFiber,
    required this.dailyCalcium,
    required this.dailyIron,
    required this.dailyVitaminA,
    required this.dailyVitaminC,
    required this.dailyVitaminD,
    required this.dailyVitaminE,
    required this.dailyVitaminB1,
    required this.dailyPotassium,
  });

  factory NutritionalAnalysis.fromMap(Map<String, dynamic> map) {
    return NutritionalAnalysis(
      dailyCalories: (map['dailyCalories'] ?? 0).toDouble(),
      dailyProtein: (map['dailyProtein'] ?? 0).toDouble(),
      dailyCarbs: (map['dailyCarbs'] ?? 0).toDouble(),
      dailyFat: (map['dailyFat'] ?? 0).toDouble(),
      dailyFiber: (map['dailyFiber'] ?? 0).toDouble(),
      dailyCalcium: (map['dailyCalcium'] ?? 0).toDouble(),
      dailyIron: (map['dailyIron'] ?? 0).toDouble(),
      dailyVitaminA: (map['dailyVitaminA'] ?? 0).toDouble(),
      dailyVitaminC: (map['dailyVitaminC'] ?? 0).toDouble(),
      dailyVitaminD: (map['dailyVitaminD'] ?? 0).toDouble(),
      dailyVitaminE: (map['dailyVitaminE'] ?? 0).toDouble(),
      dailyVitaminB1: (map['dailyVitaminB1'] ?? 0).toDouble(),
      dailyPotassium: (map['dailyPotassium'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyCarbs': dailyCarbs,
      'dailyFat': dailyFat,
      'dailyFiber': dailyFiber,
      'dailyCalcium': dailyCalcium,
      'dailyIron': dailyIron,
      'dailyVitaminA': dailyVitaminA,
      'dailyVitaminC': dailyVitaminC,
      'dailyVitaminD': dailyVitaminD,
      'dailyVitaminE': dailyVitaminE,
      'dailyVitaminB1': dailyVitaminB1,
      'dailyPotassium': dailyPotassium,
    };
  }
}
