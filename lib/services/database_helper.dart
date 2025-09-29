import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/doctor_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'thingbots_doctors.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        full_name TEXT NOT NULL,
        specialization TEXT NOT NULL,
        license_number TEXT UNIQUE NOT NULL,
        phone_number TEXT NOT NULL,
        hospital TEXT NOT NULL,
        experience TEXT NOT NULL,
        qualifications TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        last_login INTEGER
      )
    ''');

    // Insert some demo doctors
    await _insertDemoDoctors(db);
  }

  Future<void> _insertDemoDoctors(Database db) async {
    final demoDoctors = [
      {
        'username': 'dr_sharma',
        'email': 'dr.sharma@thingbots.com',
        'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        'full_name': 'Dr. Priya Sharma',
        'specialization': 'Ayurvedic Medicine',
        'license_number': 'AYU001',
        'phone_number': '+91-9876543210',
        'hospital': 'ThingBots Ayurvedic Center',
        'experience': '15 years',
        'qualifications': 'BAMS, MD (Ayurveda)',
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'last_login': null,
      },
      {
        'username': 'dr_kumar',
        'email': 'dr.kumar@thingbots.com',
        'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        'full_name': 'Dr. Raj Kumar',
        'specialization': 'Nutrition & Dietetics',
        'license_number': 'NUT002',
        'phone_number': '+91-9876543211',
        'hospital': 'ThingBots Nutrition Clinic',
        'experience': '12 years',
        'qualifications': 'B.Sc Nutrition, M.Sc Dietetics',
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'last_login': null,
      },
      {
        'username': 'dr_patel',
        'email': 'dr.patel@thingbots.com',
        'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // 'password'
        'full_name': 'Dr. Anita Patel',
        'specialization': 'Holistic Medicine',
        'license_number': 'HOL003',
        'phone_number': '+91-9876543212',
        'hospital': 'ThingBots Wellness Center',
        'experience': '10 years',
        'qualifications': 'MBBS, MD (Internal Medicine)',
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'last_login': null,
      },
    ];

    for (final doctor in demoDoctors) {
      await db.insert('doctors', doctor);
    }
  }

  // Doctor CRUD operations
  Future<int> insertDoctor(Doctor doctor) async {
    final db = await database;
    return await db.insert('doctors', doctor.toMap());
  }

  Future<List<Doctor>> getAllDoctors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('doctors');
    return List.generate(maps.length, (i) => Doctor.fromMap(maps[i]));
  }

  Future<Doctor?> getDoctorByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'doctors',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return Doctor.fromMap(maps.first);
    }
    return null;
  }

  Future<Doctor?> getDoctorByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'doctors',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Doctor.fromMap(maps.first);
    }
    return null;
  }

  Future<Doctor?> authenticateDoctor(String username, String passwordHash) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'doctors',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, passwordHash],
    );
    if (maps.isNotEmpty) {
      return Doctor.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateDoctor(Doctor doctor) async {
    final db = await database;
    return await db.update(
      'doctors',
      doctor.toMap(),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  Future<int> updateLastLogin(int doctorId) async {
    final db = await database;
    return await db.update(
      'doctors',
      {'last_login': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [doctorId],
    );
  }

  Future<int> deleteDoctor(int id) async {
    final db = await database;
    return await db.delete(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
