import 'package:cv_rejo/shared/text_field/textfield_shared.dart';
import 'package:cv_rejo/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Untuk Android
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // Untuk iOS
      ),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Assets.logo.logo.path,
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 50),

                Text(
                  'Silakan Masuk',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tracking Inventory',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SharedTextField(
                        controller: controller.userNameController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Username',
                        prefixIcon: Icon(
                          Ionicons.person_outline,
                          color: Colors.grey.shade600,
                        ),
                        validator: FormValidator.validateUsername,
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => SharedTextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isShowPassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.go,
                          labelText: 'Kata Sandi',
                          prefixIcon: Icon(
                            Ionicons.key_outline,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => controller.isShowPassword.toggle(),
                            icon: (controller.isShowPassword.value)
                                ? Icon(
                                    Ionicons.eye_outline,
                                    color: Colors.grey.shade600,
                                  )
                                : Icon(
                                    Ionicons.eye_off_outline,
                                    color: Colors.grey.shade600,
                                  ),
                          ),
                          validator: FormValidator.validateRequired,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: Get.width,
                        height: 40,
                        child: _buttonLogin(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      onPressed: () => controller.login(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFFF51BD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text('Masuk'),
    );
  }
}
