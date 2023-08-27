import 'package:get/get.dart';

class LanguageController extends GetxController {
  var language = 0.obs;

  changeLanguage(int index) {
    language.value = index;
    update();
  }
}
