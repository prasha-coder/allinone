import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../app_theme.dart';
import 'diet_chart_screen.dart';

class PatientInputScreen extends StatefulWidget {
  const PatientInputScreen({super.key});

  @override
  State<PatientInputScreen> createState() => _PatientInputScreenState();
}

class _PatientInputScreenState extends State<PatientInputScreen> {
  final _patientInputFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  
  String _selectedGender = 'Male';
  String _selectedDosha = 'Vata-Pitta';
  String _selectedDietaryHabits = 'Vegetarian';
  String _selectedMealFrequency = '3';
  String _selectedWaterIntake = '2.5';
  String _selectedActivityLevel = 'Moderate - 30 mins daily';
  String _selectedSleepPattern = '7-8 hours, good quality sleep';
  String _selectedStressLevel = 'Low to moderate';
  String _selectedBowelMovement = 'Regular, once daily';
  String _allergies = 'None';
  String _comorbidities = 'None';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _doshaTypes = [
    'Vata',
    'Pitta', 
    'Kapha',
    'Vata-Pitta',
    'Vata-Kapha',
    'Pitta-Kapha',
    'Vata-Pitta-Kapha (Balanced)'
  ];
  final List<String> _dietaryHabits = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Pescatarian'
  ];
  final List<String> _mealFrequencies = ['2', '3', '4', '5', '6'];
  final List<String> _waterIntakes = ['1.5', '2.0', '2.5', '3.0', '3.5', '4.0'];
  final List<String> _activityLevels = [
    'Sedentary - No exercise',
    'Light - 15 mins daily',
    'Moderate - 30 mins daily',
    'Active - 45 mins daily',
    'Very Active - 60+ mins daily'
  ];
  final List<String> _sleepPatterns = [
    '5-6 hours, poor quality',
    '6-7 hours, moderate quality',
    '7-8 hours, good quality sleep',
    '8+ hours, excellent quality'
  ];
  final List<String> _stressLevels = [
    'Very Low',
    'Low',
    'Low to moderate',
    'Moderate',
    'High',
    'Very High'
  ];
  final List<String> _bowelMovements = [
    'Irregular, constipation',
    'Regular, once daily',
    'Regular, twice daily',
    'Regular, 3+ times daily',
    'Irregular, diarrhea'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _generateDietChart() {
    if (_patientInputFormKey.currentState!.validate()) {
      final patient = Patient(
        patientId: 'PAT${DateTime.now().millisecondsSinceEpoch}',
        namePseudonym: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        contactInfo: _contactController.text.trim(),
        dietaryHabits: _selectedDietaryHabits,
        mealFrequencyPerDay: int.parse(_selectedMealFrequency),
        bowelMovements: _selectedBowelMovement,
        waterIntakeLiters: double.parse(_selectedWaterIntake),
        physicalActivityLevel: _selectedActivityLevel,
        sleepPatterns: _selectedSleepPattern,
        stressLevels: _selectedStressLevel,
        allergies: _allergies,
        comorbidities: _comorbidities,
        doshaPrakritiAssessment: _selectedDosha,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DietChartScreen(patient: patient),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _patientInputFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter Patient Details',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in the information to generate a personalized Ayurvedic diet chart',
                      style: TextStyle(
                        color: AppTheme.subtleTextColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Basic Information
              _buildSectionHeader('Basic Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Patient Name',
                hint: 'Enter full name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                hint: 'Enter age in years',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Please enter a valid age (1-120)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (value) => setState(() => _selectedGender = value!),
                icon: Icons.wc,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contactController,
                label: 'Contact Information',
                hint: 'Email or phone number',
                icon: Icons.contact_phone,
              ),

              const SizedBox(height: 24),

              // Ayurvedic Assessment
              _buildSectionHeader('Ayurvedic Assessment'),
              _buildDropdown(
                label: 'Dosha Type',
                value: _selectedDosha,
                items: _doshaTypes,
                onChanged: (value) => setState(() => _selectedDosha = value!),
                icon: Icons.psychology,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Dietary Habits',
                value: _selectedDietaryHabits,
                items: _dietaryHabits,
                onChanged: (value) => setState(() => _selectedDietaryHabits = value!),
                icon: Icons.restaurant,
              ),

              const SizedBox(height: 24),

              // Lifestyle Information
              _buildSectionHeader('Lifestyle Information'),
              _buildDropdown(
                label: 'Meal Frequency (per day)',
                value: _selectedMealFrequency,
                items: _mealFrequencies,
                onChanged: (value) => setState(() => _selectedMealFrequency = value!),
                icon: Icons.schedule,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Water Intake (Liters/day)',
                value: _selectedWaterIntake,
                items: _waterIntakes,
                onChanged: (value) => setState(() => _selectedWaterIntake = value!),
                icon: Icons.water_drop,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Physical Activity Level',
                value: _selectedActivityLevel,
                items: _activityLevels,
                onChanged: (value) => setState(() => _selectedActivityLevel = value!),
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Sleep Pattern',
                value: _selectedSleepPattern,
                items: _sleepPatterns,
                onChanged: (value) => setState(() => _selectedSleepPattern = value!),
                icon: Icons.bedtime,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Stress Level',
                value: _selectedStressLevel,
                items: _stressLevels,
                onChanged: (value) => setState(() => _selectedStressLevel = value!),
                icon: Icons.mood,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Bowel Movements',
                value: _selectedBowelMovement,
                items: _bowelMovements,
                onChanged: (value) => setState(() => _selectedBowelMovement = value!),
                icon: Icons.health_and_safety,
              ),

              const SizedBox(height: 24),

              // Medical Information
              _buildSectionHeader('Medical Information'),
              _buildTextField(
                controller: TextEditingController(text: _allergies),
                label: 'Allergies',
                hint: 'Enter any food allergies or "None"',
                icon: Icons.warning,
                onChanged: (value) => _allergies = value,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: TextEditingController(text: _comorbidities),
                label: 'Medical Conditions',
                hint: 'Enter any medical conditions or "None"',
                icon: Icons.medical_services,
                onChanged: (value) => _comorbidities = value,
              ),

              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _generateDietChart,
                  icon: const Icon(Icons.auto_awesome, size: 24),
                  label: const Text(
                    'Generate Personalized Diet Chart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
