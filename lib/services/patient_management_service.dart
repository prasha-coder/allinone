import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'patients';

  // Create a new patient
  Future<String> createPatient(Patient patient) async {
    try {
      final docRef = await _firestore.collection(_collectionName).add(patient.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create patient: $e');
    }
  }

  // Get patient by ID
  Future<Patient?> getPatient(String patientId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(patientId).get();
      if (doc.exists) {
        return Patient.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get patient: $e');
    }
  }

  // Update patient
  Future<void> updatePatient(String patientId, Patient patient) async {
    try {
      await _firestore.collection(_collectionName).doc(patientId).update(patient.toMap());
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  // Delete patient
  Future<void> deletePatient(String patientId) async {
    try {
      await _firestore.collection(_collectionName).doc(patientId).delete();
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }

  // Get all patients with pagination
  Future<List<Patient>> getAllPatients({int limit = 50, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore.collection(_collectionName).orderBy('createdAt', descending: true);
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      final querySnapshot = await query.limit(limit).get();
      return querySnapshot.docs.map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return demo patients if Firestore fails
      return _getDemoPatients();
    }
  }

  // Search patients by name
  Future<List<Patient>> searchPatients(String searchTerm) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('namePseudonym', isGreaterThanOrEqualTo: searchTerm)
          .where('namePseudonym', isLessThan: '${searchTerm}z')
          .get();
      
      return querySnapshot.docs.map((doc) => Patient.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo patients if Firestore fails
      final demoPatients = _getDemoPatients();
      return demoPatients.where((patient) => 
        patient.namePseudonym.toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
    }
  }

  // Get patients by dosha type
  Future<List<Patient>> getPatientsByDosha(String doshaType) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('doshaPrakritiAssessment', isEqualTo: doshaType)
          .get();
      
      return querySnapshot.docs.map((doc) => Patient.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo patients if Firestore fails
      final demoPatients = _getDemoPatients();
      return demoPatients.where((patient) => 
        patient.doshaPrakritiAssessment.toLowerCase().contains(doshaType.toLowerCase())
      ).toList();
    }
  }

  // Get patients by age range
  Future<List<Patient>> getPatientsByAgeRange(int minAge, int maxAge) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('age', isLessThanOrEqualTo: maxAge)
          .get();
      
      return querySnapshot.docs.map((doc) => Patient.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo patients if Firestore fails
      final demoPatients = _getDemoPatients();
      return demoPatients.where((patient) => 
        patient.age >= minAge && patient.age <= maxAge
      ).toList();
    }
  }

  // Get patients by dietary habits
  Future<List<Patient>> getPatientsByDietaryHabits(String dietaryHabits) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('dietaryHabits', isEqualTo: dietaryHabits)
          .get();
      
      return querySnapshot.docs.map((doc) => Patient.fromMap(doc.data())).toList();
    } catch (e) {
      // Return filtered demo patients if Firestore fails
      final demoPatients = _getDemoPatients();
      return demoPatients.where((patient) => 
        patient.dietaryHabits.toLowerCase().contains(dietaryHabits.toLowerCase())
      ).toList();
    }
  }

  // Get patient statistics
  Future<Map<String, dynamic>> getPatientStatistics() async {
    try {
      final patients = await getAllPatients();
      
      final totalPatients = patients.length;
      final malePatients = patients.where((p) => p.gender.toLowerCase() == 'male').length;
      final femalePatients = patients.where((p) => p.gender.toLowerCase() == 'female').length;
      
      final ageGroups = {
        'children': patients.where((p) => p.age < 18).length,
        'adults': patients.where((p) => p.age >= 18 && p.age < 60).length,
        'seniors': patients.where((p) => p.age >= 60).length,
      };
      
      final doshaDistribution = <String, int>{};
      for (final patient in patients) {
        final dosha = patient.doshaPrakritiAssessment;
        doshaDistribution[dosha] = (doshaDistribution[dosha] ?? 0) + 1;
      }
      
      final dietaryHabitsDistribution = <String, int>{};
      for (final patient in patients) {
        final habit = patient.dietaryHabits;
        dietaryHabitsDistribution[habit] = (dietaryHabitsDistribution[habit] ?? 0) + 1;
      }
      
      return {
        'totalPatients': totalPatients,
        'malePatients': malePatients,
        'femalePatients': femalePatients,
        'ageGroups': ageGroups,
        'doshaDistribution': doshaDistribution,
        'dietaryHabitsDistribution': dietaryHabitsDistribution,
      };
    } catch (e) {
      return {
        'totalPatients': 0,
        'malePatients': 0,
        'femalePatients': 0,
        'ageGroups': {'children': 0, 'adults': 0, 'seniors': 0},
        'doshaDistribution': {},
        'dietaryHabitsDistribution': {},
      };
    }
  }

  // Demo patients for offline functionality
  List<Patient> _getDemoPatients() {
    return [
      Patient(
        patientId: 'DEMO001',
        namePseudonym: 'Rajesh Kumar',
        age: 35,
        gender: 'Male',
        contactInfo: 'rajesh.kumar@email.com',
        dietaryHabits: 'Vegetarian',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 3.0,
        physicalActivityLevel: 'Moderate - 30 mins daily',
        sleepPatterns: '7-8 hours, good quality sleep',
        stressLevels: 'Moderate',
        allergies: 'None',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Pitta-Kapha',
      ),
      Patient(
        patientId: 'DEMO002',
        namePseudonym: 'Priya Sharma',
        age: 28,
        gender: 'Female',
        contactInfo: 'priya.sharma@email.com',
        dietaryHabits: 'Non-Vegetarian',
        mealFrequencyPerDay: 4,
        bowelMovements: 'Regular, twice daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Active - 45 mins daily',
        sleepPatterns: '6-7 hours, moderate quality',
        stressLevels: 'High',
        allergies: 'Dairy',
        comorbidities: 'PCOS',
        doshaPrakritiAssessment: 'Vata-Pitta',
      ),
      Patient(
        patientId: 'DEMO003',
        namePseudonym: 'Amit Patel',
        age: 45,
        gender: 'Male',
        contactInfo: 'amit.patel@email.com',
        dietaryHabits: 'Vegetarian',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Irregular, constipation',
        waterIntakeLiters: 2.0,
        physicalActivityLevel: 'Light - 15 mins daily',
        sleepPatterns: '5-6 hours, poor quality',
        stressLevels: 'Very High',
        allergies: 'None',
        comorbidities: 'Diabetes Type 2',
        doshaPrakritiAssessment: 'Vata',
      ),
      Patient(
        patientId: 'DEMO004',
        namePseudonym: 'Sunita Devi',
        age: 52,
        gender: 'Female',
        contactInfo: 'sunita.devi@email.com',
        dietaryHabits: 'Lacto-Vegetarian',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Moderate - 30 mins daily',
        sleepPatterns: '7-8 hours, good quality sleep',
        stressLevels: 'Low to moderate',
        allergies: 'None',
        comorbidities: 'Hypertension',
        doshaPrakritiAssessment: 'Kapha',
      ),
      Patient(
        patientId: 'DEMO005',
        namePseudonym: 'Vikram Singh',
        age: 22,
        gender: 'Male',
        contactInfo: 'vikram.singh@email.com',
        dietaryHabits: 'Non-Vegetarian',
        mealFrequencyPerDay: 5,
        bowelMovements: 'Regular, 3+ times daily',
        waterIntakeLiters: 4.0,
        physicalActivityLevel: 'Very Active - 60+ mins daily',
        sleepPatterns: '8+ hours, excellent quality',
        stressLevels: 'Low',
        allergies: 'None',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Pitta',
      ),
      Patient(
        patientId: 'DEMO006',
        namePseudonym: 'Meera Joshi',
        age: 38,
        gender: 'Female',
        contactInfo: 'meera.joshi@email.com',
        dietaryHabits: 'Vegan',
        mealFrequencyPerDay: 4,
        bowelMovements: 'Regular, twice daily',
        waterIntakeLiters: 3.5,
        physicalActivityLevel: 'Active - 45 mins daily',
        sleepPatterns: '7-8 hours, good quality sleep',
        stressLevels: 'Moderate',
        allergies: 'Gluten',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Vata-Pitta-Kapha (Balanced)',
      ),
      Patient(
        patientId: 'DEMO007',
        namePseudonym: 'Arjun Reddy',
        age: 29,
        gender: 'Male',
        contactInfo: 'arjun.reddy@email.com',
        dietaryHabits: 'Pescatarian',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Moderate - 30 mins daily',
        sleepPatterns: '6-7 hours, moderate quality',
        stressLevels: 'High',
        allergies: 'Shellfish',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Pitta-Kapha',
      ),
      Patient(
        patientId: 'DEMO008',
        namePseudonym: 'Kavita Nair',
        age: 41,
        gender: 'Female',
        contactInfo: 'kavita.nair@email.com',
        dietaryHabits: 'Vegetarian',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Irregular, diarrhea',
        waterIntakeLiters: 2.0,
        physicalActivityLevel: 'Sedentary - No exercise',
        sleepPatterns: '5-6 hours, poor quality',
        stressLevels: 'Very High',
        allergies: 'None',
        comorbidities: 'IBS',
        doshaPrakritiAssessment: 'Vata',
      ),
    ];
  }
}
