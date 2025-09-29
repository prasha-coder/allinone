import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../models/nutritional_data_model.dart';
import '../models/patient_model.dart';

class DataImporter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Import food data from CSV
  Future<void> importFoodData(String csvFilePath) async {
    try {
      final file = File(csvFilePath);
      final lines = await file.readAsLines();
      
      // Skip header row
      final dataLines = lines.skip(1);
      
      int batchCount = 0;
      WriteBatch batch = _firestore.batch();
      
      for (final line in dataLines) {
        final fields = _parseCsvLine(line);
        
        if (fields.length >= 17) {
          final food = Food(
            foodId: fields[0],
            foodNameEnglish: fields[1],
            foodNameLocal: fields[2],
            baseItem: fields[3],
            category: fields[4],
            cuisine: fields[5],
            scientificName: fields[6],
            description: fields[7],
            mealType: fields[8],
            servingSizeG: double.tryParse(fields[9]) ?? 0.0,
            rasa: fields[10],
            virya: fields[11],
            vipaka: fields[12],
            guna: fields[13],
            digestibility: fields[14],
            doshaSuitability: fields[15],
            allergenWarnings: fields[16],
          );
          
          batch.set(_firestore.collection('foods').doc(food.foodId), food.toMap());
          batchCount++;
          
          // Commit batch every 500 documents
          if (batchCount % 500 == 0) {
            await batch.commit();
            batch = _firestore.batch();
            debugPrint('Imported $batchCount foods...');
          }
        }
      }
      
      // Commit remaining documents
      if (batchCount % 500 != 0) {
        await batch.commit();
      }
      
      debugPrint('Successfully imported $batchCount foods');
    } catch (e) {
      debugPrint('Error importing food data: $e');
    }
  }

  // Import nutritional data from CSV
  Future<void> importNutritionalData(String csvFilePath) async {
    try {
      final file = File(csvFilePath);
      final lines = await file.readAsLines();
      
      // Skip header row
      final dataLines = lines.skip(1);
      
      int batchCount = 0;
      WriteBatch batch = _firestore.batch();
      
      for (final line in dataLines) {
        final fields = _parseCsvLine(line);
        
        if (fields.length >= 16) {
          final nutritionalData = NutritionalData(
            foodId: fields[0],
            caloriesPer100g: double.tryParse(fields[1]) ?? 0.0,
            proteinGPer100g: double.tryParse(fields[2]) ?? 0.0,
            fatGPer100g: double.tryParse(fields[3]) ?? 0.0,
            carbsGPer100g: double.tryParse(fields[4]) ?? 0.0,
            fiberGPer100g: double.tryParse(fields[5]) ?? 0.0,
            vitAIUPer100g: double.tryParse(fields[6]) ?? 0.0,
            vitCMgPer100g: double.tryParse(fields[7]) ?? 0.0,
            vitDUgPer100g: double.tryParse(fields[8]) ?? 0.0,
            vitEMgPer100g: double.tryParse(fields[9]) ?? 0.0,
            vitB1MgPer100g: double.tryParse(fields[10]) ?? 0.0,
            ironMgPer100g: double.tryParse(fields[11]) ?? 0.0,
            calciumMgPer100g: double.tryParse(fields[12]) ?? 0.0,
            potassiumMgPer100g: double.tryParse(fields[13]) ?? 0.0,
            polyphenolsMgPer100g: double.tryParse(fields[14]) ?? 0.0,
            phytosterolsMgPer100g: double.tryParse(fields[15]) ?? 0.0,
          );
          
          batch.set(_firestore.collection('nutritional_data').doc(nutritionalData.foodId), nutritionalData.toMap());
          batchCount++;
          
          // Commit batch every 500 documents
          if (batchCount % 500 == 0) {
            await batch.commit();
            batch = _firestore.batch();
            debugPrint('Imported $batchCount nutritional data entries...');
          }
        }
      }
      
      // Commit remaining documents
      if (batchCount % 500 != 0) {
        await batch.commit();
      }
      
      debugPrint('Successfully imported $batchCount nutritional data entries');
    } catch (e) {
      debugPrint('Error importing nutritional data: $e');
    }
  }

  // Import patient data from CSV
  Future<void> importPatientData(String csvFilePath) async {
    try {
      final file = File(csvFilePath);
      final lines = await file.readAsLines();
      
      // Skip header row
      final dataLines = lines.skip(1);
      
      int batchCount = 0;
      WriteBatch batch = _firestore.batch();
      
      for (final line in dataLines) {
        final fields = _parseCsvLine(line);
        
        if (fields.length >= 15) {
          final patient = Patient(
            patientId: fields[0],
            namePseudonym: fields[1],
            age: int.tryParse(fields[2]) ?? 0,
            gender: fields[3],
            contactInfo: fields[4],
            dietaryHabits: fields[5],
            mealFrequencyPerDay: int.tryParse(fields[6]) ?? 0,
            bowelMovements: fields[7],
            waterIntakeLiters: double.tryParse(fields[8]) ?? 0.0,
            physicalActivityLevel: fields[9],
            sleepPatterns: fields[10],
            stressLevels: fields[11],
            allergies: fields[12],
            comorbidities: fields[13],
            doshaPrakritiAssessment: fields[14],
          );
          
          batch.set(_firestore.collection('patients').doc(patient.patientId), patient.toMap());
          batchCount++;
          
          // Commit batch every 500 documents
          if (batchCount % 500 == 0) {
            await batch.commit();
            batch = _firestore.batch();
            debugPrint('Imported $batchCount patients...');
          }
        }
      }
      
      // Commit remaining documents
      if (batchCount % 500 != 0) {
        await batch.commit();
      }
      
      debugPrint('Successfully imported $batchCount patients');
    } catch (e) {
      debugPrint('Error importing patient data: $e');
    }
  }

  // Parse CSV line handling commas within quotes
  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    String currentField = '';
    
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(currentField.trim());
        currentField = '';
      } else {
        currentField += char;
      }
    }
    
    result.add(currentField.trim());
    return result;
  }

  // Import all data from the nutri12 repository
  Future<void> importAllData() async {
    try {
      debugPrint('Starting data import from nutri12 repository...');
      
      // Import food data
      await importFoodData('/Users/prashantmourya/Downloads/nutri12/Food_Database_10000.csv');
      
      // Import nutritional data
      await importNutritionalData('/Users/prashantmourya/Downloads/nutri12/Nutritional_Data_10000.csv');
      
      // Import patient data
      await importPatientData('/Users/prashantmourya/Downloads/nutri12/Patient_Profile_1000.csv');
      
      debugPrint('Data import completed successfully!');
    } catch (e) {
      debugPrint('Error during data import: $e');
    }
  }
}
