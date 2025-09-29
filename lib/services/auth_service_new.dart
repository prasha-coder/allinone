import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/doctor_model.dart';
import 'web_database_helper.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }
enum UserType { doctor, googleUser }

class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final UserType userType;
  final Doctor? doctorProfile;

  AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    required this.userType,
    this.doctorProfile,
  });

  AuthUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    UserType? userType,
    Doctor? doctorProfile,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      userType: userType ?? this.userType,
      doctorProfile: doctorProfile ?? this.doctorProfile,
    );
  }
}

class AuthServiceNew with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final WebDatabaseHelper _dbHelper = WebDatabaseHelper();

  AuthUser? _user;
  AuthStatus _status = AuthStatus.unauthenticated;

  AuthUser? get user => _user;
  AuthStatus get status => _status;
  bool get isAuthenticated => _user != null;
  bool get isDoctor => _user?.userType == UserType.doctor;
  bool get isGoogleUser => _user?.userType == UserType.googleUser;

  AuthServiceNew() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser == null) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = AuthUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          userType: UserType.googleUser,
        );
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  // Google Sign-In (Demo Mode)
  Future<AuthUser?> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // For demo purposes, simulate Google Sign-In
      // In production, you would configure the Google Client ID
      await Future.delayed(const Duration(seconds: 1));

      _user = AuthUser(
        uid: 'google_demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'demo.user@gmail.com',
        displayName: 'Demo Google User',
        userType: UserType.googleUser,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      debugPrint('Google Sign-In (Demo) successful: ${_user?.displayName}');
      return _user;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return null;
    }
  }

  // Doctor Registration
  Future<AuthUser?> registerDoctor({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String specialization,
    required String licenseNumber,
    required String phoneNumber,
    required String hospital,
    required String experience,
    required String qualifications,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // Check if username or email already exists
      final existingDoctor = await _dbHelper.getDoctorByUsername(username);
      if (existingDoctor != null) {
        throw Exception('Username already exists');
      }

      final existingEmail = await _dbHelper.getDoctorByEmail(email);
      if (existingEmail != null) {
        throw Exception('Email already registered');
      }

      // Hash password
      final passwordHash = _hashPassword(password);

      // Create doctor
      final doctor = Doctor(
        username: username,
        email: email,
        passwordHash: passwordHash,
        fullName: fullName,
        specialization: specialization,
        licenseNumber: licenseNumber,
        phoneNumber: phoneNumber,
        hospital: hospital,
        experience: experience,
        qualifications: qualifications,
        createdAt: DateTime.now(),
      );

      final doctorId = await _dbHelper.insertDoctor(doctor);
      final createdDoctor = doctor.copyWith(id: doctorId);

      _user = AuthUser(
        uid: 'doctor_$doctorId',
        email: email,
        displayName: fullName,
        userType: UserType.doctor,
        doctorProfile: createdDoctor,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();

      debugPrint('Doctor registration successful: ${_user?.displayName}');
      return _user;
    } catch (e) {
      debugPrint('Doctor registration error: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  // Doctor Login
  Future<AuthUser?> signInDoctor(String username, String password) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      debugPrint('Attempting doctor login for username: $username');
      final passwordHash = _hashPassword(password);
      debugPrint('Password hash generated: ${passwordHash.substring(0, 10)}...');
      
      final doctor = await _dbHelper.authenticateDoctor(username, passwordHash);
      debugPrint('Doctor lookup result: ${doctor?.fullName ?? 'Not found'}');

      if (doctor != null) {
        // Update last login
        await _dbHelper.updateLastLogin(doctor.id!);

        _user = AuthUser(
          uid: 'doctor_${doctor.id}',
          email: doctor.email,
          displayName: doctor.fullName,
          userType: UserType.doctor,
          doctorProfile: doctor,
        );
        _status = AuthStatus.authenticated;
        notifyListeners();

        debugPrint('Doctor login successful: ${_user?.displayName}');
        return _user;
      } else {
        debugPrint('Doctor not found or invalid credentials');
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      debugPrint('Doctor login error: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      if (_user?.userType == UserType.googleUser) {
        await _googleSignIn.signOut();
        await _auth.signOut();
      }
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // Password hashing
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Get all doctors (for admin purposes)
  Future<List<Doctor>> getAllDoctors() async {
    return await _dbHelper.getAllDoctors();
  }

  // Update doctor profile
  Future<void> updateDoctorProfile(Doctor doctor) async {
    if (_user?.userType == UserType.doctor && _user?.doctorProfile?.id == doctor.id) {
      await _dbHelper.updateDoctor(doctor);
      _user = _user!.copyWith(doctorProfile: doctor);
      notifyListeners();
    }
  }
}
