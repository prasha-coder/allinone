class Recipe {
  final String recipeId;
  final String recipeName;
  final String recipeNameLocal;
  final String cuisine;
  final String category;
  final String mealType;
  final String description;
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final List<String> tags;
  final String doshaSuitability;
  final String allergenWarnings;
  final String imageUrl;

  const Recipe({
    required this.recipeId,
    required this.recipeName,
    required this.recipeNameLocal,
    required this.cuisine,
    required this.category,
    required this.mealType,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.tags,
    required this.doshaSuitability,
    required this.allergenWarnings,
    required this.imageUrl,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      recipeId: map['recipeId'] ?? '',
      recipeName: map['recipeName'] ?? '',
      recipeNameLocal: map['recipeNameLocal'] ?? '',
      cuisine: map['cuisine'] ?? '',
      category: map['category'] ?? '',
      mealType: map['mealType'] ?? '',
      description: map['description'] ?? '',
      ingredients: (map['ingredients'] as List<dynamic>?)
          ?.map((e) => RecipeIngredient.fromMap(e))
          .toList() ?? [],
      instructions: (map['instructions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      prepTimeMinutes: map['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: map['cookTimeMinutes'] ?? 0,
      servings: map['servings'] ?? 1,
      difficulty: map['difficulty'] ?? 'Easy',
      tags: (map['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      doshaSuitability: map['doshaSuitability'] ?? '',
      allergenWarnings: map['allergenWarnings'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'recipeNameLocal': recipeNameLocal,
      'cuisine': cuisine,
      'category': category,
      'mealType': mealType,
      'description': description,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'instructions': instructions,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'tags': tags,
      'doshaSuitability': doshaSuitability,
      'allergenWarnings': allergenWarnings,
      'imageUrl': imageUrl,
    };
  }

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;
}

class RecipeIngredient {
  final String foodId;
  final String foodName;
  final double quantity;
  final String unit;
  final String notes;

  const RecipeIngredient({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.notes,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      foodId: map['foodId'] ?? '',
      foodName: map['foodName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
    };
  }
}

class RecipeNutritionalData {
  final String recipeId;
  final double caloriesPerServing;
  final double proteinPerServing;
  final double fatPerServing;
  final double carbsPerServing;
  final double fiberPerServing;
  final double calciumPerServing;
  final double ironPerServing;
  final double vitaminAPerServing;
  final double vitaminCPerServing;
  final double vitaminDPerServing;
  final double vitaminEPerServing;
  final double vitaminB1PerServing;
  final double potassiumPerServing;

  const RecipeNutritionalData({
    required this.recipeId,
    required this.caloriesPerServing,
    required this.proteinPerServing,
    required this.fatPerServing,
    required this.carbsPerServing,
    required this.fiberPerServing,
    required this.calciumPerServing,
    required this.ironPerServing,
    required this.vitaminAPerServing,
    required this.vitaminCPerServing,
    required this.vitaminDPerServing,
    required this.vitaminEPerServing,
    required this.vitaminB1PerServing,
    required this.potassiumPerServing,
  });

  factory RecipeNutritionalData.fromMap(Map<String, dynamic> map) {
    return RecipeNutritionalData(
      recipeId: map['recipeId'] ?? '',
      caloriesPerServing: (map['caloriesPerServing'] ?? 0).toDouble(),
      proteinPerServing: (map['proteinPerServing'] ?? 0).toDouble(),
      fatPerServing: (map['fatPerServing'] ?? 0).toDouble(),
      carbsPerServing: (map['carbsPerServing'] ?? 0).toDouble(),
      fiberPerServing: (map['fiberPerServing'] ?? 0).toDouble(),
      calciumPerServing: (map['calciumPerServing'] ?? 0).toDouble(),
      ironPerServing: (map['ironPerServing'] ?? 0).toDouble(),
      vitaminAPerServing: (map['vitaminAPerServing'] ?? 0).toDouble(),
      vitaminCPerServing: (map['vitaminCPerServing'] ?? 0).toDouble(),
      vitaminDPerServing: (map['vitaminDPerServing'] ?? 0).toDouble(),
      vitaminEPerServing: (map['vitaminEPerServing'] ?? 0).toDouble(),
      vitaminB1PerServing: (map['vitaminB1PerServing'] ?? 0).toDouble(),
      potassiumPerServing: (map['potassiumPerServing'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'caloriesPerServing': caloriesPerServing,
      'proteinPerServing': proteinPerServing,
      'fatPerServing': fatPerServing,
      'carbsPerServing': carbsPerServing,
      'fiberPerServing': fiberPerServing,
      'calciumPerServing': calciumPerServing,
      'ironPerServing': ironPerServing,
      'vitaminAPerServing': vitaminAPerServing,
      'vitaminCPerServing': vitaminCPerServing,
      'vitaminDPerServing': vitaminDPerServing,
      'vitaminEPerServing': vitaminEPerServing,
      'vitaminB1PerServing': vitaminB1PerServing,
      'potassiumPerServing': potassiumPerServing,
    };
  }
}
