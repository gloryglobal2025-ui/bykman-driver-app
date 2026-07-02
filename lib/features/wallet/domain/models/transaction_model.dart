class TransactionModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Transaction>? data;


  TransactionModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Transaction>[];
      json['data'].forEach((v) {
        data!.add(Transaction.fromJson(v));
      });
    }

  }

}

class Transaction {
  String? id;
  String? attribute;
  String? attributeId;
  double? debit;
  double? credit;
  String? createdAt;

  Transaction(
      {this.id,
        this.attribute,
        this.attributeId,
        this.debit,
        this.credit,
        this.createdAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attribute = json['account'];
    attributeId = json['attribute_id'];
    debit = double.tryParse(json['debit'].toString());
    credit = double.tryParse(json['credit'].toString());
    createdAt = json['created_at'];
  }


}


