import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/comprehensive_data_service.dart';
import '../models/patient_model.dart';

class DietChartSummaryScreen extends StatelessWidget {
  final DietChartSummary chart;
  final Patient? patient;

  const DietChartSummaryScreen({
    super.key,
    required this.chart,
    this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Chart: ${chart.chartId}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print functionality coming soon')),
              );
            },
            tooltip: 'Print',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 16),
            
            // Patient Information Card
            if (patient != null) ...[
              _buildPatientInfoCard(context),
              const SizedBox(height: 16),
            ],
            
            // Nutritional Analysis Card
            _buildNutritionalAnalysisCard(context),
            const SizedBox(height: 16),
            
            // Clinical Notes Card
            if (chart.clinicalNotes.isNotEmpty) ...[
              _buildClinicalNotesCard(context),
              const SizedBox(height: 16),
            ],
            
            // Recommendations Card
            _buildRecommendationsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diet Chart Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chart ID: ${chart.chartId}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Date: ${chart.date.toString().split(' ')[0]}',
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
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BuildContext context) {
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
            _buildInfoRow('Name', patient!.namePseudonym),
            _buildInfoRow('Patient ID', patient!.patientId),
            _buildInfoRow('Age', '${patient!.age} years'),
            _buildInfoRow('Gender', patient!.gender),
            _buildInfoRow('Dosha Type', patient!.doshaPrakritiAssessment),
            _buildInfoRow('Dietary Habits', patient!.dietaryHabits),
            _buildInfoRow('Allergies', patient!.allergies),
            _buildInfoRow('Medical Conditions', patient!.comorbidities),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalAnalysisCard(BuildContext context) {
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
            const SizedBox(height: 16),
            
            // Main nutritional values
            Row(
              children: [
                Expanded(
                  child: _buildNutritionItem(
                    'Calories',
                    '${chart.totalCalories.toStringAsFixed(0)} kcal',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildNutritionItem(
                    'Protein',
                    '${chart.totalProtein.toStringAsFixed(1)}g',
                    Icons.fitness_center,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNutritionItem(
                    'Fat',
                    '${chart.totalFat.toStringAsFixed(1)}g',
                    Icons.opacity,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildNutritionItem(
                    'Carbs',
                    '${chart.totalCarbs.toStringAsFixed(1)}g',
                    Icons.grain,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNutritionItem(
                    'Fiber',
                    '${chart.totalFiber.toStringAsFixed(1)}g',
                    Icons.eco,
                    Colors.teal,
                  ),
                ),
                Expanded(
                  child: Container(), // Empty space for alignment
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalNotesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clinical Notes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    color: Colors.amber.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      chart.clinicalNotes,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber.shade800,
                      ),
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

  Widget _buildRecommendationsCard(BuildContext context) {
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
            
            // Generate recommendations based on nutritional data
            ..._generateRecommendations().map((recommendation) => 
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

  List<String> _generateRecommendations() {
    List<String> recommendations = [];
    
    // Calorie recommendations
    if (chart.totalCalories < 1200) {
      recommendations.add('Consider increasing calorie intake for better energy levels');
    } else if (chart.totalCalories > 2500) {
      recommendations.add('Monitor calorie intake to maintain healthy weight');
    }
    
    // Protein recommendations
    if (chart.totalProtein < 50) {
      recommendations.add('Increase protein intake for muscle health and recovery');
    } else if (chart.totalProtein > 100) {
      recommendations.add('Protein intake is adequate for most individuals');
    }
    
    // Fiber recommendations
    if (chart.totalFiber < 25) {
      recommendations.add('Increase fiber intake for better digestive health');
    }
    
    // Fat recommendations
    if (chart.totalFat < 30) {
      recommendations.add('Consider adding healthy fats for nutrient absorption');
    } else if (chart.totalFat > 80) {
      recommendations.add('Monitor fat intake for cardiovascular health');
    }
    
    // Patient-specific recommendations
    if (patient != null) {
      if (patient!.doshaPrakritiAssessment.toLowerCase().contains('vata')) {
        recommendations.add('Include warm, cooked foods to balance Vata dosha');
      }
      if (patient!.doshaPrakritiAssessment.toLowerCase().contains('pitta')) {
        recommendations.add('Include cooling foods to balance Pitta dosha');
      }
      if (patient!.doshaPrakritiAssessment.toLowerCase().contains('kapha')) {
        recommendations.add('Include light, warming foods to balance Kapha dosha');
      }
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Diet plan appears well-balanced. Continue current approach.');
    }
    
    return recommendations;
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
}
