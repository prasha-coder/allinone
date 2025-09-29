# Project Structure

## 📁 Directory Overview

```
allinone/
├── 📱 Flutter Application
│   ├── lib/                    # Main application code
│   ├── android/               # Android platform files
│   ├── ios/                   # iOS platform files
│   ├── web/                   # Web platform files
│   ├── windows/               # Windows platform files
│   ├── linux/                 # Linux platform files
│   ├── macos/                 # macOS platform files
│   └── test/                  # Unit and widget tests
│
├── 🗄️ Nutrition Database
│   └── nutrition_database/    # CSV data files
│
└── 📚 Documentation
    ├── README.md              # Main project documentation
    ├── PROJECT_STRUCTURE.md   # This file
    └── NUTRITION_INTEGRATION.md # Nutrition database integration guide
```

## 📱 Flutter Application Structure

### `/lib/` - Main Application Code

```
lib/
├── main.dart                  # Application entry point
├── app_theme.dart            # Material Design theme configuration
├── firebase_options.dart     # Firebase configuration
│
├── 🔐 Authentication
│   ├── auth_gate.dart        # Authentication state management
│   ├── auth_screen.dart      # Login/signup UI
│   └── auth_service.dart     # Firebase authentication service
│
├── 📊 Models
│   ├── food_model.dart       # Food data model
│   ├── nutritional_data_model.dart # Nutritional information model
│   └── patient_model.dart    # Patient profile model
│
├── 🖥️ Screens
│   └── nutrition_screen.dart # Nutrition database UI
│
├── 🔧 Services
│   └── nutrition_service.dart # Firestore data operations
│
└── 🛠️ Utils
    └── data_importer.dart    # CSV to Firestore import utility
```

### Key Files Explained

#### `main.dart`
- **Purpose**: Application entry point and root widget
- **Features**: 
  - Firebase initialization
  - Provider setup for state management
  - Main navigation structure
  - Bottom navigation with Home, Nutrition, Profile tabs

#### `auth_service.dart`
- **Purpose**: Handles user authentication
- **Features**:
  - Firebase Authentication integration
  - Google Sign-In support
  - Demo mode for testing
  - User state management

#### `nutrition_screen.dart`
- **Purpose**: Main nutrition database interface
- **Features**:
  - Food search and filtering
  - Category-based browsing
  - Detailed food information display
  - Ayurvedic properties showcase

#### `nutrition_service.dart`
- **Purpose**: Data operations with Firestore
- **Features**:
  - CRUD operations for foods and nutritional data
  - Demo data fallback
  - Error handling and caching

## 🗄️ Nutrition Database Structure

### `/nutrition_database/` - CSV Data Files

```
nutrition_database/
├── Food_Database_10000.csv      # 10,000+ food items with Ayurvedic properties
├── Nutritional_Data_10000.csv   # Detailed nutritional information
├── Patient_Profile_1000.csv     # Patient health profiles
├── Diet_Chart_8000.csv          # Meal planning data
└── Recipe_Database_600.csv      # Cooking recipes and instructions
```

### Data Schema

#### Food Database (`Food_Database_10000.csv`)
- **FoodID**: Unique identifier
- **Food_Name_English**: English name
- **Food_Name_Local**: Local language name
- **Base_Item**: Base ingredient
- **Category**: Food classification (Dairy, Fruit, Vegetable, etc.)
- **Cuisine**: Regional cuisine type
- **Scientific_Name**: Botanical/scientific name
- **Description**: Food description
- **Meal_Type**: Breakfast, Lunch, Dinner, Snack
- **Serving_Size_g**: Standard serving size in grams
- **Rasa**: Ayurvedic taste (Sweet, Sour, Salty, Bitter, Pungent, Astringent)
- **Virya**: Ayurvedic potency (Heating, Cooling)
- **Vipaka**: Post-digestive effect
- **Guna**: Ayurvedic qualities (Light, Heavy, etc.)
- **Digestibility**: How easily digestible
- **Dosha_Suitability**: Vata, Pitta, Kapha compatibility
- **Allergen_Warnings**: Allergy information

#### Nutritional Data (`Nutritional_Data_10000.csv`)
- **FoodID**: Links to food database
- **Calories_per_100g**: Energy content
- **Protein_g_per_100g**: Protein content
- **Fat_g_per_100g**: Fat content
- **Carbs_g_per_100g**: Carbohydrate content
- **Fiber_g_per_100g**: Dietary fiber
- **Vit_A_IU_per_100g**: Vitamin A
- **Vit_C_mg_per_100g**: Vitamin C
- **Vit_D_ug_per_100g**: Vitamin D
- **Vit_E_mg_per_100g**: Vitamin E
- **Vit_B1_mg_per_100g**: Vitamin B1 (Thiamine)
- **Iron_mg_per_100g**: Iron content
- **Calcium_mg_per_100g**: Calcium content
- **Potassium_mg_per_100g**: Potassium content
- **Polyphenols_mg_per_100g**: Antioxidant compounds
- **Phytosterols_mg_per_100g**: Plant sterols

## 🔧 Configuration Files

### `pubspec.yaml`
- **Dependencies**: Flutter, Firebase, Provider, CSV parsing
- **Assets**: Nutrition database CSV files
- **Platform Support**: Web, Android, iOS, Windows, macOS, Linux

### `firebase_options.dart`
- **Firebase Configuration**: Project settings for all platforms
- **Project ID**: `nutrients1-36408159`
- **Services**: Authentication, Firestore, Analytics

### `analysis_options.yaml`
- **Linting Rules**: Code quality and style guidelines
- **Dart Analysis**: Static analysis configuration

## 🚀 Build and Deployment

### Platform-Specific Folders

#### `/android/`
- **Gradle Configuration**: Build settings and dependencies
- **Manifest**: App permissions and configuration
- **Resources**: Icons, themes, and assets

#### `/ios/`
- **Xcode Project**: iOS app configuration
- **Info.plist**: iOS app metadata
- **Assets**: App icons and launch screens

#### `/web/`
- **HTML Entry Point**: Web app initialization
- **Manifest**: PWA configuration
- **Icons**: Web app icons

#### `/windows/`, `/linux/`, `/macos/`
- **Platform-Specific**: Native desktop app configuration
- **CMake**: Build system configuration

## 📊 Data Flow

```
User Interface (Flutter)
        ↓
State Management (Provider)
        ↓
Services (NutritionService)
        ↓
Firebase Firestore
        ↓
CSV Data Import (DataImporter)
        ↓
Nutrition Database (CSV Files)
```

## 🔄 Development Workflow

1. **Local Development**: Run `flutter run -d chrome`
2. **Data Import**: Use the cloud upload button to import CSV data
3. **Testing**: Run `flutter test` for unit tests
4. **Building**: Use `flutter build web` for production builds
5. **Deployment**: Deploy to Firebase Hosting or other platforms

## 🛠️ Development Tools

- **Flutter SDK**: 3.35.4+
- **Dart SDK**: 3.5.4+
- **Firebase CLI**: For backend management
- **VS Code/Android Studio**: Recommended IDEs
- **Git**: Version control

## 📈 Performance Considerations

- **Pagination**: Large datasets are paginated for performance
- **Caching**: Local data caching for offline support
- **Batch Operations**: Bulk data import with progress tracking
- **Error Handling**: Comprehensive error management and fallbacks

## 🔒 Security Features

- **Firebase Security Rules**: Data access controls
- **Authentication**: Secure user authentication
- **Input Validation**: Data sanitization and validation
- **Privacy**: User data protection

---

This structure provides a scalable, maintainable foundation for the ThingBots Ayurvedic Diet Assistant application.
