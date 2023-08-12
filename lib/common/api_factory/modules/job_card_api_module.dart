import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';

createJobCardApi({
  required String base64Image,
  required String customerId,
  required String regNo,
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
      "vehicle_make": _vehicleMakeController.text,
      "vehicle_model": _vehicleModelController.text,
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
