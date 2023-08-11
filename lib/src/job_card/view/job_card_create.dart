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
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              RaisedButton(
                onPressed: () {
                  // TODO: Implement form submission logic
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
