import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(home: TempConverterApp(), debugShowCheckedModeBanner: false),
  );
}

// This widget is the main entry point of the app
class TempConverterApp extends StatefulWidget {
  @override
  _TempConverterAppState createState() => _TempConverterAppState();
}

class _TempConverterAppState extends State<TempConverterApp> {
  String _conversionType = 'FtoC'; // Keeps track of selected conversion direction
  TextEditingController _tempController = TextEditingController(); // Controller to get text input from user
  String _result = ''; // Stores the final converted temperature
  List<String> _history = []; // Stores a list of previous conversions

  // Function to perform temperature conversion and update result and history
  void _convertTemperature() {
    final input = _tempController.text;
    final value = double.tryParse(input); // Try converting input to a number

    // If input is not a valid number, exit function
    if (value == null) return;

    // Perform conversion based on selected type
    final converted = _conversionType == 'FtoC'
        ? (value - 32) * 5 / 9 // Fahrenheit to Celsius
        : (value * 9 / 5) + 32; // Celsius to Fahrenheit

    // Label for history entry
    final label = _conversionType == 'FtoC' ? 'F to C' : 'C to F';
    final historyItem = '$label: $value => ${converted.toStringAsFixed(2)}';

    // Update UI with result and new history item
    setState(() {
      _result = converted.toStringAsFixed(2); // Limit result to 2 decimal places
      _history.insert(0, historyItem); // Add latest conversion to top of history
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the device is in portrait mode
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Widget containing input field, conversion options, button, and result
    final inputSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text field to enter temperature
        TextField(
          controller: _tempController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Enter Temperature',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),

        // Radio buttons to select conversion type
        Row(
          children: [
            // Fahrenheit to Celsius
            Expanded(
              child: RadioListTile<String>(
                title: Text('Fahrenheit to Celsius'),
                value: 'FtoC',
                groupValue: _conversionType,
                onChanged: (val) => setState(() => _conversionType = val!),
              ),
            ),
            // Celsius to Fahrenheit
            Expanded(
              child: RadioListTile<String>(
                title: Text('Celsius to Fahrenheit'),
                value: 'CtoF',
                groupValue: _conversionType,
                onChanged: (val) => setState(() => _conversionType = val!),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Button to perform the conversion
        ElevatedButton(
          onPressed: _convertTemperature,
          child: Text('Convert'),
        ),
        SizedBox(height: 20),

        // Display the result of the conversion
        Text('Result: $_result', style: TextStyle(fontSize: 24)),
      ],
    );

    // Widget to display the conversion history
    final historyWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // History title
        Text(
          'History:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        // List of previous conversions
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (_, index) =>
                ListTile(title: Text(_history[index])),
          ),
        ),
      ],
    );

    // Scaffold provides app layout and structure
    return Scaffold(
      appBar: AppBar(title: Text('Temperature Converter')), // App bar with title
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Use different layout for portrait and landscape modes
        child: isPortrait
            ? Column(
          children: [
            inputSection, // Input section at the top
            SizedBox(height: 20),
            Expanded(child: historyWidget), // History takes remaining space
          ],
        )
            : Row(
          children: [
            // Left side: scrollable input section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: inputSection,
                ),
              ),
            ),
            // Right side: conversion history
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History:',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (_, index) =>
                          ListTile(title: Text(_history[index])),
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
}
