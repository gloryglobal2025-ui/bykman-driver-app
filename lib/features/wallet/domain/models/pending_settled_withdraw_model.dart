class PendingSettledWithdrawModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<PendingSettleInfo>? data;
  List<String>? errors;

  PendingSettledWithdrawModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  PendingSettledWithdrawModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <PendingSettleInfo>[];
      json['data'].forEach((v) {
        data!.add( PendingSettleInfo.fromJson(v));
      });
    }
    errors = json['errors'].cast<String>();
  }

}

class PendingSettleInfo {
  int? id;
  Method? method;
  String? driverNote;
  String? approvalNote;
  String? deniedNote;
  String? status;
  double? amount;
  String? createdAt;

  PendingSettleInfo(
      {this.id,
        this.method,
        this.driverNote,
        this.approvalNote,
        this.deniedNote,
        this.status,
        this.amount,
        this.createdAt});

  PendingSettleInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    method =
    json['method'] != null ? Method.fromJson(json['method']) : null;
    driverNote = json['driver_note'];
    approvalNote = json['approval_note'];
    deniedNote = json['denied_note'];
    status = json['status'];
    amount = double.tryParse(json['amount'].toString());
    createdAt = json['created_at'];
  }

}


class Method {
  int? id;
  String? methodName;
  List<MethodFields>? methodFields;
  bool? isDefault;
  bool? isActive;
  String? createdAt;

  Method(
      {this.id,
        this.methodName,
        this.methodFields,
        this.isDefault,
        this.isActive,
        this.createdAt});

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    methodName = json['method_name'];
    if (json['method_fields'] != null) {
      methodFields = <MethodFields>[];
      json['method_fields'].forEach((v) {
        methodFields!.add(MethodFields.fromJson(v));
      });
    }
    isDefault = json['is_default'] != null ? (json['is_default'].toString() == '1' || json['is_default'].toString() == 'true') : null;
    isActive = json['is_active'] != null ? (json['is_active'].toString() == '1' || json['is_active'].toString() == 'true') : null;
    createdAt = json['created_at'];
  }

}

class MethodFields {
  String? inputType;
  String? inputName;
  String? placeholder;

  MethodFields(
      {this.inputType, this.inputName, this.placeholder});

  MethodFields.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    inputName = json['input_name'];
    placeholder = json['placeholder'];
  }

}
