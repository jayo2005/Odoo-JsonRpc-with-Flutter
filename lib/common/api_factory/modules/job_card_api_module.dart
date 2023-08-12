import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';

createJobCardApi({
  required String base64Image,
  required String customerId,
  required String regNo,
  required Function onSuccess,
  required Function onError,
}) {
  Api.create(
    model: "job.card",
    values: {
      "base64_image": base64Image,
      "customer_id": customerId,
      "reg_no": regNo,
    },
    onResponse: (response) {
      print('Job card created with id: ${response}');
      onSuccess();
    },
    onError: (error, data) {
      handleApiError(error);
      onError();
      return null;
    },
  );
}
