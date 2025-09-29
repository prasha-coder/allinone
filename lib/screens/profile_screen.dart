import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service_new.dart';
import '../app_theme.dart';
import '../services/nutrition_service.dart';
import '../models/patient_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final NutritionService _nutritionService = NutritionService();
  List<Patient> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final patients = await _nutritionService.getAllPatients();
      if (mounted) {
        setState(() {
          _patients = patients;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Error loading patients: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceNew>(context);
    final user = authService.user;
    
    debugPrint('ProfileScreen: Building with user: ${user?.displayName}');

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            _buildUserProfileHeader(user),
            const SizedBox(height: 24),

            // Health Overview Section
            _buildHealthOverviewSection(),
            const SizedBox(height: 24),

            // Patient Database Section
            _buildPatientDatabaseSection(),
            const SizedBox(height: 24),

            // App Information Section
            _buildAppInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(dynamic user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),

            // User Information
            Text(
              user?.displayName ?? 'Demo User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              user?.email ?? 'demo@nutrients1-36408159.firebaseapp.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.subtleTextColor,
              ),
            ),
            const SizedBox(height: 16),

            // User Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Foods', '10,000+', Icons.restaurant),
                _buildStatItem('Patients', '1,000+', Icons.people),
                _buildStatItem('Recipes', '600+', Icons.menu_book),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.subtleTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthOverviewSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Health Metrics
            _buildHealthMetric('Dietary Habits', 'Balanced Ayurvedic Diet', Icons.restaurant_menu),
            _buildHealthMetric('Physical Activity', 'Moderate Exercise', Icons.fitness_center),
            _buildHealthMetric('Sleep Pattern', '7-8 hours daily', Icons.bedtime),
            _buildHealthMetric('Stress Level', 'Low to Moderate', Icons.psychology),
            _buildHealthMetric('Water Intake', '2-3 liters daily', Icons.water_drop),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.subtleTextColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.subtleTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDatabaseSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Patient Database',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_patients.isEmpty)
              _buildNoPatientsMessage()
            else
              _buildPatientsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPatientsMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No patient data available',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Import CSV data to see patient profiles and health information.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsList() {
    return Column(
      children: [
        // Show first 3 patients as examples
        ...(_patients.take(3).map((patient) => _buildPatientCard(patient))),
        if (_patients.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '... and ${_patients.length - 3} more patients',
              style: const TextStyle(
                color: AppTheme.subtleTextColor,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor,
            radius: 20,
            child: Text(
              patient.namePseudonym.isNotEmpty 
                  ? patient.namePseudonym[0].toUpperCase()
                  : 'P',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.namePseudonym.isNotEmpty 
                      ? patient.namePseudonym 
                      : 'Anonymous Patient',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${patient.age} years • ${patient.gender}',
                  style: const TextStyle(
                    color: AppTheme.subtleTextColor,
                    fontSize: 12,
                  ),
                ),
                if (patient.doshaPrakritiAssessment.isNotEmpty)
                  Text(
                    'Dosha: ${patient.doshaPrakritiAssessment}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'App Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoRow('App Version', '1.0.0'),
            _buildInfoRow('Firebase Project', 'nutrients1-36408159'),
            _buildInfoRow('Database', 'Firestore'),
            _buildInfoRow('Authentication', 'Firebase Auth'),
            _buildInfoRow('Platform', 'Flutter Web'),
            _buildInfoRow('Last Updated', 'September 2025'),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.spa,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ThingBots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ayurvedic Diet Assistant',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.subtleTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
