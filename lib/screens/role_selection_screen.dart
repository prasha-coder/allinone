import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../app_theme.dart';
import 'doctor_login_screen.dart';
import 'patient_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // App Logo and Title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.spa,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  'ThingBots',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Ayurvedic Diet Assistant',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.subtleTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Choose your role to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.subtleTextColor,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Role Selection Cards
                ...UserRole.values.map((role) => _buildRoleCard(context, role)),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, UserRole role) {
    final isDoctor = role == UserRole.doctor;
    final title = isDoctor ? 'Healthcare Professional' : 'Patient/Client';
    final subtitle = isDoctor 
        ? 'Access patient management, diet chart generation, and comprehensive nutrition database'
        : 'View your diet plans, track nutrition, and access personalized recommendations';
    
    final features = isDoctor 
        ? [
            'Patient Management',
            'Diet Chart Generation', 
            'Nutrition Database',
            'Recipe Management',
            'Reporting & Analytics'
          ]
        : [
            'View Diet Charts',
            'Nutrition Tracking'
          ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _navigateToRole(context, role),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isDoctor 
                            ? Colors.blue.shade100 
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        isDoctor 
                            ? Icons.medical_services 
                            : Icons.person,
                        color: isDoctor 
                            ? Colors.blue.shade600 
                            : Colors.green.shade600,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Features
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDoctor 
                          ? Colors.blue.shade50 
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDoctor 
                            ? Colors.blue.shade200 
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDoctor 
                            ? Colors.blue.shade700 
                            : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRole(BuildContext context, UserRole role) {
    if (role == UserRole.doctor) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DoctorLoginScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PatientLoginScreen()),
      );
    }
  }
}