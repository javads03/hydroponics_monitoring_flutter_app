import 'package:flutter/material.dart';

class NutrientPrediction extends StatefulWidget {
  final String tdsval;

  NutrientPrediction({required this.tdsval});

  @override
  _NutrientPredictionState createState() => _NutrientPredictionState();
}

class _NutrientPredictionState extends State<NutrientPrediction> {
  String nutrientStatus = '';
  String steps = '';

  void calculateNutrientLevel(double tds) {
    double nutrientLevel =
        tds * 0.1; // Adjust the formula according to your needs

    setState(() {
      if (nutrientLevel < 1.5) {
        nutrientStatus = 'Low';
        steps =
            '\n1. Add appropriate nutrient solution to the hydroponics system.\n'
            '\n2. Monitor plant growth and nutrient levels regularly.';
      } else if (nutrientLevel >= 1.5 && nutrientLevel < 3.0) {
        nutrientStatus = 'Medium';
        steps =
            '\n1. Maintain the current nutrient solution in the hydroponics system.\n'
            '\n2. Monitor plant growth and nutrient levels regularly.';
      } else {
        nutrientStatus = 'High';
        steps = '\n1. Dilute the nutrient solution in the hydroponics system.\n'
            '\n2. Check the water quality and consider flushing the system if needed.\n'
            '\n3. Monitor plant growth and nutrient levels regularly.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double tds = double.tryParse(widget.tdsval) ?? 0;
    calculateNutrientLevel(tds);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: const Text('Nutrient Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Text(
                'Predicted Nutrient Level: $nutrientStatus',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Steps to be taken:\n',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(steps),
            ],
          ),
        ),
      ),
    );
  }
}
