import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/patient_management_service.dart';
import '../app_theme.dart';
import 'patient_input_screen.dart';
import 'diet_chart_screen.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final PatientManagementService _patientService = PatientManagementService();
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  Map<String, dynamic> _statistics = {};

  final List<String> _filterOptions = [
    'All',
    'Male',
    'Female',
    'Children (0-17)',
    'Adults (18-59)',
    'Seniors (60+)',
    'Vata',
    'Pitta',
    'Kapha',
    'Vegetarian',
    'Non-Vegetarian',
  ];

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _loadStatistics();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final patients = await _patientService.getAllPatients();
      if (mounted) {
        setState(() {
          _patients = patients;
          _filteredPatients = patients;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patients: $e')),
        );
      }
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _patientService.getPatientStatistics();
      if (mounted) {
        setState(() {
          _statistics = stats;
        });
      }
    } catch (e) {
      debugPrint('Error loading statistics: $e');
    }
  }

  void _filterPatients() {
    if (mounted) {
      setState(() {
        _filteredPatients = _patients.where((patient) {
        // Search filter
        final matchesSearch = _searchQuery.isEmpty ||
            patient.namePseudonym.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            patient.contactInfo.toLowerCase().contains(_searchQuery.toLowerCase());

        // Category filter
        bool matchesFilter = true;
        switch (_selectedFilter) {
          case 'Male':
            matchesFilter = patient.gender.toLowerCase() == 'male';
            break;
          case 'Female':
            matchesFilter = patient.gender.toLowerCase() == 'female';
            break;
          case 'Children (0-17)':
            matchesFilter = patient.age < 18;
            break;
          case 'Adults (18-59)':
            matchesFilter = patient.age >= 18 && patient.age < 60;
            break;
          case 'Seniors (60+)':
            matchesFilter = patient.age >= 60;
            break;
          case 'Vata':
            matchesFilter = patient.doshaPrakritiAssessment.toLowerCase().contains('vata');
            break;
          case 'Pitta':
            matchesFilter = patient.doshaPrakritiAssessment.toLowerCase().contains('pitta');
            break;
          case 'Kapha':
            matchesFilter = patient.doshaPrakritiAssessment.toLowerCase().contains('kapha');
            break;
          case 'Vegetarian':
            matchesFilter = patient.dietaryHabits.toLowerCase().contains('vegetarian');
            break;
          case 'Non-Vegetarian':
            matchesFilter = patient.dietaryHabits.toLowerCase().contains('non-vegetarian');
            break;
        }

        return matchesSearch && matchesFilter;
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatients,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statistics Cards
            _buildStatisticsCards(),
            
            // Search and Filter Bar
            _buildSearchAndFilterBar(),
            
            // Patients List
            _isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _filteredPatients.isEmpty
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: Text('No patients found')),
                      )
                    : _buildPatientsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatientInputScreen(),
            ),
          );
          if (result == true) {
            _loadPatients();
            _loadStatistics();
          }
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Container(
      height: 120, // Increased height to prevent overflow
      padding: const EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            'Total Patients',
            '${_statistics['totalPatients'] ?? 0}',
            Icons.people,
            Colors.blue,
          ),
          _buildStatCard(
            'Male',
            '${_statistics['malePatients'] ?? 0}',
            Icons.male,
            Colors.green,
          ),
          _buildStatCard(
            'Female',
            '${_statistics['femalePatients'] ?? 0}',
            Icons.female,
            Colors.pink,
          ),
          _buildStatCard(
            'Children',
            '${(_statistics['ageGroups'] as Map<String, dynamic>?)?['children'] ?? 0}',
            Icons.child_care,
            Colors.orange,
          ),
          _buildStatCard(
            'Adults',
            '${(_statistics['ageGroups'] as Map<String, dynamic>?)?['adults'] ?? 0}',
            Icons.person,
            Colors.purple,
          ),
          _buildStatCard(
            'Seniors',
            '${(_statistics['ageGroups'] as Map<String, dynamic>?)?['seniors'] ?? 0}',
            Icons.elderly,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 100, // Reduced width to prevent overflow
      height: 95, // Slightly increased height
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10), // Reduced padding further
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          Icon(icon, color: color, size: 20), // Reduced icon size
          const SizedBox(height: 4), // Reduced spacing
          Text(
            value,
            style: TextStyle(
              fontSize: 16, // Reduced font size
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10, // Reduced font size
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
            maxLines: 2, // Allow text wrapping
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterPatients();
            },
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _filterPatients();
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPatientsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = _filteredPatients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Icon(
            patient.gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          patient.namePseudonym,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${patient.age} years • ${patient.gender}'),
            Text('Dosha: ${patient.doshaPrakritiAssessment}'),
            Text('Diet: ${patient.dietaryHabits}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handlePatientAction(value, patient),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'diet_chart',
              child: Row(
                children: [
                  Icon(Icons.assignment),
                  SizedBox(width: 8),
                  Text('Generate Diet Chart'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _handlePatientAction('view', patient),
      ),
    );
  }

  void _handlePatientAction(String action, Patient patient) {
    switch (action) {
      case 'view':
        _showPatientDetails(patient);
        break;
      case 'diet_chart':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DietChartScreen(patient: patient),
          ),
        );
        break;
      case 'edit':
        _editPatient(patient);
        break;
      case 'delete':
        _deletePatient(patient);
        break;
    }
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(patient.namePseudonym),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Age', '${patient.age} years'),
              _buildDetailRow('Gender', patient.gender),
              _buildDetailRow('Contact', patient.contactInfo),
              _buildDetailRow('Dosha Type', patient.doshaPrakritiAssessment),
              _buildDetailRow('Dietary Habits', patient.dietaryHabits),
              _buildDetailRow('Meal Frequency', '${patient.mealFrequencyPerDay} meals/day'),
              _buildDetailRow('Water Intake', '${patient.waterIntakeLiters}L/day'),
              _buildDetailRow('Physical Activity', patient.physicalActivityLevel),
              _buildDetailRow('Sleep Pattern', patient.sleepPatterns),
              _buildDetailRow('Stress Level', patient.stressLevels),
              _buildDetailRow('Bowel Movements', patient.bowelMovements),
              _buildDetailRow('Allergies', patient.allergies),
              _buildDetailRow('Medical Conditions', patient.comorbidities),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DietChartScreen(patient: patient),
                ),
              );
            },
            child: const Text('Generate Diet Chart'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  void _editPatient(Patient patient) {
    // Navigate to edit screen (reuse PatientInputScreen with pre-filled data)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientInputScreen(),
      ),
    );
  }

  void _deletePatient(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.namePseudonym}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await _patientService.deletePatient(patient.patientId);
                if (mounted) {
                  navigator.pop();
                  _loadPatients();
                  _loadStatistics();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Patient deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error deleting patient: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
