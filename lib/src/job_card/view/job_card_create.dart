import 'package:flutter/material.dart';

class JobCardCreate extends StatefulWidget {
  @override
  _JobCardCreateState createState() => _JobCardCreateState();
}

class _JobCardCreateState extends State<JobCardCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer ID'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Reg No'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createJobCardApi(
                      customerId: _customerIdController.text,
                      regNo: _regNoController.text,
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
    );
  }
}
