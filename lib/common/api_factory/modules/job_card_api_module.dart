import 'dart:convert';
import 'package:http/http.dart' as http;
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
