class OtherEmergencyNumberModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  List<Data>? data;
  List<String>? errors;

  OtherEmergencyNumberModel({
    this.responseCode,
    this.message,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors
  });

  OtherEmergencyNumberModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'] != null ? int.tryParse(json['limit'].toString()) : null;
    offset = json['offset'] != null ? int.tryParse(json['offset'].toString()) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    errors = json['errors'].cast<String>();
  }

}

class Data {
  String? title;
  String? number;

  Data({this.title, this.number});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    number = json['number'];
  }

}
