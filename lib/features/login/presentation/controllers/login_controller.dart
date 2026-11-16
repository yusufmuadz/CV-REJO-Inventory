import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../modules/domain/params/auth/login_param.dart';
import '../../../../modules/domain/usecases/auth/auth_usecase.dart';
import '../../../../routes/app_pages.dart';
import '../../domain/entities/user_entity.dart';

class LoginController extends GetxController {
  final AuthUseCase authUseCase;

  LoginController({required this.authUseCase});

  late TokenStorage _tokenStorage;
  final dialogService = Get.find<DialogService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isShowPassword = false.obs;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    _tokenStorage = Get.find<TokenStorage>();
  }

  @override
  void onClose() {
    super.onClose();
    userNameController.dispose();
    passwordController.dispose();
  }

  Future<void> login() async {
    isLoading.value = true;
    dialogService.showLoading();

    final result = await authUseCase.callLogin(
      param: LoginParam(
        username: userNameController.text,
        password: passwordController.text,
      ),
    );

    switch (result) {
      case Success(:final data):
        // debugPrint('Data Login Controller: $data');
        _handleSuccessResponse(result, data);

      case ErrorResult(:final message):
        if (Get.isDialogOpen == true) Get.back();
        // loadState.value = LoadState.error;
        dialogService.showError('Login Failed', message);
    }

    isLoading.value = false;
  }

  void _handleSuccessResponse(dynamic result, UserEntity data) {
    if (data.token != null) {
      _tokenStorage.saveToken(
        accessToken: data.token!,
        refreshToken: data.token!,
      );

      Map<String, dynamic> userMap = data.toJson();
      String json = jsonEncode(userMap);

      GetStorage().write('user', json);
      // dialogService.showSuccess('Login Success');
      AppRole.loginFromApi(role: data.jabatan, name: data.nama);
      Future.delayed(Duration(milliseconds: 300));
      Get.offAllNamed(Routes.HOME);
    } else {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Login Failed', result.failure ?? 'Error');
    }
  }
}
