
class ReferralDetailsModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  Data? data;
  List<String>? errors;

  ReferralDetailsModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  ReferralDetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'] != null ? int.tryParse(json['limit'].toString()) : null;
    offset = json['offset'] != null ? int.tryParse(json['offset'].toString()) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'].cast<String>();
  }
  
}

class Data {
  String? referralCode;
  double? shareCodeEarning;
  double? useCodeEarning;

  Data({this.referralCode, this.shareCodeEarning, this.useCodeEarning});

  Data.fromJson(Map<String, dynamic> json) {
    referralCode = json['referral_code'];
    shareCodeEarning = double.tryParse(json['share_code_earning'].toString());
    useCodeEarning = double.tryParse(json['use_code_earning'].toString());
  }
  
}
