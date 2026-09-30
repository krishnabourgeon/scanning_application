import 'package:adwaitha_sangamam/models/login_response_model.dart';
import 'package:adwaitha_sangamam/services/provider_helper_class.dart';
import 'package:adwaitha_sangamam/services/shared_preference_helper.dart';
import 'package:adwaitha_sangamam/services/validation_helper.dart';
import 'package:flutter/cupertino.dart';


class AuthProvider extends ChangeNotifier with ProviderHelperClass {
  TextEditingController loginNameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  String? errorToast;
  String? userNameValidationMessage;
  String? passwordValidationMessage;
  bool isLoginFormValidated = false;
  bool isRememberCredentials = true;
  String? name;

  Future<void> login({Function? onSuccess, Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    var res = await serviceConfig.login(
        name: loginNameController.text,
        password: loginPasswordController.text);
    if (res.isValue) {
      LoginResponseModel loginResponseModel = res.asValue!.value;
      name = loginResponseModel.user.name;
      if (isRememberCredentials) {
        await SharedPreferenceHelper.saveToken(loginResponseModel.token);

        //  await SharedPreferenceHelper.savesetting(loginResponseModel. ?? '');
      }
      if (onSuccess != null) onSuccess();
      updateLoadState(LoaderState.loaded);
    } else {
      errorToast = 'Login failed';
      if (onFailure != null) onFailure();
      updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await SharedPreferenceHelper.clearWholeData();
    name = null;
    clearValues();
  }

  
  updateValidationMessages(
      {required ValidationTypes validationType,
      required String validationMessage}) {
    switch (validationType) {
      case ValidationTypes.name:
        // if (validationMessage.isNotEmpty) {
        //   nameValidationMessage = validationMessage;
        // } else {
        //   nameValidationMessage = null;
        // }

        break;

      case ValidationTypes.email:
        // if (validationMessage.isNotEmpty) {
        //   emailValidationMessage = validationMessage;
        // } else {
        //   emailValidationMessage = null;
        // }
        break;
      case ValidationTypes.punnyamCode:
        // if (validationMessage.isNotEmpty) {
        //   punnyamCodeValidationMessage = validationMessage;
        // } else {
        //   punnyamCodeValidationMessage = null;
        // }
        break;
      case ValidationTypes.password:
        if (validationMessage.isNotEmpty) {
          passwordValidationMessage = validationMessage;
        } else {
          passwordValidationMessage = null;
        }
        break;
      case ValidationTypes.confirmPassword:
        // if (validationMessage.isNotEmpty) {
        //   confirmPasswordValidationMessage = validationMessage;
        // } else {
        //   confirmPasswordValidationMessage = null;
        // }
        break;
      case ValidationTypes.userName:
        if (validationMessage.isNotEmpty) {
          userNameValidationMessage = validationMessage;
        } else {
          userNameValidationMessage = null;
        }
        break;

      default:
        break;
    }
    updateLoginFormState();
    notifyListeners();
  }

  updateLoginFormState() {
    if (loginNameController.text.isNotEmpty &&
        loginPasswordController.text.isNotEmpty &&
        userNameValidationMessage == null) {
      isLoginFormValidated = true;
    } else {
      isLoginFormValidated = false;
    }
    debugPrint('is login form validated $isLoginFormValidated');
    notifyListeners();
  }

  

  updateRememberMeValue(bool value) {
    isRememberCredentials = value;
    notifyListeners();
  }

  clearValues() {
    loginNameController.clear();
    loginPasswordController.clear();
    userNameValidationMessage = null;
    // confirmPasswordValidationMessage = null;
    userNameValidationMessage = null;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
