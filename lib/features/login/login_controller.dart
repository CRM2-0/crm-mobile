import 'package:get/get.dart';

class LoginController extends GetxController {
  final _passwordVisible = false.obs;

  bool get passwordVisible => _passwordVisible.value;

  void togglePasswordVisibility() {
    _passwordVisible.toggle();
  }
}
