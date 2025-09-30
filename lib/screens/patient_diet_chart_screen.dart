import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/patient_model.dart';
import '../services/diet_chart_service.dart' as service;

class PatientDietChartScreen extends StatefulWidget {
  const PatientDietChartScreen({super.key});

  @override
  State<PatientDietChartScreen> createState() => _PatientDietChartScreenState();
}

class _PatientDietChartScreenState extends State<PatientDietChartScreen> {
  final service.DietChartService _dietChartService = service.DietChartService();
  service.DietChart? _dietChart;
  bool _isLoading = false;

  // Sample patient data for demo
  final Patient _samplePatient = Patient(
    patientId: 'PAT001',
    namePseudonym: 'Priya Sharma',
    age: 28,
    gender: 'Female',
    contactInfo: 'priya.sharma@email.com',
    dietaryHabits: 'Vegetarian',
    mealFrequencyPerDay: 3,
    bowelMovements: 'Regular, once daily',
    waterIntakeLiters: 2.5,
    physicalActivityLevel: 'Moderate - 30 mins daily',
    sleepPatterns: '7-8 hours, good quality sleep',
    stressLevels: 'Low to moderate',
    allergies: 'None',
    comorbidities: 'None',
    doshaPrakritiAssessment: 'Pitta-Kapha',
  );

  @override
  void initState() {
    super.initState();
    _loadDietChart();
  }

  Future<void> _loadDietChart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dietChart = await _dietChartService.generateDietChart(_samplePatient);
      if (mounted) {
        setState(() {
          _dietChart = dietChart;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading diet chart: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diet Plan'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDietChart,
            tooltip: 'Refresh Diet Plan',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dietChart == null
              ? const Center(child: Text('No diet plan available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Info Card
                      _buildPatientInfoCard(),
                      const SizedBox(height: 16),
                      
                      // Nutritional Analysis Card
                      _buildNutritionalAnalysisCard(),
                      const SizedBox(height: 16),
                      
                      // Ayurvedic Recommendations Card
                      _buildRecommendationsCard(),
                      const SizedBox(height: 16),
                      
                      // Weekly Meal Plan
                      _buildWeeklyMealPlan(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Health Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Name', _samplePatient.namePseudonym),
            _buildInfoRow('Age', '${_samplePatient.age} years'),
            _buildInfoRow('Gender', _samplePatient.gender),
            _buildInfoRow('Dosha Type', _samplePatient.doshaPrakritiAssessment),
            _buildInfoRow('Dietary Habits', _samplePatient.dietaryHabits),
            _buildInfoRow('Meal Frequency', '${_samplePatient.mealFrequencyPerDay} meals/day'),
            _buildInfoRow('Water Intake', '${_samplePatient.waterIntakeLiters}L/day'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalAnalysisCard() {
    final analysis = _dietChart!.nutritionalAnalysis;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Nutrition Goals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNutritionItem(
                    'Calories',
                    '${analysis.dailyCalories.toStringAsFixed(0)} kcal',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildNutritionItem(
                    'Protein',
                    '${analysis.dailyProtein.toStringAsFixed(1)}g',
                    Icons.fitness_center,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNutritionItem(
                    'Carbs',
                    '${analysis.dailyCarbs.toStringAsFixed(1)}g',
                    Icons.grain,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildNutritionItem(
                    'Fat',
                    '${analysis.dailyFat.toStringAsFixed(1)}g',
                    Icons.opacity,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ayurvedic Health Tips',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._dietChart!.ayurvedicRecommendations.map((recommendation) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyMealPlan() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Weekly Meal Plan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._dietChart!.mealPlan.entries.map((entry) => 
              _buildDayMealPlan(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayMealPlan(String day, List<service.MealItem> meals) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...meals.map((meal) => _buildMealItem(meal)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildMealItem(service.MealItem meal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.subtleTextColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meal.mealType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${meal.totalCalories.toStringAsFixed(0)} kcal',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: meal.foods.map((food) => 
              Chip(
                label: Text(
                  food.foodNameEnglish,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
