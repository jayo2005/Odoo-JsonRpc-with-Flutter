import 'package:flutter/material.dart';
import 'package:odoo_common_code_latest/common/api_factory/modules/job_card_api_module.dart';

class JobCardCreate extends StatefulWidget {
  @override
  _JobCardCreateState createState() => _JobCardCreateState();
}

class _JobCardCreateState extends State<JobCardCreate> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _regNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _customerIdController,
                decoration: InputDecoration(labelText: 'Customer ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a customer ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _regNoController,
                decoration: InputDecoration(labelText: 'Reg No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a registration number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createJobCardApi(
                      customerId: _customerIdController.text,
                      regNo: _regNoController.text,
                      onSuccess: () {
                        // Handle success here
                        print('Job card created successfully');
                        Navigator.pop(context);
                      },
                      onError: () {
                        // Handle error here
                        print('Failed to create job card');
                      },
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
