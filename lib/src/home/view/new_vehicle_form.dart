import 'package:flutter/material.dart';
import 'package:odoo_common_code_latest/common/api_factory/modules/job_card_api_module.dart'; // Update with the correct path to your job_card_api_module.dart file

class NewVehicleMakeForm extends StatefulWidget {
  @override
  _NewVehicleMakeFormState createState() => _NewVehicleMakeFormState();
}

class _NewVehicleMakeFormState extends State<NewVehicleMakeForm> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();

  void createVehicleMake(String make) {
    // Implement the functionality to create a vehicle make here
    print('Creating vehicle make: $make');
  }

  @override
  void dispose() {
    _makeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Vehicle Make'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(labelText: 'Make'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a make';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call the API function to create the new make in Odoo
                    createVehicleMake(_makeController.text);
                  }
                },
                child: Text('Create Make'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
