import 'package:flutter/material.dart';
import '../services/diet_chart_service.dart';
import '../models/patient_model.dart';
import '../app_theme.dart';

class DietChartScreen extends StatefulWidget {
  final Patient patient;

  const DietChartScreen({super.key, required this.patient});

  @override
  State<DietChartScreen> createState() => _DietChartScreenState();
}

class _DietChartScreenState extends State<DietChartScreen> {
  final DietChartService _dietChartService = DietChartService();
  DietChart? _dietChart;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateDietChart();
  }

  Future<void> _generateDietChart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dietChart = await _dietChartService.generateDietChart(widget.patient);
      setState(() {
        _dietChart = dietChart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating diet chart: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Chart - ${widget.patient.namePseudonym}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateDietChart,
            tooltip: 'Regenerate Diet Chart',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dietChart == null
              ? const Center(child: Text('No diet chart available'))
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
              'Patient Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Name', widget.patient.namePseudonym),
            _buildInfoRow('Age', '${widget.patient.age} years'),
            _buildInfoRow('Gender', widget.patient.gender),
            _buildInfoRow('Dosha Type', widget.patient.doshaPrakritiAssessment),
            _buildInfoRow('Dietary Habits', widget.patient.dietaryHabits),
            _buildInfoRow('Meal Frequency', '${widget.patient.mealFrequencyPerDay} meals/day'),
            _buildInfoRow('Water Intake', '${widget.patient.waterIntakeLiters}L/day'),
            _buildInfoRow('Physical Activity', widget.patient.physicalActivityLevel),
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
              'Daily Nutritional Analysis',
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
              'Ayurvedic Recommendations',
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
              'Weekly Meal Plan',
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

  Widget _buildDayMealPlan(String day, List<MealItem> meals) {
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

  Widget _buildMealItem(MealItem meal) {
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
