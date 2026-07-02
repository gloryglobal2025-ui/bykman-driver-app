class WithdrawMethodInfoData {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<SingleMethodInfo>? data;
  List<String>? errors;

  WithdrawMethodInfoData({
    this.responseCode,
    this.message,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors
  });

  WithdrawMethodInfoData.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <SingleMethodInfo>[];
      json['data'].forEach((v) {
        data!.add(SingleMethodInfo.fromJson(v));
      });
    }
    errors = json['errors'].cast<String>();
  }

}

class SingleMethodInfo {
  String? id;
  String? methodName;
  WithdrawMethod? withdrawMethod;
  List<MethodInfo>? methodInfo;
  bool? isActive;

  SingleMethodInfo(
      {this.id,
        this.methodName,
        this.withdrawMethod,
        this.methodInfo,
        this.isActive});

  SingleMethodInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    withdrawMethod = json['withdraw_method'] != null
        ?  WithdrawMethod.fromJson(json['withdraw_method'])
        : null;
    if (json['method_info'] != null) {
      methodInfo = <MethodInfo>[];
      json['method_info'].forEach((v) {
        methodInfo!.add( MethodInfo.fromJson(v));
      });
    }
    isActive = json['is_active'] != null ? (json['is_active'].toString() == '1' || json['is_active'].toString() == 'true') : null;
  }

}


class WithdrawMethod {
  int? id;
  String? methodName;
  List<MethodFields>? methodFields;
  bool? isDefault;
  bool? isActive;
  String? createdAt;

  WithdrawMethod(
      {this.id,
        this.methodName,
        this.methodFields,
        this.isDefault,
        this.isActive,
        this.createdAt
      });

  WithdrawMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    methodName = json['method_name'];
    if (json['method_fields'] != null) {
      methodFields = <MethodFields>[];
      json['method_fields'].forEach((v) {
        methodFields!.add( MethodFields.fromJson(v));
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

  MethodFields({this.inputType, this.inputName, this.placeholder});

  MethodFields.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    inputName = json['input_name'];
    placeholder = json['placeholder'];
  }

}

class MethodInfo {
  String? key;
  String? value;

  MethodInfo({this.key, this.value});

  MethodInfo.fromJson(Map<String, dynamic> json) {
    key = json['key'].toString();
    value = json['value'].toString();
  }

}
