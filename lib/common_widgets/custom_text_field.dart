import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextInputType inputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction inputAction;
  final int maxLines;
  final bool prefix;
  final bool read;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.controller,
    this.focusNode,
    this.inputAction = TextInputAction.done,
    this.maxLines = 1,
    this.borderRadius = 50,
    this.prefix = false,
    this.read = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode.dispose();
      }
      _internalFocusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _internalFocusNode,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      maxLines: widget.maxLines,
      readOnly: widget.read,
      style: textRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: textRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).hintColor.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
      ),
    );
  }
}
