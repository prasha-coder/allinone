# Nutrition Database Integration

## Overview
This Flutter app has been successfully integrated with the comprehensive nutrition database from the [nutri12 repository](https://github.com/prasha-coder/nutri12.git).

## Database Structure

### 1. Food Database (10,000+ items)
- **Food ID**: Unique identifier
- **Food Names**: English and local names
- **Category**: Dairy, Fruit, Vegetable, Meat/Seafood, Oil, Grain, Spice
- **Cuisine**: African, Chinese, Indian, Mediterranean, etc.
- **Ayurvedic Properties**: Rasa, Virya, Vipaka, Guna, Digestibility
- **Dosha Suitability**: Vata, Pitta, Kapha compatibility
- **Allergen Warnings**: Common allergens

### 2. Nutritional Data (10,000+ entries)
- **Macronutrients**: Calories, Protein, Fat, Carbs, Fiber
- **Vitamins**: A, C, D, E, B1
- **Minerals**: Iron, Calcium, Potassium
- **Phytonutrients**: Polyphenols, Phytosterols

### 3. Patient Profiles (1,000+ profiles)
- **Demographics**: Age, Gender, Contact Info
- **Lifestyle**: Dietary habits, Physical activity, Sleep patterns
- **Health**: Allergies, Comorbidities, Stress levels
- **Ayurvedic Assessment**: Dosha Prakriti evaluation

## Features Implemented

### ✅ Data Models
- `Food` model with Ayurvedic properties
- `NutritionalData` model with comprehensive nutrition info
- `Patient` model for user profiles

### ✅ Firebase Integration
- Firestore database setup
- Data import functionality
- Real-time data access

### ✅ User Interface
- **Home Screen**: Welcome interface with data import option
- **Nutrition Screen**: Search and filter foods by category
- **Food Details**: Comprehensive view with nutritional information
- **Ayurvedic Properties**: Display of traditional medicine properties

### ✅ Data Import
- CSV parsing and import to Firestore
- Batch processing for large datasets
- Progress tracking and error handling

## How to Use

1. **Import Data**: Click the cloud upload button on the home screen
2. **Browse Foods**: Navigate to the Nutrition tab
3. **Search**: Use the search bar to find specific foods
4. **Filter**: Use category chips to filter by food type
5. **View Details**: Tap any food to see comprehensive information

## Firebase Collections

- `foods`: Food database with Ayurvedic properties
- `nutritional_data`: Nutritional information per 100g
- `patients`: User profiles and health data

## Data Sources

All data is sourced from the [nutri12 repository](https://github.com/prasha-coder/nutri12.git) which contains:
- `Food_Database_10000.csv`
- `Nutritional_Data_10000.csv`
- `Patient_Profile_1000.csv`
- `Diet_Charts_Meals_8000rows.csv`
- `Diet_Charts_Summary_2000.csv`
- `Recipe_Database_600.csv`

## Technical Implementation

- **Flutter**: Cross-platform mobile/web app
- **Firebase**: Backend-as-a-Service with Firestore
- **Provider**: State management
- **Material Design**: Modern UI components

## Next Steps

- Implement recipe recommendations
- Add diet plan generation
- Create patient profile management
- Add meal planning features
- Implement dosha-based recommendations

## Firebase Project
Connected to: `nutrients1-36408159`
