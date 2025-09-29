import 'package:flutter/material.dart';
import '../services/nutrition_service.dart';
import '../models/food_model.dart';
import '../models/nutritional_data_model.dart';
import '../app_theme.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final NutritionService _nutritionService = NutritionService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Dairy',
    'Fruit',
    'Vegetable',
    'Meat/Seafood',
    'Oil',
    'Grain',
    'Spice',
  ];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final foods = await _nutritionService.getAllFoods();
      if (mounted) {
        setState(() {
          _foods = foods;
          _filteredFoods = foods;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading foods: $e')),
        );
      }
    }
  }

  void _filterFoods() {
    setState(() {
      _filteredFoods = _foods.where((food) {
        final matchesSearch = food.foodNameEnglish
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || 
            food.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Database'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search foods...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) => _filterFoods(),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            _filterFoods();
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.3),
                          checkmarkColor: AppTheme.primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Results Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFoods.isEmpty
                    ? const Center(
                        child: Text(
                          'No foods found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Column(
                        children: [
                          // Demo data notice
                          if (_filteredFoods.any((food) => food.foodId.startsWith('DEMO')))
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                border: Border.all(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info, color: Colors.blue.shade600),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Showing demo data. Import CSV data to see full nutrition database.',
                                      style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Food list
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredFoods.length,
                              itemBuilder: (context, index) {
                                final food = _filteredFoods[index];
                                return FoodCard(
                                  food: food,
                                  onTap: () => _showFoodDetails(food),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  void _showFoodDetails(Food food) async {
    showDialog(
      context: context,
      builder: (context) => FoodDetailsDialog(food: food),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          food.foodNameEnglish,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${food.category}'),
            Text('Cuisine: ${food.cuisine}'),
            Text('Meal Type: ${food.mealType}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class FoodDetailsDialog extends StatefulWidget {
  final Food food;

  const FoodDetailsDialog({super.key, required this.food});

  @override
  State<FoodDetailsDialog> createState() => _FoodDetailsDialogState();
}

class _FoodDetailsDialogState extends State<FoodDetailsDialog> {
  NutritionalData? _nutritionalData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNutritionalData();
  }

  Future<void> _loadNutritionalData() async {
    try {
      final nutritionService = NutritionService();
      final data = await nutritionService.getNutritionalData(widget.food.foodId);
      setState(() {
        _nutritionalData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.food.foodNameEnglish,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Food Information
            _buildInfoSection('Food Information', [
              'Local Name: ${widget.food.foodNameLocal}',
              'Category: ${widget.food.category}',
              'Cuisine: ${widget.food.cuisine}',
              'Meal Type: ${widget.food.mealType}',
              'Serving Size: ${widget.food.servingSizeG}g',
            ]),
            
            const SizedBox(height: 16),
            
            // Ayurvedic Properties
            _buildInfoSection('Ayurvedic Properties', [
              'Rasa (Taste): ${widget.food.rasa}',
              'Virya (Energy): ${widget.food.virya}',
              'Vipaka (Post-digestive): ${widget.food.vipaka}',
              'Guna (Quality): ${widget.food.guna}',
              'Digestibility: ${widget.food.digestibility}',
              'Dosha Suitability: ${widget.food.doshaSuitability}',
            ]),
            
            const SizedBox(height: 16),
            
            // Nutritional Information
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_nutritionalData != null)
              _buildNutritionalSection()
            else
              const Text('Nutritional data not available'),
            
            const Spacer(),
            
            // Close Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(item),
        )),
      ],
    );
  }

  Widget _buildNutritionalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutritional Information (per 100g)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 3,
          children: [
            _buildNutritionItem('Calories', '${_nutritionalData!.caloriesPer100g.toStringAsFixed(1)} kcal'),
            _buildNutritionItem('Protein', '${_nutritionalData!.proteinGPer100g.toStringAsFixed(1)}g'),
            _buildNutritionItem('Fat', '${_nutritionalData!.fatGPer100g.toStringAsFixed(1)}g'),
            _buildNutritionItem('Carbs', '${_nutritionalData!.carbsGPer100g.toStringAsFixed(1)}g'),
            _buildNutritionItem('Fiber', '${_nutritionalData!.fiberGPer100g.toStringAsFixed(1)}g'),
            _buildNutritionItem('Iron', '${_nutritionalData!.ironMgPer100g.toStringAsFixed(1)}mg'),
            _buildNutritionItem('Calcium', '${_nutritionalData!.calciumMgPer100g.toStringAsFixed(1)}mg'),
            _buildNutritionItem('Potassium', '${_nutritionalData!.potassiumMgPer100g.toStringAsFixed(1)}mg'),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.subtleTextColor.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.subtleTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
