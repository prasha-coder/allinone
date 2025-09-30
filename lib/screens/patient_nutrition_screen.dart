import 'package:flutter/material.dart';
import '../app_theme.dart';

class PatientNutritionScreen extends StatefulWidget {
  const PatientNutritionScreen({super.key});

  @override
  State<PatientNutritionScreen> createState() => _PatientNutritionScreenState();
}

class _PatientNutritionScreenState extends State<PatientNutritionScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Fruits', 'Vegetables', 'Grains', 'Dairy', 'Spices'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Guide'),
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
          
          // Nutrition Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNutritionCard(
                  'Apple',
                  'Rich in fiber and vitamin C',
                  'Fruits',
                  'Sweet',
                  'Cooling',
                  'Easy',
                  'Vata:Favorable;Pitta:Favorable;Kapha:Moderate',
                ),
                _buildNutritionCard(
                  'Spinach',
                  'High in iron and folate',
                  'Vegetables',
                  'Bitter',
                  'Cooling',
                  'Easy',
                  'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
                ),
                _buildNutritionCard(
                  'Rice',
                  'Good source of carbohydrates',
                  'Grains',
                  'Sweet',
                  'Cooling',
                  'Easy',
                  'Vata:Favorable;Pitta:Favorable;Kapha:Moderate',
                ),
                _buildNutritionCard(
                  'Milk',
                  'Complete protein source',
                  'Dairy',
                  'Sweet',
                  'Cooling',
                  'Easy',
                  'Vata:Favorable;Pitta:Favorable;Kapha:Unfavorable',
                ),
                _buildNutritionCard(
                  'Turmeric',
                  'Anti-inflammatory properties',
                  'Spices',
                  'Bitter',
                  'Heating',
                  'Easy',
                  'Vata:Favorable;Pitta:Favorable;Kapha:Favorable',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String name, String description, String category, String rasa, String virya, String digestibility, String doshaSuitability) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    category,
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPropertyChip('Rasa: $rasa', Colors.blue),
                _buildPropertyChip('Virya: $virya', Colors.orange),
                _buildPropertyChip('Digestibility: $digestibility', Colors.green),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dosha Suitability: $doshaSuitability',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
