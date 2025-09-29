class Patient {
  final String patientId;
  final String namePseudonym;
  final int age;
  final String gender;
  final String contactInfo;
  final String dietaryHabits;
  final int mealFrequencyPerDay;
  final String bowelMovements;
  final double waterIntakeLiters;
  final String physicalActivityLevel;
  final String sleepPatterns;
  final String stressLevels;
  final String allergies;
  final String comorbidities;
  final String doshaPrakritiAssessment;

  Patient({
    required this.patientId,
    required this.namePseudonym,
    required this.age,
    required this.gender,
    required this.contactInfo,
    required this.dietaryHabits,
    required this.mealFrequencyPerDay,
    required this.bowelMovements,
    required this.waterIntakeLiters,
    required this.physicalActivityLevel,
    required this.sleepPatterns,
    required this.stressLevels,
    required this.allergies,
    required this.comorbidities,
    required this.doshaPrakritiAssessment,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientId: map['patientId'] ?? '',
      namePseudonym: map['namePseudonym'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      contactInfo: map['contactInfo'] ?? '',
      dietaryHabits: map['dietaryHabits'] ?? '',
      mealFrequencyPerDay: map['mealFrequencyPerDay'] ?? 0,
      bowelMovements: map['bowelMovements'] ?? '',
      waterIntakeLiters: (map['waterIntakeLiters'] ?? 0).toDouble(),
      physicalActivityLevel: map['physicalActivityLevel'] ?? '',
      sleepPatterns: map['sleepPatterns'] ?? '',
      stressLevels: map['stressLevels'] ?? '',
      allergies: map['allergies'] ?? '',
      comorbidities: map['comorbidities'] ?? '',
      doshaPrakritiAssessment: map['doshaPrakritiAssessment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'namePseudonym': namePseudonym,
      'age': age,
      'gender': gender,
      'contactInfo': contactInfo,
      'dietaryHabits': dietaryHabits,
      'mealFrequencyPerDay': mealFrequencyPerDay,
      'bowelMovements': bowelMovements,
      'waterIntakeLiters': waterIntakeLiters,
      'physicalActivityLevel': physicalActivityLevel,
      'sleepPatterns': sleepPatterns,
      'stressLevels': stressLevels,
      'allergies': allergies,
      'comorbidities': comorbidities,
      'doshaPrakritiAssessment': doshaPrakritiAssessment,
    };
  }
}
