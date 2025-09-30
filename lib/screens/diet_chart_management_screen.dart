import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/comprehensive_data_service.dart';
import '../models/patient_model.dart';
import 'diet_chart_summary_screen.dart';
import 'diet_chart_meals_screen.dart';

class DietChartManagementScreen extends StatefulWidget {
  const DietChartManagementScreen({super.key});

  @override
  State<DietChartManagementScreen> createState() => _DietChartManagementScreenState();
}

class _DietChartManagementScreenState extends State<DietChartManagementScreen> {
  final ComprehensiveDataService _dataService = ComprehensiveDataService();
  List<DietChartSummary> _dietCharts = [];
  List<DietChartSummary> _filteredCharts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Recent (Last 7 days)',
    'This Month',
    'High Calories (>2000)',
    'Low Calories (<1500)',
    'High Protein (>80g)',
    'Low Protein (<50g)',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataService.loadAllData();
      setState(() {
        _dietCharts = _dataService.dietChartSummaries;
        _filteredCharts = _dietCharts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _filterCharts() {
    setState(() {
      _filteredCharts = _dietCharts.where((chart) {
        // Search filter
        final patient = _dataService.getPatientById(chart.patientId);
        final matchesSearch = _searchQuery.isEmpty ||
            chart.chartId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            chart.patientId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (patient != null && patient.namePseudonym.toLowerCase().contains(_searchQuery.toLowerCase()));

        // Category filter
        bool matchesFilter = true;
        final now = DateTime.now();
        switch (_selectedFilter) {
          case 'Recent (Last 7 days)':
            matchesFilter = chart.date.isAfter(now.subtract(const Duration(days: 7)));
            break;
          case 'This Month':
            matchesFilter = chart.date.month == now.month && chart.date.year == now.year;
            break;
          case 'High Calories (>2000)':
            matchesFilter = chart.totalCalories > 2000;
            break;
          case 'Low Calories (<1500)':
            matchesFilter = chart.totalCalories < 1500;
            break;
          case 'High Protein (>80g)':
            matchesFilter = chart.totalProtein > 80;
            break;
          case 'Low Protein (<50g)':
            matchesFilter = chart.totalProtein < 50;
            break;
        }

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Chart Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(),
          
          // Statistics Cards
          _buildStatisticsCards(),
          
          // Diet Charts List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCharts.isEmpty
                    ? _buildEmptyState()
                    : _buildDietChartsList(),
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
              hintText: 'Search by chart ID, patient ID, or patient name...',
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
              _filterCharts();
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
                      _filterCharts();
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

  Widget _buildStatisticsCards() {
    final totalCharts = _dietCharts.length;
    final recentCharts = _dietCharts.where((chart) => 
      chart.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))
    ).length;
    final avgCalories = totalCharts > 0 
        ? _dietCharts.map((chart) => chart.totalCalories).reduce((a, b) => a + b) / totalCharts
        : 0.0;
    final avgProtein = totalCharts > 0
        ? _dietCharts.map((chart) => chart.totalProtein).reduce((a, b) => a + b) / totalCharts
        : 0.0;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Charts',
              totalCharts.toString(),
              Icons.assignment,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Recent (7 days)',
              recentCharts.toString(),
              Icons.trending_up,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Avg Calories',
              avgCalories.toStringAsFixed(0),
              Icons.local_fire_department,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Avg Protein',
              '${avgProtein.toStringAsFixed(0)}g',
              Icons.fitness_center,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8), // Reduced padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
            Icon(icon, color: color, size: 18), // Reduced icon size
            const SizedBox(height: 2), // Reduced spacing
            Text(
              value,
              style: TextStyle(
                fontSize: 14, // Reduced font size
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 9, // Reduced font size
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                ? 'No diet charts found matching your criteria'
                : 'No diet charts found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                ? 'Try adjusting your search or filter'
                : 'Generate diet charts for your patients',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietChartsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredCharts.length,
      itemBuilder: (context, index) {
        final chart = _filteredCharts[index];
        return _buildDietChartCard(chart);
      },
    );
  }

  Widget _buildDietChartCard(DietChartSummary chart) {
    final patient = _dataService.getPatientById(chart.patientId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showChartOptions(chart, patient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chart ID: ${chart.chartId}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Patient: ${patient?.namePseudonym ?? chart.patientId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'Date: ${chart.date.toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chart.totalCalories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Nutritional Summary
              Row(
                children: [
                  _buildNutritionChip('Protein', '${chart.totalProtein.toStringAsFixed(1)}g', Colors.blue),
                  const SizedBox(width: 8),
                  _buildNutritionChip('Fat', '${chart.totalFat.toStringAsFixed(1)}g', Colors.orange),
                  const SizedBox(width: 8),
                  _buildNutritionChip('Carbs', '${chart.totalCarbs.toStringAsFixed(1)}g', Colors.green),
                  const SizedBox(width: 8),
                  _buildNutritionChip('Fiber', '${chart.totalFiber.toStringAsFixed(1)}g', Colors.purple),
                ],
              ),
              
              if (chart.clinicalNotes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note,
                        color: Colors.amber.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chart.clinicalNotes,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showChartOptions(DietChartSummary chart, Patient? patient) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Diet Chart Options',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.summarize, color: Colors.blue),
              title: const Text('View Summary'),
              subtitle: const Text('Nutritional overview and clinical notes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DietChartSummaryScreen(chart: chart, patient: patient),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.green),
              title: const Text('View Meals'),
              subtitle: const Text('Detailed meal breakdown and ingredients'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DietChartMealsScreen(chartId: chart.chartId),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('Patient Profile'),
              subtitle: Text('View ${patient?.namePseudonym ?? 'patient'} details'),
              onTap: () {
                Navigator.pop(context);
                if (patient != null) {
                  _showPatientDetails(patient);
                }
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.print, color: Colors.purple),
              title: const Text('Print/Export'),
              subtitle: const Text('Generate printable diet chart'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print/Export functionality coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
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
              _buildDetailRow('Patient ID', patient.patientId),
              _buildDetailRow('Age', '${patient.age} years'),
              _buildDetailRow('Gender', patient.gender),
              _buildDetailRow('Dosha Type', patient.doshaPrakritiAssessment),
              _buildDetailRow('Dietary Habits', patient.dietaryHabits),
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
}
