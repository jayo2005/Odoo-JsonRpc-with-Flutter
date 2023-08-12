import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart' as Api;
import 'package:odoo_common_code_latest/common/api_factory/modules/job_card_api_module.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';

class JobCardCreate extends StatefulWidget {
  @override
  _JobCardCreateState createState() => _JobCardCreateState();
}

class _JobCardCreateState extends State<JobCardCreate> {
  String? selectedMake;
  String? selectedModel;
  List<String> makes = [];
  List<String> models = [];

  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _regNoController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  String? _selectedVehicleMake;
  String? _selectedVehicleModel;
  int? _selectedVehicleBrandId;
  List<String> _vehicleMakes = [];
  List<String> _vehicleModels = [];
  List<int> _vehicleBrandIds = [];
  final _vehicleBrandIdController = TextEditingController();
  final _vehicleModelIdController = TextEditingController();
  final _imageController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  File? _image;

  @override
  @override
  void initState() {
    super.initState();
    getVehicleMakes().then((result) => setState(() => makes = result));
    getVehicleModels().then((result) => setState(() => models = result));
  }

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
          child: SingleChildScrollView(
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
                    final pickedFile = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                      _imageController.text =
                          base64Encode(_image!.readAsBytesSync());
                    }
                  },
                  child: Text('Take Picture'),
                ),
                if (_image != null) Image.file(_image!),
                TextFormField(
                  controller: _vehicleMakeController,
                  decoration: InputDecoration(labelText: 'Vehicle Make'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a vehicle make';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: _selectedVehicleModel,
                  items: _vehicleModels.map((model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleModel = value as String?;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Vehicle Model'),
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
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      String base64Image =
                          base64Encode(_image!.readAsBytesSync());
                      Api.createJobCardApi(
                        base64Image: base64Image,
                        customerId: _customerIdController.text,
                        regNo: _regNoController.text,
                        vehicleMake: _selectedVehicleMake ?? '',
                        vehicleModel: _selectedVehicleModel ?? '',
                        vehicleBrandId:
                            _vehicleBrandIdController.text.isNotEmpty
                                ? int.parse(_vehicleBrandIdController.text)
                                : 0,
                        vehicleModelId:
                            _vehicleModelIdController.text.isNotEmpty
                                ? int.parse(_vehicleModelIdController.text)
                                : 0,
                        onSuccess: () {
                          print('Job card created successfully');
                        },
                        onError: () {
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
      ),
    );
  }
}
