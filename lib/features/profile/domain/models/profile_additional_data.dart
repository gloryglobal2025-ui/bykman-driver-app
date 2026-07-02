
class ProfileAdditionalData {
  String? id;
  String? type;
  String? title;
  int? isRequired;
  List<String>? options;
  List<String>? value;
  List<String>? fileFormat;
  int? quantity;
  String? placeholder;

  ProfileAdditionalData({
    this.id,
    this.type,
    this.title,
    this.isRequired,
    this.options,
    this.value,
    this.fileFormat,
    this.quantity,
    this.placeholder,
  });

  ProfileAdditionalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    isRequired = json['is_required'] != null ? int.tryParse(json['is_required'].toString()) : null;
    options = json['options'] != null ? List<String>.from(json['options']) : null;
    value = json['value'] != null ? List<String>.from(json['value']) : null;
    fileFormat = json['file_format']!= null ? List<String>.from(json['file_format']) : null;
    quantity = json['quantity'] != null ? int.tryParse(json['quantity'].toString()) : null;
    placeholder = json['placeholder'];
  }
}