import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/comprehensive_data_service.dart';

class DietChartMealsScreen extends StatefulWidget {
  final String chartId;

  const DietChartMealsScreen({super.key, required this.chartId});

  @override
  State<DietChartMealsScreen> createState() => _DietChartMealsScreenState();
}

class _DietChartMealsScreenState extends State<DietChartMealsScreen> {
  final ComprehensiveDataService _dataService = ComprehensiveDataService();
  List<DietChartMeal> _meals = [];
  List<DietChartMeal> _filteredMeals = [];
  bool _isLoading = false;
  String _selectedMealTime = 'All';

  final List<String> _mealTimeOptions = [
    'All',
    'Breakfast',
    'Mid-morning',
    'Lunch',
    'Afternoon Snack',
    'Dinner',
    'Evening Snack',
  ];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataService.loadAllData();
      setState(() {
        _meals = _dataService.getMealsForChart(widget.chartId);
        _filteredMeals = _meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading meals: $e')),
        );
      }
    }
  }

  void _filterMeals() {
    setState(() {
      _filteredMeals = _meals.where((meal) {
        return _selectedMealTime == 'All' || meal.mealTime == _selectedMealTime;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals: ${widget.chartId}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMeals,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Meal Time Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _mealTimeOptions.length,
                itemBuilder: (context, index) {
                  final mealTime = _mealTimeOptions[index];
                  final isSelected = _selectedMealTime == mealTime;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(mealTime),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedMealTime = mealTime;
                        });
                        _filterMeals();
                      },
                      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Meals List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMeals.isEmpty
                    ? _buildEmptyState()
                    : _buildMealsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedMealTime != 'All'
                ? 'No meals found for $_selectedMealTime'
                : 'No meals found for this diet chart',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedMealTime != 'All'
                ? 'Try selecting a different meal time'
                : 'This diet chart may not have meal details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList() {
    // Group meals by meal time
    Map<String, List<DietChartMeal>> groupedMeals = {};
    for (final meal in _filteredMeals) {
      if (!groupedMeals.containsKey(meal.mealTime)) {
        groupedMeals[meal.mealTime] = [];
      }
      groupedMeals[meal.mealTime]!.add(meal);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupedMeals.length,
      itemBuilder: (context, index) {
        final mealTime = groupedMeals.keys.elementAt(index);
        final meals = groupedMeals[mealTime]!;
        
        return _buildMealTimeSection(mealTime, meals);
      },
    );
  }

  Widget _buildMealTimeSection(String mealTime, List<DietChartMeal> meals) {
    // Calculate totals for this meal time
    double totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
    double totalProtein = meals.fold(0, (sum, meal) => sum + meal.protein);
    double totalFat = meals.fold(0, (sum, meal) => sum + meal.fat);
    double totalCarbs = meals.fold(0, (sum, meal) => sum + meal.carbs);
    double totalFiber = meals.fold(0, (sum, meal) => sum + meal.fiber);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Time Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getMealTimeIcon(mealTime),
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealTime,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${meals.length} items • ${totalCalories.toStringAsFixed(0)} kcal',
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
            const SizedBox(height: 16),
            
            // Nutritional Summary
            Row(
              children: [
                _buildNutritionChip('Protein', '${totalProtein.toStringAsFixed(1)}g', Colors.blue),
                const SizedBox(width: 8),
                _buildNutritionChip('Fat', '${totalFat.toStringAsFixed(1)}g', Colors.orange),
                const SizedBox(width: 8),
                _buildNutritionChip('Carbs', '${totalCarbs.toStringAsFixed(1)}g', Colors.green),
                const SizedBox(width: 8),
                _buildNutritionChip('Fiber', '${totalFiber.toStringAsFixed(1)}g', Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            
            // Individual Items
            ...meals.map((meal) => _buildMealItem(meal)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem(DietChartMeal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                      _getItemName(meal.itemId, meal.itemType),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${meal.portion.toStringAsFixed(1)}g • ${meal.calories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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
                  meal.itemType,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Nutritional breakdown
          Row(
            children: [
              _buildMiniNutritionChip('P', '${meal.protein.toStringAsFixed(1)}g', Colors.blue),
              const SizedBox(width: 4),
              _buildMiniNutritionChip('F', '${meal.fat.toStringAsFixed(1)}g', Colors.orange),
              const SizedBox(width: 4),
              _buildMiniNutritionChip('C', '${meal.carbs.toStringAsFixed(1)}g', Colors.green),
              const SizedBox(width: 4),
              _buildMiniNutritionChip('Fi', '${meal.fiber.toStringAsFixed(1)}g', Colors.purple),
            ],
          ),
          
          // Ayurveda notes
          if (meal.ayurvedaNotes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.spa,
                    color: Colors.amber.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meal.ayurvedaNotes,
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
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMiniNutritionChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getMealTimeIcon(String mealTime) {
    switch (mealTime.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'mid-morning':
        return Icons.coffee;
      case 'lunch':
        return Icons.lunch_dining;
      case 'afternoon snack':
        return Icons.cookie;
      case 'dinner':
        return Icons.dinner_dining;
      case 'evening snack':
        return Icons.nightlight;
      default:
        return Icons.restaurant;
    }
  }

  String _getItemName(String itemId, String itemType) {
    if (itemType == 'Food') {
      final food = _dataService.getFoodById(itemId);
      return food?.foodNameEnglish ?? itemId;
    } else if (itemType == 'Recipe') {
      final recipe = _dataService.getRecipeById(itemId);
      return recipe?.recipeName ?? itemId;
    }
    return itemId;
  }
}
