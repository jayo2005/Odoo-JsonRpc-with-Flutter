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
        title: Text('Job Card Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: Text('Job Card Page'),
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
                            return 'Please enter a customer id';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _regNoController,
                        decoration: InputDecoration(labelText: 'Registration Number'),
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
                              onSuccess: (response) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Success'),
                                      content: Text('Job created successfully'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onError: (error) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Job creation failed'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
