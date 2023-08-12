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
  return [];
}

Future<List<String>> getVehicleModels() async {
  // Call the Odoo API to fetch the vehicle models
  // The actual implementation may vary depending on your Odoo server and API
  // If the API call fails or doesn't return any data, return an empty list
  return [];
}
