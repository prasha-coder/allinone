import 'lib/services/web_database_helper.dart';
import 'lib/models/doctor_model.dart';

void main() async {
  print('Testing Web Database Helper...');
  
  final dbHelper = WebDatabaseHelper();
  
  // Test getting all doctors
  final doctors = await dbHelper.getAllDoctors();
  print('Found ${doctors.length} doctors in database');
  
  // Test authentication
  final doctor = await dbHelper.authenticateDoctor('dr_sharma', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');
  if (doctor != null) {
    print('✅ Doctor authentication successful: ${doctor.fullName}');
  } else {
    print('❌ Doctor authentication failed');
  }
  
  print('✅ Web Database Helper test completed successfully!');
}
