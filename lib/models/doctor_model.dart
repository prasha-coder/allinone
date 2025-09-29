class Doctor {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final String fullName;
  final String specialization;
  final String licenseNumber;
  final String phoneNumber;
  final String hospital;
  final String experience;
  final String qualifications;
  final DateTime createdAt;
  final DateTime? lastLogin;

  Doctor({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fullName,
    required this.specialization,
    required this.licenseNumber,
    required this.phoneNumber,
    required this.hospital,
    required this.experience,
    required this.qualifications,
    required this.createdAt,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'full_name': fullName,
      'specialization': specialization,
      'license_number': licenseNumber,
      'phone_number': phoneNumber,
      'hospital': hospital,
      'experience': experience,
      'qualifications': qualifications,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_login': lastLogin?.millisecondsSinceEpoch,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      passwordHash: map['password_hash'],
      fullName: map['full_name'],
      specialization: map['specialization'],
      licenseNumber: map['license_number'],
      phoneNumber: map['phone_number'],
      hospital: map['hospital'],
      experience: map['experience'],
      qualifications: map['qualifications'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      lastLogin: map['last_login'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['last_login'])
          : null,
    );
  }

  Doctor copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    String? fullName,
    String? specialization,
    String? licenseNumber,
    String? phoneNumber,
    String? hospital,
    String? experience,
    String? qualifications,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return Doctor(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hospital: hospital ?? this.hospital,
      experience: experience ?? this.experience,
      qualifications: qualifications ?? this.qualifications,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
