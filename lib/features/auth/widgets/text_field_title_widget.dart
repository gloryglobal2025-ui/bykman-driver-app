import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TextFieldTitleWidget extends StatelessWidget {
  final String title;
  final double? paddingTop;
  final bool isRequired;
  const TextFieldTitleWidget({super.key, required this.title, this.paddingTop, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(padding:EdgeInsets.fromLTRB(0, paddingTop ?? 17, 0, 5),
      child: Row(children: [
        Text(
          title, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyMedium!.color!),
        ),

        if(isRequired)
          Text('*',
            style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).colorScheme.error),
          ),
      ]),
    );
  }
}
