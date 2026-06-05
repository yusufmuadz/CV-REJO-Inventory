import 'package:cv_rejo/features/profile/presentation/widgets/profile_about_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/loading_custom.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../widgets/profile_button_logout_widget.dart';
import '../widgets/profile_header_widget.dart';

class ProfileView extends StatelessWidget {
  final HomeController controller;

  const ProfileView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingView();
      } else {
        return Stack(
          children: [
            // Background
            Container(color: const Color(0xFFE0048C)),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height, // Adjust height as needed
                width: double.infinity,
                padding: EdgeInsets.only(top: 80),
                // Adding border radius to the top corners
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildTitleBox(title: 'Setting'),
                    const SizedBox(height: 10),
                    _buildBoxItem(
                      title: 'Hubungi Admin',
                      icon: Assets.icons.hubungiadmin.path,
                      onTap: () => controller.onTapHubungiAdmin(),
                    ),
                    const SizedBox(height: 20),

                    // Tentang Aplikasi
                    _buildTitleBox(title: 'Tentang Aplikasi'),
                    ProfileAboutWidget(controller: controller,),
                    const SizedBox(height: 25),

                    // Keluar
                    ProfileButtonLogoutWidget(controller: controller,),
                  ],
                ),
              ),
            ),
            ProfileHeaderView(controller: controller),
            // _iconBack(),
          ],
        );
      }
    });
  }

  Widget _buildTitleBox({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Color(0xFF171717),
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
          letterSpacing: 0.45,
        ),
      ),
    );
  }

  Widget _iconBack() {
    return Positioned(
      top: 50,
      left: 20,
      child: InkWell(
        onTap: () => controller.changePage(0),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white30,
          ),
          child: Icon(Icons.arrow_back, size: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBoxItem({required String title, icon, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          leading: Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(icon)),
            ),
          ),
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Row(
              children: [
                const SizedBox(width: 8), // Jarak antara ikon dan teks
                Text(title, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}
