import 'package:ride_sharing_user_app/util/images.dart';

class ProfileHelper{

  static   String checkImageExtensions(String fileName){
    String extension = fileName.split('.').last;
    switch (extension){
      case 'cvc':
        return Images.cvcIcon;
      case 'cvs':
        return Images.cvsIcon;
      case 'doc':
        return Images.docIcon;
      case 'jpeg':
        return Images.jpegIcon;
      case 'jpg':
        return Images.jpgIcon;
      case 'pdf':
        return Images.pdfIcon;
      case 'png':
        return Images.pngIcon;
      case 'webp':
        return Images.webpIcon;
      case 'xls':
        return Images.xlsIcon;
      case 'xlsx':
        return Images.xlsxIcon;
      default:
        return Images.filePreview;
    }
  }

}