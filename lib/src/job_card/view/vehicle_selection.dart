import 'package:flutter/material.dart';
import '../../../common/api_factory/api.dart'; // Corrected relative path to your API file

Future<List<String>> getVehicleMakes() {
  // TODO: Implement the code to call Odoo API and get makes from 'vehicle.brand'
  // Return a list of makes as strings
}

Future<List<String>> getVehicleModels() {
  // TODO: Implement the code to call Odoo API and get models from 'vehicle.model'
  // Return a list of models as strings
}

class VehicleSelection extends StatefulWidget {
  @override
  _VehicleSelectionState createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
  String? selectedMake;
  String? selectedModel;
  List<String> makes = [];
  List<String> models = [];

  @override
  void initState() {
    super.initState();
    getVehicleMakes().then((result) => setState(() => makes = result));
    getVehicleModels().then((result) => setState(() => models = result));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedMake,
          items: makes
              .map((make) => DropdownMenuItem(child: Text(make), value: make))
              .toList(),
          onChanged: (value) => setState(() => selectedMake = value),
          hint: Text('Select Make'),
        ),
        DropdownButton<String>(
          value: selectedModel,
          items: models
              .map(
                  (model) => DropdownMenuItem(child: Text(model), value: model))
              .toList(),
          onChanged: (value) => setState(() => selectedModel = value),
          hint: Text('Select Model'),
        ),
        // Rest of your widgets
      ],
    );
  }
}
