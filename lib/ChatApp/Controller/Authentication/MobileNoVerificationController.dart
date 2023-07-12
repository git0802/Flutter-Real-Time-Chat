import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'AuthenticationRepository.dart';

class MobileNoVerificationController extends GetxController {
  TextEditingController phoneNumber = TextEditingController();
  String phoneString = '';
  bool phoneNumberIsEmpty = false;

  final AuthenticationRepository1 = Get.put(AuthenticationRepository());

  bool phoneNumberEmptyFunction() {
    bool results = false;

    if (phoneNumber.text == '' || phoneString == '') {
      results = phoneNumberIsEmpty = false;
      update();
    } else {
      results = phoneNumberIsEmpty = true;
      update();
    }
    return results;
  }
}
