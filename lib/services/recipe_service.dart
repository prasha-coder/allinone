import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../models/nutritional_data_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _recipesCollection = 'recipes';

  // Create a new recipe
  Future<String> createRecipe(Recipe recipe) async {
    try {
      final docRef = await _firestore.collection(_recipesCollection).add(recipe.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create recipe: $e');
    }
  }

  // Get recipe by ID
  Future<Recipe?> getRecipe(String recipeId) async {
    try {
      final doc = await _firestore.collection(_recipesCollection).doc(recipeId).get();
      if (doc.exists) {
        return Recipe.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      // Return demo recipe if Firestore fails
      return _getDemoRecipes().firstWhere(
        (recipe) => recipe.recipeId == recipeId,
        orElse: () => _getDemoRecipes().first,
      );
    }
  }

  // Get all recipes with pagination
  Future<List<Recipe>> getAllRecipes({int limit = 50, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore.collection(_recipesCollection).orderBy('recipeName');
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      final querySnapshot = await query.limit(limit).get();
      return querySnapshot.docs.map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return demo recipes if Firestore fails
      return _getDemoRecipes();
    }
  }

  // Get recipes by cuisine
  Future<List<Recipe>> getRecipesByCuisine(String cuisine) async {
    try {
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('cuisine', isEqualTo: cuisine)
          .get();
      
      return querySnapshot.docs.map((doc) => Recipe.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo recipes if Firestore fails
      final demoRecipes = _getDemoRecipes();
      return demoRecipes.where((recipe) => 
        recipe.cuisine.toLowerCase().contains(cuisine.toLowerCase())
      ).toList();
    }
  }

  // Get recipes by meal type
  Future<List<Recipe>> getRecipesByMealType(String mealType) async {
    try {
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('mealType', isEqualTo: mealType)
          .get();
      
      return querySnapshot.docs.map((doc) => Recipe.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo recipes if Firestore fails
      final demoRecipes = _getDemoRecipes();
      return demoRecipes.where((recipe) => 
        recipe.mealType.toLowerCase().contains(mealType.toLowerCase())
      ).toList();
    }
  }

  // Get recipes by dosha suitability
  Future<List<Recipe>> getRecipesByDosha(String doshaType) async {
    try {
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('doshaSuitability', isEqualTo: doshaType)
          .get();
      
      return querySnapshot.docs.map((doc) => Recipe.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo recipes if Firestore fails
      final demoRecipes = _getDemoRecipes();
      return demoRecipes.where((recipe) => 
        recipe.doshaSuitability.toLowerCase().contains(doshaType.toLowerCase())
      ).toList();
    }
  }

  // Search recipes
  Future<List<Recipe>> searchRecipes(String searchTerm) async {
    try {
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('recipeName', isGreaterThanOrEqualTo: searchTerm)
          .where('recipeName', isLessThan: '${searchTerm}z')
          .get();
      
      return querySnapshot.docs.map((doc) => Recipe.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo recipes if Firestore fails
      final demoRecipes = _getDemoRecipes();
      return demoRecipes.where((recipe) => 
        recipe.recipeName.toLowerCase().contains(searchTerm.toLowerCase()) ||
        recipe.recipeNameLocal.toLowerCase().contains(searchTerm.toLowerCase()) ||
        recipe.description.toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
    }
  }

  // Calculate nutritional data for a recipe
  Future<RecipeNutritionalData> calculateRecipeNutrition(Recipe recipe) async {
    try {
      double totalCalories = 0;
      double totalProtein = 0;
      double totalFat = 0;
      double totalCarbs = 0;
      double totalFiber = 0;
      double totalCalcium = 0;
      double totalIron = 0;
      double totalVitaminA = 0;
      double totalVitaminC = 0;
      double totalVitaminD = 0;
      double totalVitaminE = 0;
      double totalVitaminB1 = 0;
      double totalPotassium = 0;

      for (final ingredient in recipe.ingredients) {
        // Get nutritional data for each ingredient
        final nutritionalData = await _getNutritionalDataForFood(ingredient.foodId);
        if (nutritionalData != null) {
          // Calculate quantity in grams
          final quantityInGrams = _convertToGrams(ingredient.quantity, ingredient.unit);
          
          // Calculate nutritional values for this ingredient
          final multiplier = quantityInGrams / 100.0; // Per 100g basis
          
          totalCalories += nutritionalData.caloriesPer100g * multiplier;
          totalProtein += nutritionalData.proteinGPer100g * multiplier;
          totalFat += nutritionalData.fatGPer100g * multiplier;
          totalCarbs += nutritionalData.carbsGPer100g * multiplier;
          totalFiber += nutritionalData.fiberGPer100g * multiplier;
          totalCalcium += nutritionalData.calciumMgPer100g * multiplier;
          totalIron += nutritionalData.ironMgPer100g * multiplier;
          totalVitaminA += nutritionalData.vitAIUPer100g * multiplier;
          totalVitaminC += nutritionalData.vitCMgPer100g * multiplier;
          totalVitaminD += nutritionalData.vitDUgPer100g * multiplier;
          totalVitaminE += nutritionalData.vitEMgPer100g * multiplier;
          totalVitaminB1 += nutritionalData.vitB1MgPer100g * multiplier;
          totalPotassium += nutritionalData.potassiumMgPer100g * multiplier;
        }
      }

      // Calculate per serving values
      final servings = recipe.servings;
      return RecipeNutritionalData(
        recipeId: recipe.recipeId,
        caloriesPerServing: totalCalories / servings,
        proteinPerServing: totalProtein / servings,
        fatPerServing: totalFat / servings,
        carbsPerServing: totalCarbs / servings,
        fiberPerServing: totalFiber / servings,
        calciumPerServing: totalCalcium / servings,
        ironPerServing: totalIron / servings,
        vitaminAPerServing: totalVitaminA / servings,
        vitaminCPerServing: totalVitaminC / servings,
        vitaminDPerServing: totalVitaminD / servings,
        vitaminEPerServing: totalVitaminE / servings,
        vitaminB1PerServing: totalVitaminB1 / servings,
        potassiumPerServing: totalPotassium / servings,
      );
    } catch (e) {
      throw Exception('Failed to calculate recipe nutrition: $e');
    }
  }

  // Get nutritional data for a food item
  Future<NutritionalData?> _getNutritionalDataForFood(String foodId) async {
    try {
      final doc = await _firestore.collection('nutritional_data').doc(foodId).get();
      if (doc.exists) {
        return NutritionalData.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      // Return demo nutritional data if Firestore fails
      return _getDemoNutritionalData(foodId);
    }
  }

  // Convert different units to grams
  double _convertToGrams(double quantity, String unit) {
    switch (unit.toLowerCase()) {
      case 'g':
      case 'gram':
      case 'grams':
        return quantity;
      case 'kg':
      case 'kilogram':
      case 'kilograms':
        return quantity * 1000;
      case 'ml':
      case 'milliliter':
      case 'milliliters':
        return quantity; // Assuming 1ml = 1g for most liquids
      case 'l':
      case 'liter':
      case 'liters':
        return quantity * 1000;
      case 'cup':
      case 'cups':
        return quantity * 240; // 1 cup = 240ml
      case 'tbsp':
      case 'tablespoon':
      case 'tablespoons':
        return quantity * 15; // 1 tbsp = 15ml
      case 'tsp':
      case 'teaspoon':
      case 'teaspoons':
        return quantity * 5; // 1 tsp = 5ml
      case 'piece':
      case 'pieces':
        return quantity * 50; // Average piece weight
      case 'slice':
      case 'slices':
        return quantity * 25; // Average slice weight
      default:
        return quantity; // Default to grams
    }
  }

  // Demo recipes for offline functionality
  List<Recipe> _getDemoRecipes() {
    return [
      Recipe(
        recipeId: 'REC001',
        recipeName: 'Dal Tadka',
        recipeNameLocal: 'दाल तड़का',
        cuisine: 'Indian',
        category: 'Main Course',
        mealType: 'Lunch',
        description: 'Traditional Indian lentil curry with aromatic tempering',
        ingredients: [
          RecipeIngredient(foodId: 'IND001', foodName: 'Toor Dal', quantity: 1, unit: 'cup', notes: 'Washed and soaked'),
          RecipeIngredient(foodId: 'IND002', foodName: 'Onion', quantity: 1, unit: 'medium', notes: 'Finely chopped'),
          RecipeIngredient(foodId: 'IND003', foodName: 'Tomato', quantity: 2, unit: 'medium', notes: 'Pureed'),
          RecipeIngredient(foodId: 'IND004', foodName: 'Ginger', quantity: 1, unit: 'inch', notes: 'Grated'),
          RecipeIngredient(foodId: 'IND005', foodName: 'Garlic', quantity: 4, unit: 'cloves', notes: 'Minced'),
          RecipeIngredient(foodId: 'IND006', foodName: 'Turmeric', quantity: 0.5, unit: 'tsp', notes: 'Powder'),
          RecipeIngredient(foodId: 'IND007', foodName: 'Cumin', quantity: 1, unit: 'tsp', notes: 'Seeds'),
          RecipeIngredient(foodId: 'IND008', foodName: 'Coriander', quantity: 2, unit: 'tbsp', notes: 'Fresh leaves'),
        ],
        instructions: [
          'Pressure cook dal with turmeric and salt until soft',
          'Heat oil in a pan and add cumin seeds',
          'Add onions and sauté until golden brown',
          'Add ginger-garlic paste and cook for 2 minutes',
          'Add tomato puree and cook until oil separates',
          'Add cooked dal and mix well',
          'Simmer for 10 minutes and garnish with coriander',
        ],
        prepTimeMinutes: 15,
        cookTimeMinutes: 30,
        servings: 4,
        difficulty: 'Easy',
        tags: ['Vegetarian', 'Protein Rich', 'Comfort Food'],
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Moderate',
        allergenWarnings: 'None',
        imageUrl: '',
      ),
      Recipe(
        recipeId: 'REC002',
        recipeName: 'Palak Paneer',
        recipeNameLocal: 'पालक पनीर',
        cuisine: 'Indian',
        category: 'Main Course',
        mealType: 'Lunch',
        description: 'Cottage cheese in creamy spinach gravy',
        ingredients: [
          RecipeIngredient(foodId: 'IND009', foodName: 'Spinach', quantity: 500, unit: 'g', notes: 'Fresh leaves'),
          RecipeIngredient(foodId: 'IND010', foodName: 'Paneer', quantity: 200, unit: 'g', notes: 'Cubed'),
          RecipeIngredient(foodId: 'IND002', foodName: 'Onion', quantity: 1, unit: 'medium', notes: 'Chopped'),
          RecipeIngredient(foodId: 'IND003', foodName: 'Tomato', quantity: 2, unit: 'medium', notes: 'Chopped'),
          RecipeIngredient(foodId: 'IND004', foodName: 'Ginger', quantity: 1, unit: 'inch', notes: 'Grated'),
          RecipeIngredient(foodId: 'IND005', foodName: 'Garlic', quantity: 3, unit: 'cloves', notes: 'Minced'),
          RecipeIngredient(foodId: 'IND006', foodName: 'Turmeric', quantity: 0.5, unit: 'tsp', notes: 'Powder'),
          RecipeIngredient(foodId: 'IND011', foodName: 'Cumin', quantity: 1, unit: 'tsp', notes: 'Powder'),
        ],
        instructions: [
          'Blanch spinach leaves and make puree',
          'Heat oil and sauté onions until golden',
          'Add ginger-garlic and cook for 2 minutes',
          'Add tomatoes and spices, cook until soft',
          'Add spinach puree and simmer for 10 minutes',
          'Add paneer cubes and cook for 5 minutes',
          'Garnish with cream and serve hot',
        ],
        prepTimeMinutes: 20,
        cookTimeMinutes: 25,
        servings: 4,
        difficulty: 'Medium',
        tags: ['Vegetarian', 'Iron Rich', 'Healthy'],
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Moderate',
        allergenWarnings: 'Dairy',
        imageUrl: '',
      ),
      Recipe(
        recipeId: 'REC003',
        recipeName: 'Chicken Curry',
        recipeNameLocal: 'चिकन करी',
        cuisine: 'Indian',
        category: 'Main Course',
        mealType: 'Dinner',
        description: 'Spicy Indian chicken curry with aromatic spices',
        ingredients: [
          RecipeIngredient(foodId: 'IND011', foodName: 'Chicken', quantity: 500, unit: 'g', notes: 'Cut into pieces'),
          RecipeIngredient(foodId: 'IND002', foodName: 'Onion', quantity: 2, unit: 'medium', notes: 'Sliced'),
          RecipeIngredient(foodId: 'IND003', foodName: 'Tomato', quantity: 3, unit: 'medium', notes: 'Pureed'),
          RecipeIngredient(foodId: 'IND004', foodName: 'Ginger', quantity: 1, unit: 'inch', notes: 'Grated'),
          RecipeIngredient(foodId: 'IND005', foodName: 'Garlic', quantity: 6, unit: 'cloves', notes: 'Minced'),
          RecipeIngredient(foodId: 'IND006', foodName: 'Turmeric', quantity: 1, unit: 'tsp', notes: 'Powder'),
          RecipeIngredient(foodId: 'IND007', foodName: 'Cumin', quantity: 1, unit: 'tsp', notes: 'Powder'),
          RecipeIngredient(foodId: 'IND008', foodName: 'Coriander', quantity: 1, unit: 'tsp', notes: 'Powder'),
        ],
        instructions: [
          'Marinate chicken with turmeric and salt',
          'Heat oil and sauté onions until golden brown',
          'Add ginger-garlic paste and cook for 2 minutes',
          'Add tomato puree and cook until oil separates',
          'Add chicken and cook until sealed',
          'Add water and simmer for 20 minutes',
          'Garnish with fresh coriander and serve',
        ],
        prepTimeMinutes: 20,
        cookTimeMinutes: 35,
        servings: 4,
        difficulty: 'Medium',
        tags: ['Non-Vegetarian', 'Protein Rich', 'Spicy'],
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
        imageUrl: '',
      ),
    ];
  }

  // Demo nutritional data for recipe calculation
  NutritionalData? _getDemoNutritionalData(String foodId) {
    // This would typically fetch from the nutrition service
    // For now, return basic nutritional data
    return NutritionalData(
      foodId: foodId,
      caloriesPer100g: 100.0,
      proteinGPer100g: 5.0,
      fatGPer100g: 2.0,
      carbsGPer100g: 15.0,
      fiberGPer100g: 3.0,
      vitAIUPer100g: 100.0,
      vitCMgPer100g: 20.0,
      vitDUgPer100g: 5.0,
      vitEMgPer100g: 2.0,
      vitB1MgPer100g: 0.1,
      ironMgPer100g: 2.0,
      calciumMgPer100g: 50.0,
      potassiumMgPer100g: 200.0,
      polyphenolsMgPer100g: 10.0,
      phytosterolsMgPer100g: 5.0,
    );
  }
}
