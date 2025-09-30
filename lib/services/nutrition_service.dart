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
          .limit(500) // Increased limit for comprehensive data
          .get();
      
      if (snapshot.docs.isEmpty) {
        // Return comprehensive demo data if no data in Firestore
        return _getComprehensiveDemoFoods();
      }
      
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods: $e');
      // Return comprehensive demo data on error
      return _getComprehensiveDemoFoods();
    }
  }

  // Comprehensive demo data for SIH problem statement
  List<Food> _getComprehensiveDemoFoods() {
    return [
      // Indian Grains and Cereals
      Food(
        foodId: 'IND001',
        foodNameEnglish: 'Basmati Rice',
        foodNameLocal: 'Basmati Chawal',
        baseItem: 'Rice',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Oryza sativa',
        description: 'Long grain aromatic rice with low glycemic index',
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
        foodId: 'IND002',
        foodNameEnglish: 'Ghee',
        foodNameLocal: 'Desi Ghee',
        baseItem: 'Butter',
        category: 'Dairy',
        cuisine: 'Indian',
        scientificName: 'Clarified Butter',
        description: 'Clarified butter with medicinal properties and high smoke point',
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
        foodId: 'IND003',
        foodNameEnglish: 'Turmeric',
        foodNameLocal: 'Haldi',
        baseItem: 'Turmeric',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Curcuma longa',
        description: 'Golden spice with anti-inflammatory and antioxidant properties',
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
        foodId: 'IND004',
        foodNameEnglish: 'Almonds',
        foodNameLocal: 'Badam',
        baseItem: 'Almond',
        category: 'Nuts',
        cuisine: 'Continental',
        scientificName: 'Prunus dulcis',
        description: 'Nutritious tree nuts rich in vitamin E and healthy fats',
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
        foodId: 'IND005',
        foodNameEnglish: 'Spinach',
        foodNameLocal: 'Palak',
        baseItem: 'Spinach',
        category: 'Vegetable',
        cuisine: 'Indian',
        scientificName: 'Spinacia oleracea',
        description: 'Iron-rich leafy green vegetable with high folate content',
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
      // Add more comprehensive foods...
      Food(
        foodId: 'IND006',
        foodNameEnglish: 'Mango',
        foodNameLocal: 'Aam',
        baseItem: 'Mango',
        category: 'Fruit',
        cuisine: 'Indian',
        scientificName: 'Mangifera indica',
        description: 'King of fruits rich in vitamin C and beta-carotene',
        mealType: 'Snack',
        servingSizeG: 150.0,
        rasa: 'Sweet',
        virya: 'Heating',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Moderate',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND007',
        foodNameEnglish: 'Coconut',
        foodNameLocal: 'Nariyal',
        baseItem: 'Coconut',
        category: 'Fruit',
        cuisine: 'Indian',
        scientificName: 'Cocos nucifera',
        description: 'Multi-purpose tropical fruit with medium-chain triglycerides',
        mealType: 'All',
        servingSizeG: 50.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND008',
        foodNameEnglish: 'Ginger',
        foodNameLocal: 'Adrak',
        baseItem: 'Ginger',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Zingiber officinale',
        description: 'Heating spice with digestive and anti-inflammatory properties',
        mealType: 'All',
        servingSizeG: 10.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND009',
        foodNameEnglish: 'Cumin Seeds',
        foodNameLocal: 'Jeera',
        baseItem: 'Cumin',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Cuminum cyminum',
        description: 'Aromatic digestive spice with iron and antioxidant properties',
        mealType: 'All',
        servingSizeG: 5.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND010',
        foodNameEnglish: 'Coriander Leaves',
        foodNameLocal: 'Dhaniya Patta',
        baseItem: 'Coriander',
        category: 'Vegetable',
        cuisine: 'Indian',
        scientificName: 'Coriandrum sativum',
        description: 'Aromatic herb with cooling properties and vitamin K',
        mealType: 'All',
        servingSizeG: 20.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      // Meat and Seafood Items
      Food(
        foodId: 'IND011',
        foodNameEnglish: 'Chicken',
        foodNameLocal: 'Murgi',
        baseItem: 'Chicken',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Gallus gallus',
        description: 'Lean poultry protein rich in essential amino acids',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND012',
        foodNameEnglish: 'Fish',
        foodNameLocal: 'Machli',
        baseItem: 'Fish',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Various species',
        description: 'Omega-3 rich protein source with heart health benefits',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'Fish',
      ),
      Food(
        foodId: 'IND013',
        foodNameEnglish: 'Eggs',
        foodNameLocal: 'Ande',
        baseItem: 'Eggs',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Gallus gallus',
        description: 'Complete protein source with all essential amino acids',
        mealType: 'All',
        servingSizeG: 50.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Moderate',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'Eggs',
      ),
      Food(
        foodId: 'IND014',
        foodNameEnglish: 'Mutton',
        foodNameLocal: 'Bakri',
        baseItem: 'Mutton',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Ovis aries',
        description: 'Red meat protein rich in iron and B vitamins',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND015',
        foodNameEnglish: 'Prawns',
        foodNameLocal: 'Jhinga',
        baseItem: 'Prawns',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Penaeus monodon',
        description: 'Shellfish protein with low fat content',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'Shellfish',
      ),
      Food(
        foodId: 'IND016',
        foodNameEnglish: 'Crab',
        foodNameLocal: 'Kekda',
        baseItem: 'Crab',
        category: 'Meat/Seafood',
        cuisine: 'Indian',
        scientificName: 'Callinectes sapidus',
        description: 'Shellfish protein rich in zinc and selenium',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'Shellfish',
      ),
      Food(
        foodId: 'IND017',
        foodNameEnglish: 'Salmon',
        foodNameLocal: 'Salmon',
        baseItem: 'Salmon',
        category: 'Meat/Seafood',
        cuisine: 'International',
        scientificName: 'Salmo salar',
        description: 'Fatty fish rich in omega-3 fatty acids',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'Fish',
      ),
      Food(
        foodId: 'IND018',
        foodNameEnglish: 'Tuna',
        foodNameLocal: 'Tuna',
        baseItem: 'Tuna',
        category: 'Meat/Seafood',
        cuisine: 'International',
        scientificName: 'Thunnus thynnus',
        description: 'Lean fish protein with high selenium content',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'Fish',
      ),
      Food(
        foodId: 'IND019',
        foodNameEnglish: 'Beef',
        foodNameLocal: 'Gai',
        baseItem: 'Beef',
        category: 'Meat/Seafood',
        cuisine: 'International',
        scientificName: 'Bos taurus',
        description: 'Red meat protein rich in iron and zinc',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND020',
        foodNameEnglish: 'Pork',
        foodNameLocal: 'Suar',
        baseItem: 'Pork',
        category: 'Meat/Seafood',
        cuisine: 'International',
        scientificName: 'Sus scrofa',
        description: 'Red meat protein with B vitamins',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      // More Dairy Items
      Food(
        foodId: 'IND021',
        foodNameEnglish: 'Paneer',
        foodNameLocal: 'Paneer',
        baseItem: 'Paneer',
        category: 'Dairy',
        cuisine: 'Indian',
        scientificName: 'Milk curd',
        description: 'Fresh cottage cheese rich in protein and calcium',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Dairy',
      ),
      Food(
        foodId: 'IND022',
        foodNameEnglish: 'Curd',
        foodNameLocal: 'Dahi',
        baseItem: 'Curd',
        category: 'Dairy',
        cuisine: 'Indian',
        scientificName: 'Fermented milk',
        description: 'Probiotic dairy product with digestive benefits',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Sour',
        virya: 'Cooling',
        vipaka: 'Sour',
        guna: 'Heavy',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Dairy',
      ),
      Food(
        foodId: 'IND023',
        foodNameEnglish: 'Buttermilk',
        foodNameLocal: 'Chaas',
        baseItem: 'Buttermilk',
        category: 'Dairy',
        cuisine: 'Indian',
        scientificName: 'Fermented milk',
        description: 'Digestive dairy drink with cooling properties',
        mealType: 'All',
        servingSizeG: 200.0,
        rasa: 'Sour',
        virya: 'Cooling',
        vipaka: 'Sour',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'Dairy',
      ),
      Food(
        foodId: 'IND024',
        foodNameEnglish: 'Cheese',
        foodNameLocal: 'Cheese',
        baseItem: 'Cheese',
        category: 'Dairy',
        cuisine: 'International',
        scientificName: 'Milk curd',
        description: 'Aged dairy product rich in protein and calcium',
        mealType: 'All',
        servingSizeG: 50.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Dairy',
      ),
      Food(
        foodId: 'IND025',
        foodNameEnglish: 'Ice Cream',
        foodNameLocal: 'Ice Cream',
        baseItem: 'Ice Cream',
        category: 'Dairy',
        cuisine: 'International',
        scientificName: 'Frozen dairy dessert',
        description: 'Frozen dairy dessert with cooling properties',
        mealType: 'Snack',
        servingSizeG: 100.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'Dairy',
      ),
      // More Fruit Items
      Food(
        foodId: 'IND026',
        foodNameEnglish: 'Papaya',
        foodNameLocal: 'Papita',
        baseItem: 'Papaya',
        category: 'Fruit',
        cuisine: 'Indian',
        scientificName: 'Carica papaya',
        description: 'Tropical fruit rich in vitamin C and digestive enzymes',
        mealType: 'Snack',
        servingSizeG: 150.0,
        rasa: 'Sweet',
        virya: 'Heating',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND027',
        foodNameEnglish: 'Guava',
        foodNameLocal: 'Amrood',
        baseItem: 'Guava',
        category: 'Fruit',
        cuisine: 'Indian',
        scientificName: 'Psidium guajava',
        description: 'Vitamin C rich fruit with high fiber content',
        mealType: 'Snack',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND028',
        foodNameEnglish: 'Watermelon',
        foodNameLocal: 'Tarbooz',
        baseItem: 'Watermelon',
        category: 'Fruit',
        cuisine: 'Indian',
        scientificName: 'Citrullus lanatus',
        description: 'Hydrating fruit with high water content',
        mealType: 'Snack',
        servingSizeG: 200.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND029',
        foodNameEnglish: 'Strawberry',
        foodNameLocal: 'Strawberry',
        baseItem: 'Strawberry',
        category: 'Fruit',
        cuisine: 'International',
        scientificName: 'Fragaria ananassa',
        description: 'Antioxidant-rich berry with vitamin C',
        mealType: 'Snack',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND030',
        foodNameEnglish: 'Kiwi',
        foodNameLocal: 'Kiwi',
        baseItem: 'Kiwi',
        category: 'Fruit',
        cuisine: 'International',
        scientificName: 'Actinidia deliciosa',
        description: 'Vitamin C rich fruit with digestive enzymes',
        mealType: 'Snack',
        servingSizeG: 100.0,
        rasa: 'Sour',
        virya: 'Cooling',
        vipaka: 'Sour',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      // More Vegetable Items
      Food(
        foodId: 'IND031',
        foodNameEnglish: 'Broccoli',
        foodNameLocal: 'Broccoli',
        baseItem: 'Broccoli',
        category: 'Vegetable',
        cuisine: 'International',
        scientificName: 'Brassica oleracea',
        description: 'Cruciferous vegetable rich in vitamin C and fiber',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND032',
        foodNameEnglish: 'Bell Pepper',
        foodNameLocal: 'Shimla Mirch',
        baseItem: 'Bell Pepper',
        category: 'Vegetable',
        cuisine: 'Indian',
        scientificName: 'Capsicum annuum',
        description: 'Colorful vegetable rich in vitamin C',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND033',
        foodNameEnglish: 'Zucchini',
        foodNameLocal: 'Zucchini',
        baseItem: 'Zucchini',
        category: 'Vegetable',
        cuisine: 'International',
        scientificName: 'Cucurbita pepo',
        description: 'Summer squash with high water content',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND034',
        foodNameEnglish: 'Sweet Potato',
        foodNameLocal: 'Shakarkandi',
        baseItem: 'Sweet Potato',
        category: 'Vegetable',
        cuisine: 'Indian',
        scientificName: 'Ipomoea batatas',
        description: 'Nutritious root vegetable rich in beta-carotene',
        mealType: 'All',
        servingSizeG: 150.0,
        rasa: 'Sweet',
        virya: 'Heating',
        vipaka: 'Sweet',
        guna: 'Heavy',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND035',
        foodNameEnglish: 'Asparagus',
        foodNameLocal: 'Asparagus',
        baseItem: 'Asparagus',
        category: 'Vegetable',
        cuisine: 'International',
        scientificName: 'Asparagus officinalis',
        description: 'Spring vegetable rich in folate and fiber',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      // More Grain Items
      Food(
        foodId: 'IND036',
        foodNameEnglish: 'Wheat',
        foodNameLocal: 'Gehu',
        baseItem: 'Wheat',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Triticum aestivum',
        description: 'Whole grain rich in fiber and B vitamins',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Heavy',
        digestibility: 'Difficult',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Unfavorable',
        allergenWarnings: 'Gluten',
      ),
      Food(
        foodId: 'IND037',
        foodNameEnglish: 'Barley',
        foodNameLocal: 'Jau',
        baseItem: 'Barley',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Hordeum vulgare',
        description: 'Ancient grain with high fiber content',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'Gluten',
      ),
      Food(
        foodId: 'IND038',
        foodNameEnglish: 'Millet',
        foodNameLocal: 'Bajra',
        baseItem: 'Millet',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Pennisetum glaucum',
        description: 'Gluten-free grain rich in iron and magnesium',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND039',
        foodNameEnglish: 'Quinoa',
        foodNameLocal: 'Quinoa',
        baseItem: 'Quinoa',
        category: 'Grain',
        cuisine: 'International',
        scientificName: 'Chenopodium quinoa',
        description: 'Complete protein grain with all essential amino acids',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Cooling',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND040',
        foodNameEnglish: 'Buckwheat',
        foodNameLocal: 'Kuttu',
        baseItem: 'Buckwheat',
        category: 'Grain',
        cuisine: 'Indian',
        scientificName: 'Fagopyrum esculentum',
        description: 'Gluten-free pseudo-grain rich in protein',
        mealType: 'All',
        servingSizeG: 100.0,
        rasa: 'Astringent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      // More Spice Items
      Food(
        foodId: 'IND041',
        foodNameEnglish: 'Cloves',
        foodNameLocal: 'Laung',
        baseItem: 'Cloves',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Syzygium aromaticum',
        description: 'Aromatic spice with antimicrobial properties',
        mealType: 'All',
        servingSizeG: 2.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND042',
        foodNameEnglish: 'Fenugreek',
        foodNameLocal: 'Methi',
        baseItem: 'Fenugreek',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Trigonella foenum-graecum',
        description: 'Bitter spice with blood sugar benefits',
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
        foodId: 'IND043',
        foodNameEnglish: 'Fennel Seeds',
        foodNameLocal: 'Saunf',
        baseItem: 'Fennel',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Foeniculum vulgare',
        description: 'Digestive spice with cooling properties',
        mealType: 'All',
        servingSizeG: 5.0,
        rasa: 'Sweet',
        virya: 'Cooling',
        vipaka: 'Sweet',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND044',
        foodNameEnglish: 'Mustard Seeds',
        foodNameLocal: 'Rai',
        baseItem: 'Mustard',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Brassica nigra',
        description: 'Pungent spice with digestive benefits',
        mealType: 'All',
        servingSizeG: 5.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
      Food(
        foodId: 'IND045',
        foodNameEnglish: 'Asafoetida',
        foodNameLocal: 'Hing',
        baseItem: 'Asafoetida',
        category: 'Spice',
        cuisine: 'Indian',
        scientificName: 'Ferula assa-foetida',
        description: 'Digestive spice with anti-flatulent properties',
        mealType: 'All',
        servingSizeG: 1.0,
        rasa: 'Pungent',
        virya: 'Heating',
        vipaka: 'Pungent',
        guna: 'Light',
        digestibility: 'Easy',
        doshaSuitability: 'Vata:Favorable;Pitta:Unfavorable;Kapha:Favorable',
        allergenWarnings: 'None',
      ),
    ];
  }


  Future<List<Food>> searchFoods(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('foodNameEnglish', isGreaterThanOrEqualTo: query)
          .where('foodNameEnglish', isLessThan: '${query}z')
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
      // Meat and Seafood Nutritional Data
      case 'IND011': // Chicken
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 165.0,
          proteinGPer100g: 31.0,
          fatGPer100g: 3.6,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.3,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.9,
          calciumMgPer100g: 15.0,
          potassiumMgPer100g: 256.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND012': // Fish
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 206.0,
          proteinGPer100g: 22.0,
          fatGPer100g: 12.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.8,
          calciumMgPer100g: 12.0,
          potassiumMgPer100g: 358.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND013': // Eggs
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 155.0,
          proteinGPer100g: 13.0,
          fatGPer100g: 11.0,
          carbsGPer100g: 1.1,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 160.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 1.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 1.2,
          calciumMgPer100g: 56.0,
          potassiumMgPer100g: 138.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND014': // Mutton
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 294.0,
          proteinGPer100g: 25.0,
          fatGPer100g: 21.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 2.0,
          calciumMgPer100g: 17.0,
          potassiumMgPer100g: 315.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND015': // Prawns
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 106.0,
          proteinGPer100g: 20.1,
          fatGPer100g: 1.7,
          carbsGPer100g: 0.9,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 1.5,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.5,
          calciumMgPer100g: 91.0,
          potassiumMgPer100g: 259.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND016': // Crab
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 97.0,
          proteinGPer100g: 20.1,
          fatGPer100g: 1.5,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.7,
          calciumMgPer100g: 89.0,
          potassiumMgPer100g: 329.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND017': // Salmon
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 208.0,
          proteinGPer100g: 25.4,
          fatGPer100g: 12.4,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.2,
          ironMgPer100g: 0.8,
          calciumMgPer100g: 12.0,
          potassiumMgPer100g: 363.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND018': // Tuna
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 144.0,
          proteinGPer100g: 30.0,
          fatGPer100g: 1.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.2,
          ironMgPer100g: 1.0,
          calciumMgPer100g: 4.0,
          potassiumMgPer100g: 444.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND019': // Beef
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 250.0,
          proteinGPer100g: 26.0,
          fatGPer100g: 15.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 2.6,
          calciumMgPer100g: 18.0,
          potassiumMgPer100g: 315.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND020': // Pork
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 263.0,
          proteinGPer100g: 26.0,
          fatGPer100g: 16.0,
          carbsGPer100g: 0.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.8,
          calciumMgPer100g: 15.0,
          potassiumMgPer100g: 315.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      // Dairy Items Nutritional Data
      case 'IND021': // Paneer
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 265.0,
          proteinGPer100g: 18.3,
          fatGPer100g: 20.8,
          carbsGPer100g: 1.2,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.1,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.2,
          calciumMgPer100g: 208.0,
          potassiumMgPer100g: 76.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND022': // Curd
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 59.0,
          proteinGPer100g: 10.3,
          fatGPer100g: 0.4,
          carbsGPer100g: 3.6,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 27.0,
          vitCMgPer100g: 0.5,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.1,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.1,
          calciumMgPer100g: 110.0,
          potassiumMgPer100g: 141.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND023': // Buttermilk
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 40.0,
          proteinGPer100g: 3.3,
          fatGPer100g: 0.9,
          carbsGPer100g: 4.7,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.0,
          calciumMgPer100g: 116.0,
          potassiumMgPer100g: 151.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND024': // Cheese
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 350.0,
          proteinGPer100g: 25.0,
          fatGPer100g: 27.0,
          carbsGPer100g: 1.0,
          fiberGPer100g: 0.0,
          vitAIUPer100g: 1000.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.5,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.3,
          calciumMgPer100g: 700.0,
          potassiumMgPer100g: 100.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND025': // Ice Cream
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 207.0,
          proteinGPer100g: 3.5,
          fatGPer100g: 11.0,
          carbsGPer100g: 23.6,
          fiberGPer100g: 0.7,
          vitAIUPer100g: 421.0,
          vitCMgPer100g: 0.6,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.3,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.1,
          calciumMgPer100g: 128.0,
          potassiumMgPer100g: 199.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      // Fruit Items Nutritional Data
      case 'IND026': // Papaya
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 43.0,
          proteinGPer100g: 0.5,
          fatGPer100g: 0.3,
          carbsGPer100g: 11.0,
          fiberGPer100g: 1.7,
          vitAIUPer100g: 950.0,
          vitCMgPer100g: 60.9,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.3,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.3,
          calciumMgPer100g: 20.0,
          potassiumMgPer100g: 182.0,
          polyphenolsMgPer100g: 50.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND027': // Guava
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 68.0,
          proteinGPer100g: 2.6,
          fatGPer100g: 0.9,
          carbsGPer100g: 14.3,
          fiberGPer100g: 5.4,
          vitAIUPer100g: 624.0,
          vitCMgPer100g: 228.3,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.7,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.3,
          calciumMgPer100g: 18.0,
          potassiumMgPer100g: 417.0,
          polyphenolsMgPer100g: 100.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND028': // Watermelon
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 30.0,
          proteinGPer100g: 0.6,
          fatGPer100g: 0.2,
          carbsGPer100g: 7.6,
          fiberGPer100g: 0.4,
          vitAIUPer100g: 569.0,
          vitCMgPer100g: 8.1,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.1,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.2,
          calciumMgPer100g: 7.0,
          potassiumMgPer100g: 112.0,
          polyphenolsMgPer100g: 25.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND029': // Strawberry
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 32.0,
          proteinGPer100g: 0.7,
          fatGPer100g: 0.3,
          carbsGPer100g: 7.7,
          fiberGPer100g: 2.0,
          vitAIUPer100g: 12.0,
          vitCMgPer100g: 58.8,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.3,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.4,
          calciumMgPer100g: 16.0,
          potassiumMgPer100g: 153.0,
          polyphenolsMgPer100g: 200.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND030': // Kiwi
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 61.0,
          proteinGPer100g: 1.1,
          fatGPer100g: 0.5,
          carbsGPer100g: 14.7,
          fiberGPer100g: 3.0,
          vitAIUPer100g: 87.0,
          vitCMgPer100g: 92.7,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 1.5,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.3,
          calciumMgPer100g: 34.0,
          potassiumMgPer100g: 312.0,
          polyphenolsMgPer100g: 150.0,
          phytosterolsMgPer100g: 0.0,
        );
      // Vegetable Items Nutritional Data
      case 'IND031': // Broccoli
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 34.0,
          proteinGPer100g: 2.8,
          fatGPer100g: 0.4,
          carbsGPer100g: 6.6,
          fiberGPer100g: 2.6,
          vitAIUPer100g: 623.0,
          vitCMgPer100g: 89.2,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.8,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.7,
          calciumMgPer100g: 47.0,
          potassiumMgPer100g: 316.0,
          polyphenolsMgPer100g: 100.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND032': // Bell Pepper
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 31.0,
          proteinGPer100g: 1.0,
          fatGPer100g: 0.3,
          carbsGPer100g: 7.3,
          fiberGPer100g: 2.5,
          vitAIUPer100g: 3131.0,
          vitCMgPer100g: 127.7,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 1.6,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.4,
          calciumMgPer100g: 7.0,
          potassiumMgPer100g: 211.0,
          polyphenolsMgPer100g: 50.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND033': // Zucchini
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 17.0,
          proteinGPer100g: 1.2,
          fatGPer100g: 0.3,
          carbsGPer100g: 3.1,
          fiberGPer100g: 1.0,
          vitAIUPer100g: 200.0,
          vitCMgPer100g: 17.9,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.1,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 0.4,
          calciumMgPer100g: 16.0,
          potassiumMgPer100g: 261.0,
          polyphenolsMgPer100g: 25.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND034': // Sweet Potato
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 86.0,
          proteinGPer100g: 1.6,
          fatGPer100g: 0.1,
          carbsGPer100g: 20.1,
          fiberGPer100g: 3.0,
          vitAIUPer100g: 14187.0,
          vitCMgPer100g: 2.4,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.3,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 0.6,
          calciumMgPer100g: 30.0,
          potassiumMgPer100g: 337.0,
          polyphenolsMgPer100g: 50.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND035': // Asparagus
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 20.0,
          proteinGPer100g: 2.2,
          fatGPer100g: 0.1,
          carbsGPer100g: 3.9,
          fiberGPer100g: 2.1,
          vitAIUPer100g: 756.0,
          vitCMgPer100g: 5.6,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 1.1,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 2.1,
          calciumMgPer100g: 24.0,
          potassiumMgPer100g: 202.0,
          polyphenolsMgPer100g: 75.0,
          phytosterolsMgPer100g: 0.0,
        );
      // Grain Items Nutritional Data
      case 'IND036': // Wheat
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 364.0,
          proteinGPer100g: 10.3,
          fatGPer100g: 1.0,
          carbsGPer100g: 76.3,
          fiberGPer100g: 2.7,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.3,
          ironMgPer100g: 4.6,
          calciumMgPer100g: 34.0,
          potassiumMgPer100g: 107.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND037': // Barley
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 352.0,
          proteinGPer100g: 12.5,
          fatGPer100g: 2.3,
          carbsGPer100g: 73.5,
          fiberGPer100g: 17.3,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.4,
          ironMgPer100g: 2.5,
          calciumMgPer100g: 33.0,
          potassiumMgPer100g: 452.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND038': // Millet
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 378.0,
          proteinGPer100g: 11.0,
          fatGPer100g: 4.2,
          carbsGPer100g: 72.9,
          fiberGPer100g: 8.5,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.4,
          ironMgPer100g: 6.4,
          calciumMgPer100g: 8.0,
          potassiumMgPer100g: 195.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND039': // Quinoa
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 368.0,
          proteinGPer100g: 14.1,
          fatGPer100g: 6.1,
          carbsGPer100g: 64.2,
          fiberGPer100g: 7.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.4,
          ironMgPer100g: 4.6,
          calciumMgPer100g: 47.0,
          potassiumMgPer100g: 563.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND040': // Buckwheat
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 343.0,
          proteinGPer100g: 13.3,
          fatGPer100g: 3.4,
          carbsGPer100g: 71.5,
          fiberGPer100g: 10.0,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.1,
          ironMgPer100g: 2.2,
          calciumMgPer100g: 18.0,
          potassiumMgPer100g: 460.0,
          polyphenolsMgPer100g: 0.0,
          phytosterolsMgPer100g: 0.0,
        );
      // Spice Items Nutritional Data
      case 'IND041': // Cloves
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 274.0,
          proteinGPer100g: 6.0,
          fatGPer100g: 13.0,
          carbsGPer100g: 65.5,
          fiberGPer100g: 33.9,
          vitAIUPer100g: 160.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 8.8,
          vitB1MgPer100g: 0.2,
          ironMgPer100g: 11.8,
          calciumMgPer100g: 632.0,
          potassiumMgPer100g: 1020.0,
          polyphenolsMgPer100g: 500.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND042': // Fenugreek
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 323.0,
          proteinGPer100g: 23.0,
          fatGPer100g: 6.4,
          carbsGPer100g: 58.4,
          fiberGPer100g: 24.6,
          vitAIUPer100g: 60.0,
          vitCMgPer100g: 3.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.3,
          ironMgPer100g: 33.5,
          calciumMgPer100g: 176.0,
          potassiumMgPer100g: 770.0,
          polyphenolsMgPer100g: 200.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND043': // Fennel Seeds
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 345.0,
          proteinGPer100g: 15.8,
          fatGPer100g: 14.9,
          carbsGPer100g: 52.3,
          fiberGPer100g: 39.8,
          vitAIUPer100g: 134.0,
          vitCMgPer100g: 21.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.4,
          ironMgPer100g: 18.5,
          calciumMgPer100g: 1196.0,
          potassiumMgPer100g: 1694.0,
          polyphenolsMgPer100g: 300.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND044': // Mustard Seeds
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 508.0,
          proteinGPer100g: 26.1,
          fatGPer100g: 36.2,
          carbsGPer100g: 28.1,
          fiberGPer100g: 12.2,
          vitAIUPer100g: 31.0,
          vitCMgPer100g: 7.1,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.8,
          ironMgPer100g: 9.2,
          calciumMgPer100g: 266.0,
          potassiumMgPer100g: 738.0,
          polyphenolsMgPer100g: 150.0,
          phytosterolsMgPer100g: 0.0,
        );
      case 'IND045': // Asafoetida
        return NutritionalData(
          foodId: foodId,
          caloriesPer100g: 297.0,
          proteinGPer100g: 4.0,
          fatGPer100g: 1.1,
          carbsGPer100g: 67.8,
          fiberGPer100g: 4.1,
          vitAIUPer100g: 0.0,
          vitCMgPer100g: 0.0,
          vitDUgPer100g: 0.0,
          vitEMgPer100g: 0.0,
          vitB1MgPer100g: 0.0,
          ironMgPer100g: 39.4,
          calciumMgPer100g: 690.0,
          potassiumMgPer100g: 0.0,
          polyphenolsMgPer100g: 100.0,
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
      
      if (snapshot.docs.isEmpty) {
        // Return demo patients if no data in Firestore
        return _getDemoPatients();
      }
      
      return snapshot.docs
          .map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching patients: $e');
      // Return demo data on error
      return _getDemoPatients();
    }
  }

  // Demo patients for when Firestore is empty
  List<Patient> _getDemoPatients() {
    return [
      Patient(
        patientId: 'DEMO_PATIENT_001',
        namePseudonym: 'Priya Sharma',
        age: 28,
        gender: 'Female',
        contactInfo: 'priya.sharma@email.com',
        dietaryHabits: 'Vegetarian, prefers home-cooked meals',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Moderate - 30 mins daily',
        sleepPatterns: '7-8 hours, good quality sleep',
        stressLevels: 'Low to moderate',
        allergies: 'None known',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Pitta-Kapha dominant',
      ),
      Patient(
        patientId: 'DEMO_PATIENT_002',
        namePseudonym: 'Raj Kumar',
        age: 45,
        gender: 'Male',
        contactInfo: 'raj.kumar@email.com',
        dietaryHabits: 'Non-vegetarian, occasional fast food',
        mealFrequencyPerDay: 2,
        bowelMovements: 'Irregular, sometimes constipated',
        waterIntakeLiters: 1.5,
        physicalActivityLevel: 'Low - sedentary job',
        sleepPatterns: '5-6 hours, disturbed sleep',
        stressLevels: 'High - work pressure',
        allergies: 'Dairy intolerance',
        comorbidities: 'Type 2 Diabetes, Hypertension',
        doshaPrakritiAssessment: 'Vata-Pitta dominant',
      ),
      Patient(
        patientId: 'DEMO_PATIENT_003',
        namePseudonym: 'Anita Patel',
        age: 35,
        gender: 'Female',
        contactInfo: 'anita.patel@email.com',
        dietaryHabits: 'Vegan, organic food preference',
        mealFrequencyPerDay: 4,
        bowelMovements: 'Regular, twice daily',
        waterIntakeLiters: 3.0,
        physicalActivityLevel: 'High - yoga and gym',
        sleepPatterns: '8-9 hours, deep sleep',
        stressLevels: 'Low - good work-life balance',
        allergies: 'Gluten sensitivity',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Kapha dominant',
      ),
      Patient(
        patientId: 'DEMO_PATIENT_004',
        namePseudonym: 'Vikram Singh',
        age: 52,
        gender: 'Male',
        contactInfo: 'vikram.singh@email.com',
        dietaryHabits: 'Mixed diet, traditional Indian food',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.0,
        physicalActivityLevel: 'Moderate - morning walks',
        sleepPatterns: '6-7 hours, light sleeper',
        stressLevels: 'Moderate - family responsibilities',
        allergies: 'None',
        comorbidities: 'High cholesterol',
        doshaPrakritiAssessment: 'Pitta dominant',
      ),
      Patient(
        patientId: 'DEMO_PATIENT_005',
        namePseudonym: 'Sunita Reddy',
        age: 41,
        gender: 'Female',
        contactInfo: 'sunita.reddy@email.com',
        dietaryHabits: 'Vegetarian, South Indian cuisine',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Moderate - household activities',
        sleepPatterns: '7-8 hours, good quality',
        stressLevels: 'Moderate - work and family',
        allergies: 'None',
        comorbidities: 'Mild anemia',
        doshaPrakritiAssessment: 'Vata-Kapha balanced',
      ),
    ];
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
