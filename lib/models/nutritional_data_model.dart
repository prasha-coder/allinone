class NutritionalData {
  final String foodId;
  final double caloriesPer100g;
  final double proteinGPer100g;
  final double fatGPer100g;
  final double carbsGPer100g;
  final double fiberGPer100g;
  final double vitAIUPer100g;
  final double vitCMgPer100g;
  final double vitDUgPer100g;
  final double vitEMgPer100g;
  final double vitB1MgPer100g;
  final double ironMgPer100g;
  final double calciumMgPer100g;
  final double potassiumMgPer100g;
  final double polyphenolsMgPer100g;
  final double phytosterolsMgPer100g;

  NutritionalData({
    required this.foodId,
    required this.caloriesPer100g,
    required this.proteinGPer100g,
    required this.fatGPer100g,
    required this.carbsGPer100g,
    required this.fiberGPer100g,
    required this.vitAIUPer100g,
    required this.vitCMgPer100g,
    required this.vitDUgPer100g,
    required this.vitEMgPer100g,
    required this.vitB1MgPer100g,
    required this.ironMgPer100g,
    required this.calciumMgPer100g,
    required this.potassiumMgPer100g,
    required this.polyphenolsMgPer100g,
    required this.phytosterolsMgPer100g,
  });

  factory NutritionalData.fromMap(Map<String, dynamic> map) {
    return NutritionalData(
      foodId: map['foodId'] ?? '',
      caloriesPer100g: (map['caloriesPer100g'] ?? 0).toDouble(),
      proteinGPer100g: (map['proteinGPer100g'] ?? 0).toDouble(),
      fatGPer100g: (map['fatGPer100g'] ?? 0).toDouble(),
      carbsGPer100g: (map['carbsGPer100g'] ?? 0).toDouble(),
      fiberGPer100g: (map['fiberGPer100g'] ?? 0).toDouble(),
      vitAIUPer100g: (map['vitAIUPer100g'] ?? 0).toDouble(),
      vitCMgPer100g: (map['vitCMgPer100g'] ?? 0).toDouble(),
      vitDUgPer100g: (map['vitDUgPer100g'] ?? 0).toDouble(),
      vitEMgPer100g: (map['vitEMgPer100g'] ?? 0).toDouble(),
      vitB1MgPer100g: (map['vitB1MgPer100g'] ?? 0).toDouble(),
      ironMgPer100g: (map['ironMgPer100g'] ?? 0).toDouble(),
      calciumMgPer100g: (map['calciumMgPer100g'] ?? 0).toDouble(),
      potassiumMgPer100g: (map['potassiumMgPer100g'] ?? 0).toDouble(),
      polyphenolsMgPer100g: (map['polyphenolsMgPer100g'] ?? 0).toDouble(),
      phytosterolsMgPer100g: (map['phytosterolsMgPer100g'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'caloriesPer100g': caloriesPer100g,
      'proteinGPer100g': proteinGPer100g,
      'fatGPer100g': fatGPer100g,
      'carbsGPer100g': carbsGPer100g,
      'fiberGPer100g': fiberGPer100g,
      'vitAIUPer100g': vitAIUPer100g,
      'vitCMgPer100g': vitCMgPer100g,
      'vitDUgPer100g': vitDUgPer100g,
      'vitEMgPer100g': vitEMgPer100g,
      'vitB1MgPer100g': vitB1MgPer100g,
      'ironMgPer100g': ironMgPer100g,
      'calciumMgPer100g': calciumMgPer100g,
      'potassiumMgPer100g': potassiumMgPer100g,
      'polyphenolsMgPer100g': polyphenolsMgPer100g,
      'phytosterolsMgPer100g': phytosterolsMgPer100g,
    };
  }
}
