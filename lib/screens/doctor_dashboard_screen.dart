import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../app_theme.dart';
import '../services/patient_management_service.dart';
import 'patient_management_screen.dart';
import 'nutrition_screen.dart';
import 'recipe_management_screen.dart';
import 'diet_chart_management_screen.dart';
import 'patient_input_screen.dart';
import 'profile_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;
  final PatientManagementService _patientService = PatientManagementService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _exportAllPatientData() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Exporting patient data...'),
            ],
          ),
        ),
      );

      // Get all patients
      final patients = await _patientService.getAllPatients();
      
      // Generate export content
      String exportContent = 'PATIENT DATA EXPORT\n';
      exportContent += 'Generated on: ${DateTime.now().toString()}\n';
      exportContent += 'Total Patients: ${patients.length}\n\n';
      
      for (int i = 0; i < patients.length; i++) {
        final patient = patients[i];
        exportContent += 'PATIENT ${i + 1}\n';
        exportContent += '==================\n';
        exportContent += 'ID: ${patient.patientId}\n';
        exportContent += 'Name: ${patient.namePseudonym}\n';
        exportContent += 'Age: ${patient.age}\n';
        exportContent += 'Gender: ${patient.gender}\n';
        exportContent += 'Contact: ${patient.contactInfo}\n';
        exportContent += 'Dietary Habits: ${patient.dietaryHabits}\n';
        exportContent += 'Meal Frequency: ${patient.mealFrequencyPerDay} per day\n';
        exportContent += 'Water Intake: ${patient.waterIntakeLiters}L per day\n';
        exportContent += 'Physical Activity: ${patient.physicalActivityLevel}\n';
        exportContent += 'Sleep Pattern: ${patient.sleepPatterns}\n';
        exportContent += 'Stress Level: ${patient.stressLevels}\n';
        exportContent += 'Bowel Movements: ${patient.bowelMovements}\n';
        exportContent += 'Allergies: ${patient.allergies}\n';
        exportContent += 'Comorbidities: ${patient.comorbidities}\n';
        exportContent += 'Dosha Assessment: ${patient.doshaPrakritiAssessment}\n\n';
      }

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Share the content
        await Share.share(
          exportContent,
          subject: 'Patient Data Export - ${DateTime.now().toString().split(' ')[0]}',
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient data exported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportAllPatientData,
            tooltip: 'Export All Patient Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/role-selection');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Diet Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppTheme.cardColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.subtleTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatientInputScreen(),
            ),
          );
        },
        tooltip: 'Add New Patient',
        child: const Icon(Icons.person_add),
      ) : null,
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const PatientManagementScreen();
      case 2:
        return const DietChartManagementScreen();
      case 3:
        return const NutritionScreen();
      case 4:
        return const RecipeManagementScreen();
      case 5:
        return const ProfileScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, Dr. Smith',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ayurvedic Diet Specialist',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Manage your patients and create personalized diet plans with our comprehensive Ayurvedic nutrition system.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          const Text(
            'Today\'s Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Patients',
                '156',
                Icons.people,
                Colors.blue,
              ),
              _buildStatCard(
                'New This Week',
                '8',
                Icons.person_add,
                Colors.green,
              ),
              _buildStatCard(
                'Diet Charts Generated',
                '24',
                Icons.assignment,
                Colors.orange,
              ),
              _buildStatCard(
                'Pending Reviews',
                '3',
                Icons.pending,
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildQuickActionCard(
            'Add New Patient',
            'Register a new patient and create their profile',
            Icons.person_add,
            Colors.blue,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientInputScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'Generate Diet Chart',
            'Create personalized diet plans for patients',
            Icons.assignment,
            Colors.green,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientInputScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'View Nutrition Database',
            'Access comprehensive food and nutrition data',
            Icons.restaurant,
            Colors.orange,
            () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'Manage Recipes',
            'Create and manage Ayurvedic recipes',
            Icons.menu_book,
            Colors.purple,
            () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          const SizedBox(height: 24),

          // Recent Activity
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActivityItem(
            'New patient registered: Priya Sharma',
            '2 hours ago',
            Icons.person_add,
            Colors.green,
          ),
          _buildActivityItem(
            'Diet chart generated for Rajesh Kumar',
            '4 hours ago',
            Icons.assignment,
            Colors.blue,
          ),
          _buildActivityItem(
            'Recipe added: Dal Tadka',
            '6 hours ago',
            Icons.menu_book,
            Colors.orange,
          ),
          _buildActivityItem(
            'Patient consultation completed: Amit Patel',
            '1 day ago',
            Icons.medical_services,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            Icon(
              icon,
              size: 28, // Reduced icon size
              color: color,
            ),
            const SizedBox(height: 6), // Reduced spacing
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Reduced font size
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11, // Reduced font size
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Allow text wrapping
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
