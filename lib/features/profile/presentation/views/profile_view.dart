import 'package:cv_rejo/features/profile/presentation/widgets/profile_about_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/constants/app_info.dart';
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
    final profileController = controller.homeProfileController;

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
              padding: const EdgeInsets.fromLTRB(13, 38, 13, 16),
              children: [
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
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    AppRole.name?.capitalize ?? '-',
                    style: TextStyles.basicTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1D2130),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF35bd64),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppRole.current?.name.capitalizeFirst ?? '-',
                          style: TextStyles.basicTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF07ab43),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildBoxStyle(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVersionStyle(
                        title: 'VERSION',
                        icon: Icons.inventory_2_outlined,
                        colorBgIcon: const Color(0xFFE8F7F0),
                        colorIcon: const Color(0xFF28A745),
                        value: AppInfo.version,
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: const Color(0xFFF3F4F6),
                      ),
                      _buildVersionStyle(
                        title: 'UPDATED',
                        isIconRight: true,
                        icon: Icons.calendar_today_outlined,
                        colorBgIcon: const Color(0xFFEFF6FF),
                        colorIcon: const Color(0xFF2563EB),
                        value: AppInfo.updatedAt,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildBoxStyle(
                  child: Column(
                    children: [
                      _buildContentStyle(
                        title: 'Hubungi Admin',
                        icon: Icons.headset_mic_outlined,
                        colorBgIcon: const Color(0xFFEFF6FF),
                        colorIcon: const Color(0xFF2563EB),
                        value: 'Butuh bantuan? Hubungi admin',
                        onTap: () => ContactService.onTapHubungiAdmin(),
                      ),
                      _buildContentStyle(
                        title: 'Syarat & Ketentuan',
                        isBorderTop: true,
                        isBorderBottom: true,
                        icon: Icons.description_outlined,
                        colorBgIcon: const Color(0xFFE8F7F0),
                        colorIcon: const Color(0xFF28A745),
                        value: 'Baca syarat & ketentuan',
                        onTap: () => profileController.onTapTermsAndCondition(),
                      ),
                      _buildContentStyle(
                        title: 'Kebijakan Privasi',
                        isBorderBottom: true,
                        icon: Icons.shield_outlined,
                        colorBgIcon: const Color(0xFFFFF7ED),
                        colorIcon: const Color(0xFFEA580C),
                        value: 'Pelajari kebijakan privasi kami',
                        onTap: () => profileController.onTapPrivacyPolicy(),
                      ),
                      Obx(
                        () => _buildContentStyle(
                          title: 'Hapus Cache',
                          isBorderBottom: true,
                          icon: Icons.delete_sweep_outlined,
                          colorBgIcon: const Color(0xFFf0f6ff),
                          colorIcon: const Color(0xFF2664eb),
                          value:
                              'Bersihkan penyimpanan aplikasi(${controller.cacheSize.value})',
                          onTap: () => profileController.onTapClearCache(),
                        ),
                      ),
                      _buildContentStyle(
                        title: 'Logout',
                        isRadius: true,
                        bgColor: const Color(0xFFFEF2F2),
                        colorText: const Color(0xFFEF4444),
                        colorValue: const Color(0xFFEF4444),
                        icon: Icons.logout_outlined,
                        colorBgIcon: const Color(0xFFFEE2E2),
                        colorIcon: const Color(0xFFEF4444),
                        colorIconArrow: const Color(0xFFEF4444),
                        value: 'Keluar dari akun',
                        onTap: () => profileController.onTapLogout(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }
    });
  }

  Widget _buildBoxStyle({EdgeInsetsGeometry? padding, required Widget child}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFF9FAFB)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildVersionStyle({
    required String title,
    required String value,
    required IconData icon,
    required Color colorBgIcon,
    required Color colorIcon,
    bool isIconRight = false,
  }) {
    return Expanded(
      child: Row(
        children: [
          Visibility(
            visible: !isIconRight,
            child: _buildIconStyle(
              icon: icon,
              colorBgIcon: colorBgIcon,
              colorIcon: colorIcon,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.basicTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              Text(
                value,
                style: TextStyles.basicTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D2D44),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isIconRight,
            child: _buildIconStyle(
              icon: icon,
              colorBgIcon: colorBgIcon,
              colorIcon: colorIcon,
              margin: const EdgeInsets.only(left: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentStyle({
    required String title,
    required String value,
    required IconData icon,
    required Color colorBgIcon,
    required Color colorIcon,
    bool isRadius = false,
    bool isBorderTop = false,
    bool isBorderBottom = false,
    Color? bgColor,
    Color colorIconArrow = const Color(0xFF9CA3AF),
    Color colorText = const Color(0xFF1D2D44),
    Color colorValue = const Color(0xFF9CA3AF),
    Function()? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isRadius
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : null,
        border: Border(
          top: isBorderTop
              ? BorderSide(color: const Color(0xFFF9FAFB), width: 1)
              : BorderSide.none,
          bottom: isBorderBottom
              ? BorderSide(color: const Color(0xFFF9FAFB), width: 1)
              : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _buildIconStyle(
              height: 48,
              width: 48,
              size: 23,
              icon: icon,
              colorBgIcon: colorBgIcon,
              colorIcon: colorIcon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.basicTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorText,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyles.basicTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colorValue,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Ionicons.chevron_forward_outline,
              size: 20,
              color: colorIconArrow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconStyle({
    required IconData icon,
    required Color colorBgIcon,
    required Color colorIcon,
    double? height,
    double? width,
    double? size,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      height: height ?? 40,
      width: width ?? 40,
      margin: margin ?? const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: colorBgIcon),
      child: Icon(icon, size: size ?? 14, color: colorIcon),
    );
  }
}
