import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temp Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: TempConverterApp(),
    ),
  );
}

class TempConverterApp extends StatefulWidget {
  @override
  _TempConverterAppState createState() => _TempConverterAppState();
}

class _TempConverterAppState extends State<TempConverterApp> {
  String _conversionType = 'FtoC';
  TextEditingController _tempController = TextEditingController();
  String _result = '';
  List<String> _history = [];

  void _convertTemperature() {
    final input = _tempController.text;
    final value = double.tryParse(input);
    if (value == null) return;

    final converted = _conversionType == 'FtoC'
        ? (value - 32) * 5 / 9
        : (value * 9 / 5) + 32;

    final label = _conversionType == 'FtoC' ? 'F to C' : 'C to F';
    final historyItem = '$label: $value → ${converted.toStringAsFixed(2)}';

    setState(() {
      _result = converted.toStringAsFixed(2);
      _history.insert(0, historyItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final inputCard = Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.thermostat),
                labelText: 'Enter Temperature',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('F → C'),
                    value: 'FtoC',
                    groupValue: _conversionType,
                    onChanged: (val) =>
                        setState(() => _conversionType = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('C → F'),
                    value: 'CtoF',
                    groupValue: _conversionType,
                    onChanged: (val) =>
                        setState(() => _conversionType = val!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _convertTemperature,
              icon: Icon(Icons.swap_vert),
              label: Text("Convert"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                'Result: $_result',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );

    final historyCard = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: _history.isEmpty
                  ? Center(child: Text('No conversions yet'))
                  : ListView.builder(
                itemCount: _history.length,
                itemBuilder: (_, index) =>
                    ListTile(title: Text(_history[index])),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Temperature Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isPortrait
            ? Column(
          children: [
            inputCard,
            Expanded(child: historyCard),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: SingleChildScrollView(child: inputCard),
            ),
            SizedBox(width: 12),
            Expanded(child: historyCard),
          ],
        ),
      ),
    );
  }
}
