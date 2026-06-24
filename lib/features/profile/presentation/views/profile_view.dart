import 'package:cv_rejo/features/profile/presentation/widgets/profile_about_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../core/theme/text_styles.dart';
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
    // final profileController = controller.homeProfileController;

    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingView();
      } else {
        return Stack(
          children: [
            Container(color: const Color(0xFFf7f7f7)),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Image.asset(
                Assets.images.bgProfile.path,
                // fit: BoxFit.cover,
              ),
            ),
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              children: [
                Text(
                  'Profile',
                  style: TextStyles.basicTextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D2130),
                    fontFamily: GoogleFonts.nunitoSans().fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelola informasi akun Anda',
                  style: TextStyles.basicTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    fontFamily: GoogleFonts.nunitoSans().fontFamily,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 134,
                  width: 134,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipOval(child: Image.asset(Assets.logo.logo.path)),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    AppRole.name?.capitalize ?? '-',
                    style: TextStyles.basicTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D2130),
                      fontFamily: GoogleFonts.nunitoSans().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe1f7e9),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF35bd64),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppRole.current?.name.capitalizeFirst ?? '-',
                          style: TextStyles.basicTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF07ab43),
                            fontFamily: GoogleFonts.nunitoSans().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildBoxItem(
                  title: 'Hubungi Admin',
                  icon: Ionicons.call_outline,
                  onTap: () {},
                ),
                const Divider(
                  thickness: 1,
                  height: 20,
                  color: Color(0xFFebecf2),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Ionicons.information_circle_outline,
                      size: 20,
                      color: const Color(0xFFBA832B),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Tentang Aplikasi',
                      style: TextStyles.basicTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        fontFamily: GoogleFonts.nunitoSans().fontFamily,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                _buildBoxItem(
                  title: 'App Version',
                  height: 40,
                  width: 40,
                  icon: Ionicons.cube_outline,
                  onTap: () {},
                ),
              ],
            ),
            // Background
            // Positioned(
            //   top: 200,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     height: Get.height, // Adjust height as needed
            //     width: double.infinity,
            //     padding: EdgeInsets.only(top: 80),
            //     // Adding border radius to the top corners
            //     decoration: const BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(30),
            //         topRight: Radius.circular(30),
            //       ),
            //     ),
            //     child: ListView(
            //       physics: const BouncingScrollPhysics(),
            //       children: [
            //         _buildTitleBox(title: 'Setting'),
            //         const SizedBox(height: 10),
            //         _buildBoxItem(
            //           title: 'Hubungi Admin',
            //           icon: Assets.icons.hubungiadmin.path,
            //           onTap: () => ContactService.onTapHubungiAdmin(),
            //         ),
            //         const SizedBox(height: 20),

            //         // Tentang Aplikasi
            //         _buildTitleBox(title: 'Tentang Aplikasi'),
            //         ProfileAboutWidget(controller: controller),
            //         const SizedBox(height: 25),

            //         // Keluar
            //         ProfileButtonLogoutWidget(controller: controller),
            //       ],
            //     ),
            //   ),
            // ),
            // ProfileHeaderView(controller: controller),
            // // _iconBack(),
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

  Widget _buildBoxItem({
    required String title,
    required IconData icon,
    required Function onTap,
    double height = 45,
    double width = 45,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
      leading: Container(
        height: height,
        width: width,
        // padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFf5ede4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF857467)),
      ),
      title: Transform.translate(
        offset: const Offset(5, 0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            title,
            style: TextStyles.basicTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              fontFamily: GoogleFonts.nunitoSans().fontFamily,
            ),
          ),
        ),
      ),
      subtitle: Transform.translate(
        offset: const Offset(5, 0),
        child: Text(
          'Butuh bantuan? Hubungi admin',
          style: TextStyles.basicTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            fontFamily: GoogleFonts.nunitoSans().fontFamily,
          ),
        ),
      ),
      trailing: Icon(
        Ionicons.chevron_forward_outline,
        size: 20,
        color: const Color(0xFF1E293B),
      ),
      onTap: () {},
    );
  }
}
