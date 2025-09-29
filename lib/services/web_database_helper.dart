import '../models/doctor_model.dart';

class WebDatabaseHelper {
  static final WebDatabaseHelper _instance = WebDatabaseHelper._internal();
  factory WebDatabaseHelper() => _instance;
  WebDatabaseHelper._internal() {
    _initializeDemoData();
  }

  // In-memory storage for web compatibility
  final List<Doctor> _doctors = [];

  void _initializeDemoData() {
    _doctors.addAll([
      Doctor(
        id: 1,
        username: 'dr_sharma',
        email: 'dr.sharma@thingbots.com',
        passwordHash: '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        fullName: 'Dr. Priya Sharma',
        specialization: 'Ayurvedic Medicine',
        licenseNumber: 'AYU001',
        phoneNumber: '+91-9876543210',
        hospital: 'ThingBots Ayurvedic Center',
        experience: '15 years',
        qualifications: 'BAMS, MD (Ayurveda)',
        createdAt: DateTime.now(),
        lastLogin: null,
      ),
      Doctor(
        id: 2,
        username: 'dr_kumar',
        email: 'dr.kumar@thingbots.com',
        passwordHash: '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        fullName: 'Dr. Raj Kumar',
        specialization: 'Nutrition & Dietetics',
        licenseNumber: 'NUT002',
        phoneNumber: '+91-9876543211',
        hospital: 'ThingBots Nutrition Clinic',
        experience: '12 years',
        qualifications: 'B.Sc Nutrition, M.Sc Dietetics',
        createdAt: DateTime.now(),
        lastLogin: null,
      ),
      Doctor(
        id: 3,
        username: 'dr_patel',
        email: 'dr.patel@thingbots.com',
        passwordHash: '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        fullName: 'Dr. Anita Patel',
        specialization: 'Holistic Medicine',
        licenseNumber: 'HOL003',
        phoneNumber: '+91-9876543212',
        hospital: 'ThingBots Wellness Center',
        experience: '10 years',
        qualifications: 'MBBS, MD (Internal Medicine)',
        createdAt: DateTime.now(),
        lastLogin: null,
      ),
    ]);
  }

  // Doctor CRUD operations
  Future<int> insertDoctor(Doctor doctor) async {
    final newId = _doctors.isEmpty ? 1 : _doctors.map((d) => d.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    final newDoctor = doctor.copyWith(id: newId);
    _doctors.add(newDoctor);
    return newId;
  }

  Future<List<Doctor>> getAllDoctors() async {
    return List.from(_doctors);
  }

  Future<Doctor?> getDoctorByUsername(String username) async {
    try {
      return _doctors.firstWhere((doctor) => doctor.username == username);
    } catch (e) {
      return null;
    }
  }

  Future<Doctor?> getDoctorByEmail(String email) async {
    try {
      return _doctors.firstWhere((doctor) => doctor.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<Doctor?> authenticateDoctor(String username, String passwordHash) async {
    try {
      return _doctors.firstWhere((doctor) => 
          doctor.username == username && doctor.passwordHash == passwordHash);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateDoctor(Doctor doctor) async {
    final index = _doctors.indexWhere((d) => d.id == doctor.id);
    if (index != -1) {
      _doctors[index] = doctor;
      return 1;
    }
    return 0;
  }

  Future<int> updateLastLogin(int doctorId) async {
    final index = _doctors.indexWhere((d) => d.id == doctorId);
    if (index != -1) {
      _doctors[index] = _doctors[index].copyWith(lastLogin: DateTime.now());
      return 1;
    }
    return 0;
  }

  Future<int> deleteDoctor(int id) async {
    final index = _doctors.indexWhere((d) => d.id == id);
    if (index != -1) {
      _doctors.removeAt(index);
      return 1;
    }
    return 0;
  }
}
