import 'package:odoo_common_code_latest/common/api_factory/api.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';

typedef OnResponse<T> = void Function(T response); // Define the OnResponse type

class JobCardModel {
  final Map<String, dynamic> customerId;
  final String regNo;

  JobCardModel({required this.customerId, required this.regNo});

  factory JobCardModel.fromJson(Map<String, dynamic> json) {
    return JobCardModel(
      customerId: json['customer_id'],
      regNo: json['reg_no'],
    );
  }
}

void jobCardApi({required OnResponse<JobCardModel> onResponse}) {
  Api.searchRead(
    model: "job.card",
    domain: [],
    fields: ["customer_id", "reg_no"],
    onResponse: (response) {
      onResponse(JobCardModel.fromJson(response));
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}
