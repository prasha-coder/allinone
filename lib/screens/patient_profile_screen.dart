import 'package:flutter/material.dart';
import '../app_theme.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Priya Sharma',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient ID: PAT001',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Active Patient',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Personal Information
            _buildSectionCard(
              'Personal Information',
              [
                _buildInfoRow('Full Name', 'Priya Sharma'),
                _buildInfoRow('Age', '28 years'),
                _buildInfoRow('Gender', 'Female'),
                _buildInfoRow('Contact', 'priya.sharma@email.com'),
                _buildInfoRow('Patient Since', 'January 2024'),
              ],
            ),
            const SizedBox(height: 16),

            // Health Information
            _buildSectionCard(
              'Health Information',
              [
                _buildInfoRow('Dosha Type', 'Pitta-Kapha'),
                _buildInfoRow('Dietary Habits', 'Vegetarian'),
                _buildInfoRow('Allergies', 'None'),
                _buildInfoRow('Medical Conditions', 'None'),
                _buildInfoRow('Current Diet Plan', 'Active'),
              ],
            ),
            const SizedBox(height: 16),

            // Lifestyle Information
            _buildSectionCard(
              'Lifestyle Information',
              [
                _buildInfoRow('Meal Frequency', '3 meals/day'),
                _buildInfoRow('Water Intake', '2.5L/day'),
                _buildInfoRow('Physical Activity', 'Moderate - 30 mins daily'),
                _buildInfoRow('Sleep Pattern', '7-8 hours, good quality'),
                _buildInfoRow('Stress Level', 'Low to moderate'),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Actions
            _buildSectionCard(
              'Quick Actions',
              [
                _buildActionRow(
                  'Edit Profile',
                  Icons.edit,
                  Colors.blue,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact your doctor to update profile')),
                    );
                  },
                ),
                _buildActionRow(
                  'Download Diet Plan',
                  Icons.download,
                  Colors.green,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Diet plan downloaded')),
                    );
                  },
                ),
                _buildActionRow(
                  'Book Appointment',
                  Icons.calendar_today,
                  Colors.orange,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact your doctor to book appointment')),
                    );
                  },
                ),
                _buildActionRow(
                  'Contact Support',
                  Icons.support_agent,
                  Colors.purple,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact: patient-support@thingbots.com')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Health Progress
            _buildSectionCard(
              'Health Progress',
              [
                _buildProgressRow('Weight Management', 0.7, Colors.blue),
                _buildProgressRow('Nutrition Goals', 0.8, Colors.green),
                _buildProgressRow('Exercise Routine', 0.6, Colors.orange),
                _buildProgressRow('Sleep Quality', 0.9, Colors.purple),
              ],
            ),
            const SizedBox(height: 16),

            // Emergency Contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emergency,
                        color: Colors.red.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Emergency Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dr. Rajesh Kumar - +91 98765 43210',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
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

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
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

  Widget _buildActionRow(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String title, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}
