import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../models/nutritional_data_model.dart';
import '../models/patient_model.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Food Database Methods
  Future<List<Food>> getAllFoods() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .limit(100) // Limit for performance
          .get();
      
      if (snapshot.docs.isEmpty) {
        // Return demo data if no data in Firestore
        return _getDemoFoods();
      }
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods: $e');
      // Return demo data on error
      return _getDemoFoods();
    }
  }

  // Demo data for when Firestore is empty
  List<Food> _getDemoFoods() {
    return [
      Food(
        foodId: 'DEMO001',
        foodNameEnglish: 'Basmati Rice',
        foodNameLocal: 'Basmati Chawal',
        baseItem: 'Rice',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Oryza sativa',
        description: 'Long grain aromatic rice',
        mealType: 'Lunch',
        servingSizeG: 100.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Moderate',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'DEMO002',
        foodNameEnglish: 'Ghee',
        foodNameLocal: 'Desi Ghee',
        baseItem: 'Butter',
        category: 'Dairy',
        cuisine: 'Indian',
        scientificName: 'Clarified Butter',
        description: 'Clarified butter with medicinal properties',
        mealType: 'All',
        servingSizeG: 15.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Dairy',
      ),
      Food(
        foodId: 'DEMO003',
        foodNameEnglish: 'Turmeric',
        foodNameLocal: 'Haldi',
        baseItem: 'Turmeric',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Curcuma longa',
        description: 'Golden spice with anti-inflammatory properties',
        mealType: 'All',
        servingSizeG: 5.0,
        rasa: 'Bitter',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'DEMO004',
        foodNameEnglish: 'Almonds',
        foodNameLocal: 'Badam',
        baseItem: 'Almond',
        category: 'Nuts',
        cuisine: 'Continental',
        scientificName: 'Prunus dulcis',
        description: 'Nutritious tree nuts',
        mealType: 'Snack',
        servingSizeG: 30.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Moderate',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Nuts',
      ),
      Food(
        foodId: 'DEMO005',
        foodNameEnglish: 'Spinach',
        foodNameLocal: 'Palak',
        baseItem: 'Spinach',
        category: 'Vegetable',
        cuisine: 'Indian',
        scientificName: 'Spinacia oleracea',
        description: 'Iron-rich leafy green vegetable',
        mealType: 'Lunch',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Unfavorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
    ];
  }

  Future<List<Food>> searchFoods(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('foodNameEnglish', isGreaterThanOrEqualTo: query)
          .where('foodNameEnglish', isLessThan: query + 'z')
          .limit(20)
          .get();
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error searching foods: $e');
      return [];
    }
  }

  Future<Food?> getFoodById(String foodId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('foods')
          .doc(foodId)
          .get();
      
      if (doc.exists) {
        return Food.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching food by ID: $e');
      return null;
    }
  }

  // Nutritional Data Methods
  Future<NutritionalData?> getNutritionalData(String foodId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('nutritional_data')
          .doc(foodId)
          .get();
      
      if (doc.exists) {
        return NutritionalData.fromMap(doc.data() as Map<String, dynamic>);
      }
      
      // Return demo nutritional data if not found in Firestore
      return _getDemoNutritionalData(foodId);
    } catch (e) {
      debugPrint('Error fetching nutritional data: $e');
      // Return demo data on error
      return _getDemoNutritionalData(foodId);
    }
  }

  // Demo nutritional data
  NutritionalData? _getDemoNutritionalData(String foodId) {
    switch (foodId) {
      case 'DEMO001': // Basmati Rice
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 130.0,
          proteinGPer100g: 2.7,
          fatGPer100g: 0.3,
          carbsGPer100g: 28.0,
          fiberGPer100g: 0.4,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.8,
          calciumMgPer100g: 28.0,
          potassiumMgPer100g: 35.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'DEMO002': // Ghee
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 900.0,
          proteinGPer100g: 0.0,
          fatGPer100g: 100.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 3069.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 2.3,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.0,
          calciumMgPer100g: 0.0,
          potassiumMgPer100g: 0.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'DEMO003': // Turmeric
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 354.0,
          proteinGPer100g: 7.8,
          fatGPer100g: 9.9,
          carbsGPer100g: 64.9,
          fiberGPer100g: 21.1,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 25.9,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 3.1,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 41.4,
          calciumMgPer100g: 183.0,
          potassiumMgPer100g: 2525.0,
          polyphenolsMgPer100g: 2000.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'DEMO004': // Almonds
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 579.0,
          proteinGPer100g: 21.2,
          fatGPer100g: 49.9,
          carbsGPer100g: 21.6,
          fiberGPer100g: 12.5,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 25.6,
          vitB1MgPer100g: 0.2,
          ironMgPer100g: 3.7,
          calciumMgPer100g: 264.0,
          potassiumMgPer100g: 705.0,
          polyphenolsMgPer100g: 100.0,
          phytosterolsMgPer100g: 120.0,
        );
      case 'DEMO005': // Spinach
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 23.0,
          proteinGPer100g: 2.9,
          fatGPer100g: 0.4,
          carbsGPer100g: 3.6,
          fiberGPer100g: 2.2,
          vitAIUPer100g: 469.0,
          vitCMgPer100g: 28.1,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 2.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 2.7,
          calciumMgPer100g: 99.0,
          potassiumMgPer100g: 558.0,
          polyphenolsMgPer100g: 50.0,
          phytosterolsMgPer100g: 0.0,
        );
      default:
        return null;
    }
  }

  // Patient Profile Methods
  Future<List<Patient>> getAllPatients() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('patients')
          .limit(50) // Limit for performance
          .get();
      
      return snapshot.docs
          .map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching patients: $e');
      return [];
    }
  }

  Future<Patient?> getPatientById(String patientId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('patients')
          .doc(patientId)
          .get();
      
      if (doc.exists) {
        return Patient.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching patient by ID: $e');
      return null;
    }
  }

  // Diet Recommendations based on Dosha
  Future<List<Food>> getFoodsByDosha(String dosha) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('doshaSuitability', arrayContains: dosha)
          .limit(20)
          .get();
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods by dosha: $e');
      return [];
    }
  }

  // Get foods by category
  Future<List<Food>> getFoodsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('category', isEqualTo: category)
          .limit(20)
          .get();
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods by category: $e');
      return [];
    }
  }

  // Get meal recommendations
  Future<List<Food>> getFoodsByMealType(String mealType) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('mealType', isEqualTo: mealType)
          .limit(20)
          .get();
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods by meal type: $e');
      return [];
    }
  }
}
