# ThingBots - Ayurvedic Diet Assistant

A comprehensive Flutter application that combines modern nutrition science with traditional Ayurvedic medicine to provide personalized dietary recommendations.

## 🌟 Features

### 🔐 Authentication
- **Firebase Authentication** with Google Sign-In
- **Secure user management** with Firebase project integration
- **Demo mode** for testing without real authentication

### 🍎 Nutrition Database
- **10,000+ Foods** with comprehensive nutritional information
- **Ayurvedic Properties** including Rasa, Virya, Vipaka, Guna
- **Dosha Suitability** for Vata, Pitta, and Kapha body types
- **Allergen Information** and dietary restrictions
- **Search and Filter** functionality by category, cuisine, meal type

### 📊 Nutritional Analysis
- **Macronutrients**: Calories, Protein, Fat, Carbs, Fiber
- **Vitamins**: A, C, D, E, B1 with detailed measurements
- **Minerals**: Iron, Calcium, Potassium analysis
- **Phytonutrients**: Polyphenols and Phytosterols
- **Per 100g** standardized nutritional data

### 👥 Patient Management
- **1,000+ Patient Profiles** with health data
- **Lifestyle Tracking**: Physical activity, sleep patterns, stress levels
- **Health Conditions**: Allergies, comorbidities tracking
- **Ayurvedic Assessment**: Dosha Prakriti evaluation

### 🍽️ Diet Planning
- **8,000+ Diet Chart Meals** for comprehensive meal planning
- **600+ Recipes** with cooking instructions
- **Meal Type Classification**: Breakfast, Lunch, Dinner, Snacks
- **Cuisine Variety**: Indian, Continental, Mediterranean, Asian

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.35.4 or higher)
- Firebase project setup
- Git for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/prasha-coder/allinone.git
   cd allinone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Update `lib/firebase_options.dart` with your Firebase project configuration
   - Ensure Firestore is enabled in your Firebase console

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```

## 📱 Usage

### 1. Authentication
- Sign in with Google or use demo mode
- Access personalized features after authentication

### 2. Nutrition Database
- Browse foods by category (Dairy, Fruit, Vegetable, etc.)
- Search for specific foods
- View detailed nutritional and Ayurvedic information
- Filter by meal type and cuisine

### 3. Data Import
- Click the cloud upload button to import CSV nutrition data
- Supports bulk import of food, nutritional, and patient data
- Real-time progress tracking during import

### 4. Food Details
- Comprehensive nutritional breakdown
- Ayurvedic properties and dosha suitability
- Allergen warnings and dietary information
- Serving size recommendations

## 🗄️ Database Structure

### Food Database (`nutrition_database/Food_Database_10000.csv`)
- **Food ID**: Unique identifier
- **Names**: English and local language names
- **Category**: Food classification
- **Cuisine**: Regional cuisine type
- **Ayurvedic Properties**: Traditional medicine attributes
- **Dosha Suitability**: Body type compatibility

### Nutritional Data (`nutrition_database/Nutritional_Data_10000.csv`)
- **Macronutrients**: Complete macro breakdown
- **Vitamins**: Comprehensive vitamin profile
- **Minerals**: Essential mineral content
- **Phytonutrients**: Plant-based nutrients

### Patient Profiles (`nutrition_database/Patient_Profile_1000.csv`)
- **Demographics**: Age, gender, contact information
- **Lifestyle**: Activity level, sleep, stress
- **Health**: Allergies, conditions, medications
- **Ayurvedic**: Dosha assessment and recommendations

## 🔧 Technical Architecture

### Frontend
- **Flutter**: Cross-platform mobile and web application
- **Material Design**: Modern, intuitive user interface
- **Provider**: State management for reactive UI updates
- **Responsive Design**: Works on mobile, tablet, and desktop

### Backend
- **Firebase**: Backend-as-a-Service platform
- **Firestore**: NoSQL database for real-time data
- **Firebase Auth**: Secure authentication system
- **Cloud Functions**: Serverless backend logic

### Data Models
- **Food Model**: Complete food information with Ayurvedic properties
- **Nutritional Data Model**: Detailed nutritional breakdown
- **Patient Model**: User health and lifestyle data

## 📊 Data Sources

All nutrition data is sourced from comprehensive research databases including:
- Traditional Ayurvedic texts and modern interpretations
- USDA nutritional databases
- Medical research on phytonutrients
- Clinical studies on dosha-based nutrition

## 🌐 Firebase Integration

### Project Configuration
- **Project ID**: `nutrients1-36408159`
- **Firestore**: Real-time database for nutrition data
- **Authentication**: Google Sign-In integration
- **Security Rules**: Proper data access controls

### Collections
- `foods`: Complete food database with Ayurvedic properties
- `nutritional_data`: Detailed nutritional information
- `patients`: User profiles and health data

## 🚀 Deployment

### Web Deployment
```bash
flutter build web
# Deploy the build/web folder to your hosting service
```

### Mobile Deployment
```bash
flutter build apk  # Android
flutter build ios  # iOS
```

## 📈 Performance

- **Optimized Queries**: Efficient Firestore queries with pagination
- **Caching**: Local data caching for improved performance
- **Batch Operations**: Bulk data import with progress tracking
- **Error Handling**: Comprehensive error management

## 🔒 Security

- **Firebase Security Rules**: Proper data access controls
- **Authentication**: Secure user authentication
- **Data Validation**: Input validation and sanitization
- **Privacy**: User data protection and GDPR compliance

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Traditional Ayurvedic medicine practitioners
- Modern nutrition science researchers
- Firebase and Flutter communities
- Open source contributors

## 📞 Support

For support and questions:
- Create an issue in this repository
- Contact: prashantmmourya@gmail.com

---


**ThingBots** - Bridging ancient wisdom with modern technology for better health and nutrition. 🌿✨
