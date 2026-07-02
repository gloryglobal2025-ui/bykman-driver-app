import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';

class ProfileTypeButtonWidget extends StatelessWidget {
  final int index;
  final String profileTypeName;
  const ProfileTypeButtonWidget({super.key, required this.index, required this.profileTypeName});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: InkWell(
          onTap: () => profileController.profileTypeIndex == index ? null :
              profileController.setProfileTypeIndex(index, isUpdate: true),
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(
                width: .5,
                color: index == profileController.profileTypeIndex ?
                Theme.of(context).colorScheme.onSecondary :
                Theme.of(context).primaryColor,
              ),
              color: index == profileController.profileTypeIndex ?
              Theme.of(context).primaryColor :
              Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(profileTypeName.tr,
                textAlign: TextAlign.center,
                style: textSemiBold.copyWith(
                  color: index == profileController.profileTypeIndex ?
                  Colors.white :
                  Theme.of(context).hintColor.withValues(alpha: .65),
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}