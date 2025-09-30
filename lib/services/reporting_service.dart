import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/patient_model.dart';
import '../models/diet_chart_model.dart';

class ReportingService {
  
  // Generate printable diet chart report
  Future<void> generatePrintableDietChart({
    required Patient patient,
    required DietChart dietChart,
    required BuildContext context,
  }) async {
    try {
      // Create a GlobalKey for the widget to be captured
      final GlobalKey repaintBoundaryKey = GlobalKey();
      
      // Show preview dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                AppBar(
                  title: const Text('Diet Chart Preview'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareDietChart(repaintBoundaryKey, patient, dietChart),
                    ),
                    IconButton(
                      icon: const Icon(Icons.print),
                      onPressed: () => _printDietChart(repaintBoundaryKey, patient, dietChart),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: RepaintBoundary(
                      key: repaintBoundaryKey,
                      child: _buildPrintableDietChart(patient, dietChart),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating report: $e')),
      );
    }
  }

  // Build the printable diet chart widget
  Widget _buildPrintableDietChart(Patient patient, DietChart dietChart) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(patient),
          const SizedBox(height: 24),
          
          // Patient Information
          _buildPatientInfo(patient),
          const SizedBox(height: 24),
          
          // Nutritional Analysis
          _buildNutritionalAnalysis(dietChart.nutritionalAnalysis),
          const SizedBox(height: 24),
          
          // Ayurvedic Recommendations
          _buildAyurvedicRecommendations(dietChart.ayurvedicRecommendations),
          const SizedBox(height: 24),
          
          // Weekly Meal Plan
          _buildWeeklyMealPlan(dietChart.mealPlan),
          const SizedBox(height: 24),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(Patient patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'AYURVEDIC DIET CHART',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalized Nutrition Plan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Patient: ${patient.namePseudonym}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Generated on: ${DateTime.now().toString().split(' ')[0]}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(Patient patient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PATIENT INFORMATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Name', patient.namePseudonym),
          _buildInfoRow('Age', '${patient.age} years'),
          _buildInfoRow('Gender', patient.gender),
          _buildInfoRow('Dosha Type', patient.doshaPrakritiAssessment),
          _buildInfoRow('Dietary Habits', patient.dietaryHabits),
          _buildInfoRow('Meal Frequency', '${patient.mealFrequencyPerDay} meals/day'),
          _buildInfoRow('Water Intake', '${patient.waterIntakeLiters}L/day'),
          _buildInfoRow('Physical Activity', patient.physicalActivityLevel),
          _buildInfoRow('Sleep Pattern', patient.sleepPatterns),
          _buildInfoRow('Stress Level', patient.stressLevels),
          _buildInfoRow('Allergies', patient.allergies),
          _buildInfoRow('Medical Conditions', patient.comorbidities),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  Widget _buildNutritionalAnalysis(NutritionalAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAILY NUTRITIONAL ANALYSIS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNutritionCard(
                  'Calories',
                  '${analysis.dailyCalories.toStringAsFixed(0)} kcal',
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNutritionCard(
                  'Protein',
                  '${analysis.dailyProtein.toStringAsFixed(1)}g',
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNutritionCard(
                  'Carbs',
                  '${analysis.dailyCarbs.toStringAsFixed(1)}g',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNutritionCard(
                  'Fat',
                  '${analysis.dailyFat.toStringAsFixed(1)}g',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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

  Widget _buildAyurvedicRecommendations(List<String> recommendations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AYURVEDIC RECOMMENDATIONS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...recommendations.map((recommendation) => 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                    size: 16,
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
    );
  }

  Widget _buildWeeklyMealPlan(Map<String, List<MealItem>> mealPlan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WEEKLY MEAL PLAN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...mealPlan.entries.map((entry) => 
            _buildDayMealPlan(entry.key, entry.value),
          ),
        ],
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...meals.map((meal) => 
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.mealType,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${meal.totalCalories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'DISCLAIMER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This diet chart is generated based on Ayurvedic principles and general nutritional guidelines. Please consult with a qualified Ayurvedic practitioner or healthcare provider before making significant dietary changes.',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Generated by ThingBots - Ayurvedic Diet Assistant',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Share diet chart
  Future<void> _shareDietChart(
    GlobalKey repaintBoundaryKey,
    Patient patient,
    DietChart dietChart,
  ) async {
    try {
      // Capture the widget as an image
      final RenderRepaintBoundary boundary = 
          repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/diet_chart_${patient.namePseudonym.replaceAll(' ', '_')}.png').create();
      await file.writeAsBytes(pngBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Diet Chart for ${patient.namePseudonym}',
        subject: 'Ayurvedic Diet Chart',
      );
    } catch (e) {
      debugPrint('Error sharing diet chart: $e');
    }
  }

  // Print diet chart
  Future<void> _printDietChart(
    GlobalKey repaintBoundaryKey,
    Patient patient,
    DietChart dietChart,
  ) async {
    try {
      // Capture the widget as an image
      final RenderRepaintBoundary boundary = 
          repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to documents directory for printing
      final documentsDir = await getApplicationDocumentsDirectory();
      final file = await File('${documentsDir.path}/diet_chart_${patient.namePseudonym.replaceAll(' ', '_')}.png').create();
      await file.writeAsBytes(pngBytes);

      // You can integrate with a printing service here
      // For now, we'll just show a success message
      debugPrint('Diet chart saved for printing: ${file.path}');
    } catch (e) {
      debugPrint('Error preparing diet chart for printing: $e');
    }
  }

  // Generate patient statistics report
  Future<Map<String, dynamic>> generatePatientStatisticsReport() async {
    // This would typically fetch data from the patient management service
    return {
      'totalPatients': 150,
      'newPatientsThisMonth': 25,
      'ageDistribution': {
        'children': 30,
        'adults': 80,
        'seniors': 40,
      },
      'doshaDistribution': {
        'Vata': 45,
        'Pitta': 50,
        'Kapha': 35,
        'Balanced': 20,
      },
      'dietaryHabitsDistribution': {
        'Vegetarian': 80,
        'Non-Vegetarian': 50,
        'Vegan': 15,
        'Other': 5,
      },
      'commonConditions': [
        'Diabetes',
        'Hypertension',
        'PCOS',
        'IBS',
        'Obesity',
      ],
    };
  }
}
