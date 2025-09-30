import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sih_2/services/auth_service_new.dart';
import 'package:sih_2/app_theme.dart';
import 'package:sih_2/firebase_options.dart';
import 'package:sih_2/screens/nutrition_screen.dart';
import 'package:sih_2/screens/profile_screen.dart';
import 'package:sih_2/screens/patient_input_screen.dart';
import 'package:sih_2/screens/patient_management_screen.dart';
import 'package:sih_2/screens/recipe_management_screen.dart';
import 'package:sih_2/screens/role_selection_screen.dart';
import 'package:sih_2/screens/doctor_dashboard_screen.dart';
import 'package:sih_2/screens/patient_dashboard_screen.dart';
import 'package:sih_2/utils/data_importer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthServiceNew(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThingBots - Ayurvedic Diet Assistant',
      theme: AppTheme.theme,
      home: const RoleSelectionScreen(),
      routes: {
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/doctor-dashboard': (context) => const DoctorDashboardScreen(),
        '/patient-dashboard': (context) => const PatientDashboardScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceNew>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThingBots - Ayurvedic Diet Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
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
        onPressed: _importNutritionData,
        tooltip: 'Import Nutrition Data',
        child: const Icon(Icons.cloud_upload),
      ) : null,
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return const NutritionScreen();
      case 2:
        return const PatientManagementScreen();
      case 3:
        return const RecipeManagementScreen();
      case 4:
        return _buildProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.spa,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to ThingBots!',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Comprehensive Ayurvedic Diet Management System',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.subtleTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Quick Actions
          const Text(
            'Quick Actions',
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
            childAspectRatio: 1.2,
            children: [
              _buildQuickActionCard(
                'Generate Diet Chart',
                Icons.assignment,
                Colors.green,
                () => _generateSampleDietChart(),
              ),
              _buildQuickActionCard(
                'Patient Management',
                Icons.people,
                Colors.blue,
                () => setState(() => _selectedIndex = 2),
              ),
              _buildQuickActionCard(
                'Nutrition Database',
                Icons.restaurant,
                Colors.orange,
                () => setState(() => _selectedIndex = 1),
              ),
              _buildQuickActionCard(
                'Recipe Management',
                Icons.menu_book,
                Colors.purple,
                () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Features Overview
          const Text(
            'Key Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            'Scientifically Calculated Nutrition',
            'Age and gender-specific nutritional requirements with Ayurvedic principles',
            Icons.science,
            Colors.teal,
          ),
          const SizedBox(height: 12),
          
          _buildFeatureCard(
            '8,000+ Food Database',
            'Comprehensive database covering Indian, multicultural, and international cuisines',
            Icons.storage,
            Colors.indigo,
          ),
          const SizedBox(height: 12),
          
          _buildFeatureCard(
            'Automated Diet Charts',
            'AI-powered diet chart generation with Ayurveda-compliant meal plans',
            Icons.auto_awesome,
            Colors.amber,
          ),
          const SizedBox(height: 12),
          
          _buildFeatureCard(
            'Patient Management',
            'Complete patient profiles with health parameters and medical history',
            Icons.medical_services,
            Colors.red,
          ),
          const SizedBox(height: 12),
          
          _buildFeatureCard(
            'Recipe-Based Analysis',
            'Automated nutrient analysis for recipes with detailed nutritional breakdown',
            Icons.analytics,
            Colors.pink,
          ),
          const SizedBox(height: 12),
          
          _buildFeatureCard(
            'Reporting & Export',
            'Printable diet charts and comprehensive reports for patient handouts',
            Icons.print,
            Colors.brown,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color) {
    return Card(
      child: Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return const ProfileScreen();
  }

  Future<void> _importNutritionData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Importing nutrition data...'),
          ],
        ),
      ),
    );

    try {
      final dataImporter = DataImporter();
      await dataImporter.importAllData();
      
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nutrition data imported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _generateSampleDietChart() {
    // Navigate to patient input screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientInputScreen(),
      ),
    );
  }
}
