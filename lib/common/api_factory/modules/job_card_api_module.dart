import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';

createJobCardApi({
  required String base64Image,
  required String customerId,
  required String regNo,
  required String vehicleMake,
  required String vehicleModel,
  required int vehicleBrandId,
  required int vehicleModelId,
  required Function onSuccess,
  required Function onError,
}) {
  Api.create(
    model: "job.card",
    values: {
      "avatar": base64Image,
      "customer_id": customerId,
      "reg_no": regNo,
      "vehicle_make": vehicleMake,
      "vehicle_model": vehicleModel,
      "vehicle_brand_id": vehicleBrandId,
      "vehicle_model_id": vehicleModelId,
    },
    onResponse: (response) {
      print('Job card created with id: ${response}');
      onSuccess();
    },
    onError: (error, data) {
      handleApiError(error);
      onError();
    },
  );
}

Future<List<String>> getVehicleMakes() async {
  // Call the Odoo API to fetch the vehicle makes
  // The actual implementation may vary depending on your Odoo server and API
  // If the API call fails or doesn't return any data, return an empty list
  var response = await http.get('https://your-api-url.com/vehicle-makes');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}

Future<List<String>> getVehicleModels() async {
  // Call the Odoo API to fetch the vehicle models
  // The actual implementation may vary depending on your Odoo server and API
  // If the API call fails or doesn't return any data, return an empty list
  var response = await http.get('https://your-api-url.com/vehicle-models');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}
Future<List<String>> getVehicleMakes() async {
  List<String> makes = [];
  Api.read(
    model: 'vehicle.make',
    ids: [],
    fields: ['name'],
    onResponse: (response) {
      for (var make in response) {
        makes.add(make['name']);
      }
    },
    onError: (error, data) {
      print('Failed to fetch vehicle makes: $error');
    },
  );
  return makes;
}

Future<List<String>> getVehicleModels() async {
  List<String> models = [];
  Api.read(
    model: 'vehicle.model',
    ids: [],
    fields: ['name'],
    onResponse: (response) {
      for (var model in response) {
        models.add(model['name']);
      }
    },
    onError: (error, data) {
      print('Failed to fetch vehicle models: $error');
    },
  );
  return models;
}
import 'dart:convert';
