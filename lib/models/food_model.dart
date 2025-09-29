class Food {
  final String foodId;
  final String foodNameEnglish;
  final String foodNameLocal;
  final String baseItem;
  final String category;
  final String cuisine;
  final String scientificName;
  final String description;
  final String mealType;
  final double servingSizeG;
  final String rasa;
  final String virya;
  final String vipaka;
  final String guna;
  final String digestibility;
  final String doshaSuitability;
  final String allergenWarnings;

  Food({
    required this.foodId,
    required this.foodNameEnglish,
    required this.foodNameLocal,
    required this.baseItem,
    required this.category,
    required this.cuisine,
    required this.scientificName,
    required this.description,
    required this.mealType,
    required this.servingSizeG,
    required this.rasa,
    required this.virya,
    required this.vipaka,
    required this.guna,
    required this.digestibility,
    required this.doshaSuitability,
    required this.allergenWarnings,
  });

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      foodId: map['foodId'] ?? '',
      foodNameEnglish: map['foodNameEnglish'] ?? '',
      foodNameLocal: map['foodNameLocal'] ?? '',
      baseItem: map['baseItem'] ?? '',
      category: map['category'] ?? '',
      cuisine: map['cuisine'] ?? '',
      scientificName: map['scientificName'] ?? '',
      description: map['description'] ?? '',
      mealType: map['mealType'] ?? '',
      servingSizeG: (map['servingSizeG'] ?? 0).toDouble(),
      rasa: map['rasa'] ?? '',
      virya: map['virya'] ?? '',
      vipaka: map['vipaka'] ?? '',
      guna: map['guna'] ?? '',
      digestibility: map['digestibility'] ?? '',
      doshaSuitability: map['doshaSuitability'] ?? '',
      allergenWarnings: map['allergenWarnings'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodNameEnglish': foodNameEnglish,
      'foodNameLocal': foodNameLocal,
      'baseItem': baseItem,
      'category': category,
      'cuisine': cuisine,
      'scientificName': scientificName,
      'description': description,
      'mealType': mealType,
      'servingSizeG': servingSizeG,
      'rasa': rasa,
      'virya': virya,
      'vipaka': vipaka,
      'guna': guna,
      'digestibility': digestibility,
      'doshaSuitability': doshaSuitability,
      'allergenWarnings': allergenWarnings,
    };
  }
}
