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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobCardCreate()),
                ).then((value) => setState(() {}));
              },
              child: Text('Create Job Card'),
            ),
          ],
        ),
      ),
    );
  }
}
