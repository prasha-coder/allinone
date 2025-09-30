import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../app_theme.dart';
import '../models/patient_model.dart';
import '../services/diet_chart_service.dart';
import 'patient_diet_chart_screen.dart';
import 'patient_nutrition_screen.dart';
import 'patient_recipes_screen.dart';
import 'patient_profile_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  int _selectedIndex = 0;
  final DietChartService _dietChartService = DietChartService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _exportMyData() async {
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
              Text('Exporting your data...'),
            ],
          ),
        ),
      );

      // Sample patient data (in real app, this would be the logged-in patient)
      final samplePatient = Patient(
        patientId: 'PATIENT_001',
        namePseudonym: 'John Doe',
        age: 35,
        gender: 'Male',
        contactInfo: 'john.doe@email.com',
        dietaryHabits: 'Vegetarian, prefers home-cooked meals',
        mealFrequencyPerDay: 3,
        bowelMovements: 'Regular, once daily',
        waterIntakeLiters: 2.5,
        physicalActivityLevel: 'Moderate - 30 mins daily',
        sleepPatterns: '7-8 hours, good quality sleep',
        stressLevels: 'Low to moderate',
        allergies: 'None known',
        comorbidities: 'None',
        doshaPrakritiAssessment: 'Pitta-Kapha dominant',
      );

      // Get diet chart data
      DietChart? dietChart;
      try {
        dietChart = await _dietChartService.generateDietChart(samplePatient);
      } catch (e) {
        debugPrint('Could not load diet chart: $e');
      }

      // Generate export content
      String exportContent = 'MY HEALTH DATA EXPORT\n';
      exportContent += 'Generated on: ${DateTime.now().toString()}\n\n';
      
      // Personal Information
      exportContent += 'PERSONAL INFORMATION\n';
      exportContent += '====================\n';
      exportContent += 'Patient ID: ${samplePatient.patientId}\n';
      exportContent += 'Name: ${samplePatient.namePseudonym}\n';
      exportContent += 'Age: ${samplePatient.age}\n';
      exportContent += 'Gender: ${samplePatient.gender}\n';
      exportContent += 'Contact: ${samplePatient.contactInfo}\n\n';

      // Health Information
      exportContent += 'HEALTH INFORMATION\n';
      exportContent += '==================\n';
      exportContent += 'Dietary Habits: ${samplePatient.dietaryHabits}\n';
      exportContent += 'Meal Frequency: ${samplePatient.mealFrequencyPerDay} per day\n';
      exportContent += 'Water Intake: ${samplePatient.waterIntakeLiters}L per day\n';
      exportContent += 'Physical Activity: ${samplePatient.physicalActivityLevel}\n';
      exportContent += 'Sleep Pattern: ${samplePatient.sleepPatterns}\n';
      exportContent += 'Stress Level: ${samplePatient.stressLevels}\n';
      exportContent += 'Bowel Movements: ${samplePatient.bowelMovements}\n';
      exportContent += 'Allergies: ${samplePatient.allergies}\n';
      exportContent += 'Comorbidities: ${samplePatient.comorbidities}\n';
      exportContent += 'Dosha Assessment: ${samplePatient.doshaPrakritiAssessment}\n\n';

      // Diet Chart Information
      if (dietChart != null) {
        exportContent += 'DIET CHART & APPOINTMENTS\n';
        exportContent += '========================\n';
        exportContent += 'Patient ID: ${dietChart.patientId}\n';
        exportContent += 'Patient Name: ${dietChart.patientName}\n';
        exportContent += 'Dosha Type: ${dietChart.doshaType}\n';
        exportContent += 'Generated Date: ${dietChart.generatedDate}\n';
        exportContent += 'Valid Until: ${dietChart.validUntil}\n\n';

        // Meal details
        int mealCount = 0;
        for (final entry in dietChart.mealPlan.entries) {
          final mealType = entry.key;
          final meals = entry.value;
          
          for (final meal in meals) {
            mealCount++;
            exportContent += 'MEAL $mealCount: $mealType\n';
            exportContent += 'Food Items: ${meal.foods.map((f) => f.foodNameEnglish).join(', ')}\n';
            exportContent += 'Calories: ${meal.totalCalories}\n';
            exportContent += 'Protein: ${meal.totalProtein}g\n';
            exportContent += 'Carbs: ${meal.totalCarbs}g\n';
            exportContent += 'Fat: ${meal.totalFat}g\n';
            exportContent += 'Fiber: ${meal.totalFiber}g\n\n';
          }
        }

        // Nutritional Summary
        exportContent += 'NUTRITIONAL SUMMARY\n';
        exportContent += '===================\n';
        exportContent += 'Daily Calories: ${dietChart.nutritionalAnalysis.dailyCalories}\n';
        exportContent += 'Protein: ${dietChart.nutritionalAnalysis.dailyProtein}g\n';
        exportContent += 'Carbs: ${dietChart.nutritionalAnalysis.dailyCarbs}g\n';
        exportContent += 'Fat: ${dietChart.nutritionalAnalysis.dailyFat}g\n';
        exportContent += 'Fiber: ${dietChart.nutritionalAnalysis.dailyFiber}g\n\n';

        // Ayurvedic Recommendations
        if (dietChart.ayurvedicRecommendations.isNotEmpty) {
          exportContent += 'AYURVEDIC RECOMMENDATIONS\n';
          exportContent += '========================\n';
          for (int i = 0; i < dietChart.ayurvedicRecommendations.length; i++) {
            exportContent += '${i + 1}. ${dietChart.ayurvedicRecommendations[i]}\n';
          }
          exportContent += '\n';
        }
      } else {
        exportContent += 'DIET CHART & APPOINTMENTS\n';
        exportContent += '========================\n';
        exportContent += 'No diet chart available at this time.\n';
        exportContent += 'Please contact your doctor to generate a personalized diet plan.\n\n';
      }

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Share the content
        await Share.share(
          exportContent,
          subject: 'My Health Data - ${DateTime.now().toString().split(' ')[0]}',
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your data exported successfully!'),
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
        title: const Text('My Health Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportMyData,
            tooltip: 'Export My Data',
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
            icon: Icon(Icons.assignment),
            label: 'My Diet Plan',
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
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const PatientDietChartScreen();
      case 2:
        return const PatientNutritionScreen();
      case 3:
        return const PatientRecipesScreen();
      case 4:
        return const PatientProfileScreen();
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
                colors: [Colors.green.shade600, Colors.green.shade500],
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
                        Icons.person,
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
                            'Welcome, Priya Sharma',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Patient ID: PAT001',
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
                  'Track your health journey with personalized Ayurvedic diet plans and nutrition guidance.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Health Overview
          const Text(
            'Health Overview',
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
              _buildHealthCard(
                'Current Diet Plan',
                'Active',
                Icons.assignment,
                Colors.green,
              ),
              _buildHealthCard(
                'Next Appointment',
                'Dec 15, 2024',
                Icons.calendar_today,
                Colors.blue,
              ),
              _buildHealthCard(
                'Water Intake Today',
                '2.5L / 3L',
                Icons.water_drop,
                Colors.cyan,
              ),
              _buildHealthCard(
                'Meals Completed',
                '2 / 3',
                Icons.restaurant,
                Colors.orange,
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
            'View My Diet Plan',
            'Check your personalized diet chart and meal recommendations',
            Icons.assignment,
            Colors.green,
            () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'Track Nutrition',
            'Monitor your daily nutrition intake and progress',
            Icons.analytics,
            Colors.blue,
            () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'Browse Recipes',
            'Discover healthy Ayurvedic recipes for your diet plan',
            Icons.menu_book,
            Colors.orange,
            () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuickActionCard(
            'Book Appointment',
            'Schedule your next consultation with your doctor',
            Icons.calendar_today,
            Colors.purple,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact your doctor to book an appointment'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Today's Recommendations
          const Text(
            'Today\'s Recommendations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRecommendationCard(
            'Morning Routine',
            'Start your day with warm water and light stretching',
            Icons.wb_sunny,
            Colors.amber,
          ),
          _buildRecommendationCard(
            'Lunch Suggestion',
            'Include more green vegetables in your lunch today',
            Icons.lunch_dining,
            Colors.green,
          ),
          _buildRecommendationCard(
            'Evening Activity',
            'Take a 15-minute walk after dinner',
            Icons.directions_walk,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
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
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
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

  Widget _buildRecommendationCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
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
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: Icon(
          Icons.check_circle_outline,
          color: Colors.green.shade400,
        ),
      ),
    );
  }
}
