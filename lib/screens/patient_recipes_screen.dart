import 'package:flutter/material.dart';
import '../app_theme.dart';

class PatientRecipesScreen extends StatefulWidget {
  const PatientRecipesScreen({super.key});

  @override
  State<PatientRecipesScreen> createState() => _PatientRecipesScreenState();
}

class _PatientRecipesScreenState extends State<PatientRecipesScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Recipes'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
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
                      },
                      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Recipes Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildRecipeCard(
                  'Dal Tadka',
                  'Traditional Indian lentil curry with aromatic tempering',
                  'Lunch',
                  '30 min',
                  '4 servings',
                  'Easy',
                  ['Toor Dal', 'Onion', 'Tomato', 'Spices'],
                ),
                _buildRecipeCard(
                  'Palak Paneer',
                  'Cottage cheese in creamy spinach gravy',
                  'Lunch',
                  '25 min',
                  '4 servings',
                  'Medium',
                  ['Spinach', 'Paneer', 'Onion', 'Tomato'],
                ),
                _buildRecipeCard(
                  'Oats Porridge',
                  'Healthy breakfast with nuts and fruits',
                  'Breakfast',
                  '15 min',
                  '2 servings',
                  'Easy',
                  ['Oats', 'Milk', 'Nuts', 'Fruits'],
                ),
                _buildRecipeCard(
                  'Vegetable Soup',
                  'Light and nutritious soup for dinner',
                  'Dinner',
                  '20 min',
                  '3 servings',
                  'Easy',
                  ['Mixed Vegetables', 'Herbs', 'Spices'],
                ),
                _buildRecipeCard(
                  'Fruit Salad',
                  'Fresh and healthy snack option',
                  'Snacks',
                  '10 min',
                  '2 servings',
                  'Easy',
                  ['Mixed Fruits', 'Honey', 'Lemon'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String name, String description, String mealType, String time, String servings, String difficulty, List<String> ingredients) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showRecipeDetails(name, description, mealType, time, servings, difficulty, ingredients),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mealType,
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
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(Icons.access_time, time, Colors.blue),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.people, servings, Colors.green),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.star, difficulty, Colors.orange),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Ingredients: ${ingredients.join(', ')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(String name, String description, String mealType, String time, String servings, String difficulty, List<String> ingredients) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(description),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(Icons.access_time, time, Colors.blue),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.people, servings, Colors.green),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.star, difficulty, Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...ingredients.map((ingredient) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Text('• '),
                      Expanded(child: Text(ingredient)),
                    ],
                  ),
                ),
              ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added $name to your meal plan')),
              );
            },
            child: const Text('Add to Meal Plan'),
          ),
        ],
      ),
    );
  }
}
