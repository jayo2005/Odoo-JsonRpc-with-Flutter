import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_common_code_latest/common/api_factory/modules/job_card_api_module.dart';

class JobCardCreate extends StatefulWidget {
  @override
  _JobCardCreateState createState() => _JobCardCreateState();
}

class _JobCardCreateState extends State<JobCardCreate> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _regNoController = TextEditingController();
  final _imageController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('SoftCroft'),
          automaticallyImplyLeading: false,
        ),
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
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    _imageController.text = base64Encode(_image!.readAsBytesSync());
                  }
                },
                child: Text('Take Picture'),
              ),
              if (_image != null)
                Image.file(_image!),
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
              TextFormField(
                controller: _avatarUrlController,
                decoration: InputDecoration(labelText: 'Avatar URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an avatar URL';
                  }
                  return null;
                },
              ),
              Container(
                child: _avatarUrlController.text.isEmpty
                    ? Text('No image')
                    : Image.network(_avatarUrlController.text),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createJobCardApiWithImage(
                      customerId: _customerIdController.text,
                      regNo: _regNoController.text,
                      avatar: _avatarUrlController.text,
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
    );
  }
}
