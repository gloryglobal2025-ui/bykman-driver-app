import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

enum AdditionalFieldType { text, number, date, email, phone, file, checkbox, radio, select, textarea }

class AdditionalFieldModel {
  final String id;
  final String title;
  final String? placeholder;
  final AdditionalFieldType fieldType;
  final bool isRequired;
  final List<String>? allowedFileFormats;
  final List<String>? options;
  final int? fileQuantity;

  AdditionalFieldModel({
    required this.id,
    required this.title,
    this.placeholder,
    required this.fieldType,
    this.isRequired = false,
    this.allowedFileFormats,
    this.options,
    this.fileQuantity
  });

  factory AdditionalFieldModel.fromJson(Map<String, dynamic> json) {
    return AdditionalFieldModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      placeholder: json['placeholder'],
      fieldType: _parseFieldType(json['type'] ?? 'text'),
      isRequired: json['is_required'] != null ? (json['is_required'].toString() == '1' || json['is_required'].toString() == 'true') : false,
      allowedFileFormats: json['file_format'] != null
          ? List<String>.from(json['file_format'])
          : null,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      fileQuantity: json['quantity'] != null ? int.tryParse(json['quantity'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'placeholder': placeholder,
      'field_type': fieldType.name,
      'is_required': isRequired ? 1 : 0,
      'allowed_file_formats': allowedFileFormats,
      'options': options,
    };
  }

  static AdditionalFieldType _parseFieldType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return AdditionalFieldType.text;
      case 'number':
        return AdditionalFieldType.number;
      case 'date':
        return AdditionalFieldType.date;
      case 'email':
        return AdditionalFieldType.email;
      case 'phone':
        return AdditionalFieldType.phone;
      case 'file':
        return AdditionalFieldType.file;
      case 'checkbox':
        return AdditionalFieldType.checkbox;
      case 'radio':
        return AdditionalFieldType.radio;
      case 'select':
        return AdditionalFieldType.select;
      case 'textarea':
        return AdditionalFieldType.textarea;
      default:
        return AdditionalFieldType.text;
    }
  }

  TextInputType get keyboardType {
    switch (fieldType) {
      case AdditionalFieldType.text:
        return TextInputType.text;
      case AdditionalFieldType.number:
        return TextInputType.number;
      case AdditionalFieldType.email:
        return TextInputType.emailAddress;
      case AdditionalFieldType.phone:
        return TextInputType.phone;
      case AdditionalFieldType.date:
      case AdditionalFieldType.file:
      case AdditionalFieldType.checkbox:
      case AdditionalFieldType.radio:
      case AdditionalFieldType.select:
      case AdditionalFieldType.textarea:
        return TextInputType.text;
    }
  }

  String get fileFormatsDisplay {
    if (allowedFileFormats == null || allowedFileFormats!.isEmpty) return '';

    List<String> extensions = [];

    allowedFileFormats?.forEach((extension){
      if(extension == 'image'){
        extensions.addAll(AppConstants.allowedImageExtensions);
      }
      if(extension == 'pdf'){
        extensions.addAll(AppConstants.allowPdfFormat);
      }
      if(extension == 'document'){
        extensions.addAll(AppConstants.allowDocFormat);
      }
    });
    return extensions.join(', ');
  }

}