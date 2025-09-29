#!/bin/bash

# ThingBots Ayurvedic Diet Assistant - Setup Script
# This script helps you set up the development environment

echo "🌿 ThingBots Ayurvedic Diet Assistant - Setup Script"
echo "=================================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first:"
    echo "   https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed: $(flutter --version | head -n 1)"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "⚠️  Firebase CLI is not installed. Installing..."
    npm install -g firebase-tools
    if [ $? -eq 0 ]; then
        echo "✅ Firebase CLI installed successfully"
    else
        echo "❌ Failed to install Firebase CLI. Please install manually:"
        echo "   npm install -g firebase-tools"
    fi
else
    echo "✅ Firebase CLI is installed: $(firebase --version)"
fi

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Flutter dependencies installed successfully"
else
    echo "❌ Failed to install Flutter dependencies"
    exit 1
fi

# Check for Firebase configuration
if [ ! -f "lib/firebase_options.dart" ]; then
    echo "⚠️  Firebase configuration not found. Please configure Firebase:"
    echo "   1. Go to https://console.firebase.google.com/"
    echo "   2. Create a new project or use existing project"
    echo "   3. Add Flutter app to your project"
    echo "   4. Download firebase_options.dart and replace the existing file"
    echo "   5. Enable Firestore and Authentication in Firebase console"
fi

# Run Flutter doctor
echo "🔍 Running Flutter doctor to check for issues..."
flutter doctor

echo ""
echo "🚀 Setup complete! You can now run the app with:"
echo "   flutter run -d chrome"
echo ""
echo "📚 For more information, see README.md"
echo "🌿 Happy coding with ThingBots!"
