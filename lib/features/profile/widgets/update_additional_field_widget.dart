import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/additional_field_model.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/field_title.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/update_additonal_files_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class UpdateAdditionalFieldWidget extends StatelessWidget {
  const UpdateAdditionalFieldWidget({
    super.key,
    required this.fieldModel,
    required this.index,
  });

  final AdditionalFieldModel fieldModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) => switch (fieldModel.fieldType) {
        AdditionalFieldType.text || AdditionalFieldType.number || AdditionalFieldType.email || AdditionalFieldType.textarea =>
            _TextInputField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.phone => _PhoneInputField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.date => _DateField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.file => _FileField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.checkbox => _CheckboxField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.radio => _RadioField(fieldModel: fieldModel, profileController: profileController),
        AdditionalFieldType.select => _DropDownField(fieldModel: fieldModel, profileController: profileController),
      },
    );
  }
}

class _TextInputField extends StatelessWidget {
  const _TextInputField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      child: CustomTextField(
        hintText: fieldModel.placeholder ?? fieldModel.title,
        inputType: fieldModel.keyboardType,
        controller: profileController.additionalFieldControllers[fieldModel.id],
        focusNode: profileController.additionalFieldFocusNodes[fieldModel.id],
        inputAction: TextInputAction.next,
        prefix: false,
      ),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      child: TextFieldWidget(
        hintText: fieldModel.placeholder ?? fieldModel.title,
        inputType: fieldModel.keyboardType,
        controller: profileController.additionalFieldControllers[fieldModel.id],
        focusNode: profileController.additionalFieldFocusNodes[fieldModel.id],
        inputAction: TextInputAction.next,
        countryDialCode: profileController.additionalFieldPhoneCountryCodes[fieldModel.id],
        onCountryChanged: (code) => profileController.setAdditionalFieldPhoneCountryCode(fieldModel.id, code.dialCode!),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    String? dateText = profileController.additionalFieldControllers[fieldModel.id]?.text;
    if (dateText != null && dateText.isNotEmpty) {
      try {
        initialDate = DateTime.parse(dateText);
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      profileController.additionalFieldControllers[fieldModel.id]?.text = formatted;
      profileController.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: CustomTextField(
            hintText: fieldModel.placeholder ?? fieldModel.title,
            inputType: TextInputType.text,
            controller: profileController.additionalFieldControllers[fieldModel.id],
            focusNode: profileController.additionalFieldFocusNodes[fieldModel.id],
            inputAction: TextInputAction.next,
            prefix: false,
            read: true,
          ),
        ),
      ),
    );
  }
}

class _FileField extends StatelessWidget {
  const _FileField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return UpdateAdditionalFilesWidget(
      fieldModel: fieldModel,
      selectedFiles: profileController.additionalFieldFiles[fieldModel.id] ?? [],
      onFilesSelected: (List<dynamic> files) => profileController.setAdditionalFieldFile(fieldModel.id, files),
    );
  }
}

class _CheckboxField extends StatelessWidget {
  const _CheckboxField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.options?.isEmpty ?? true) return const SizedBox.shrink();

    final selectedOptions = (profileController.additionalFieldCheckValues[fieldModel.id] as List?) ?? [];

    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      addSpacing: true,
      child: Column(
        children: fieldModel.options!.map((option) {
          final isChecked = selectedOptions.contains(option);
          return _OptionRow(
            label: option,
            leading: _CheckBox(
              value: isChecked,
              onChanged: (value) {
                final updated = List.from(selectedOptions);
                value == true ? updated.add(option) : updated.remove(option);
                profileController.setAdditionalFieldCheckValue(fieldModel.id, updated);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RadioField extends StatelessWidget {
  const _RadioField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.options?.isEmpty ?? true) return const SizedBox.shrink();

    final selectedValue =
    profileController.additionalFieldCheckValues[fieldModel.id] as String?;

    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      addSpacing: true,
      child: RadioGroup<String>(
        groupValue: selectedValue,
        onChanged: (value) {
          if (value != null) {
            profileController.setAdditionalFieldCheckValue(fieldModel.id, value);
          }
        },
        child: Column(
          children: fieldModel.options!.map((option) {
            return _OptionRow(
              label: option,
              leading: SizedBox(
                width: 24,
                height: 24,
                child: Radio<String>(
                  side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                  value: option,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        checkColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).primaryColor.withValues(alpha: .125),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(
          color: Theme.of(context).hintColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.leading,
  });

  final String label;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          leading,
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Text(
              titleFormatedName(label),
              style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropDownField extends StatelessWidget {
  const _DropDownField({
    required this.fieldModel,
    required this.profileController,
  });

  final AdditionalFieldModel fieldModel;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.options?.isEmpty ?? true) return const SizedBox.shrink();

    final selectedValue = profileController.additionalFieldCheckValues[fieldModel.id] as String?;

    return _FieldColumn(
      title: titleFormatedName(fieldModel.title),
      isRequired: fieldModel.isRequired,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 0.5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: (selectedValue == null || selectedValue.isEmpty) ? null : selectedValue,
            hint: Text(titleFormatedName(fieldModel.placeholder ?? fieldModel.title), style: textRegular.copyWith(color: Theme.of(context).hintColor)),
            isExpanded: true,
            items: fieldModel.options!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(titleFormatedName(value), style: textRegular),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                profileController.setAdditionalFieldCheckValue(fieldModel.id, value);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _FieldColumn extends StatelessWidget {
  const _FieldColumn({
    required this.title,
    required this.isRequired,
    required this.child,
    this.addSpacing = false,
  });

  final String title;
  final bool isRequired;
  final Widget child;
  final bool addSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(title: titleFormatedName(title), isRequired: isRequired),
        if (addSpacing) const SizedBox(height: Dimensions.paddingSizeSmall),
        child,
      ],
    );
  }
}