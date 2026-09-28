import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../core/constants/app_info.dart';
import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/services/contact_service.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../gen/assets.gen.dart';
import '../../controllers/home_controller.dart';

class DrawerWidget extends StatelessWidget {
  final HomeController controller;

  const DrawerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.8,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Obx(
            () => Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final element = controller.homePageController.listMenu[index];

                  return _buildTile(
                    title: element['label'] as String,
                    isHold: index == 1,
                    isSelected: element['isSelected'] as bool,
                    icon: element['icon'] as IconData,
                    activeIcon: element['activeIcon'] as IconData,
                    onTap: () {
                      // controller.homePageController.listMenu[index]['isSelected'] = true;
                      // controller.listMenu.update(controller.listMenu);
                      Get.back();
                      controller.homePageController.selectMenu(index);
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: controller.homePageController.listMenu.length,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: const Color(0xFFD7C3B4)),
              ),
              color: const Color(0xFFF0F3FF),
            ),
            child: Column(
              children: [
                _buildTileBottom(
                  title: 'Hubungi Admin',
                  desc: 'Bantuan & kendala sistem',
                  icon: Icons.headset_mic_outlined,
                  onTap: () => ContactService.onTapHubungiAdmin(),
                ),
                const SizedBox(height: 8),
                _buildTileBottom(
                  title: 'Hapus Cache',
                  desc: 'Bersihkan data lokal',
                  value: controller.cacheSize.value,
                  icon: Icons.delete_sweep_outlined,
                  onTap: () =>
                      controller.homeProfileController.onTapClearCache(),
                ),
                const SizedBox(height: 8),
                _buildTile(
                  title: 'Logout',
                  isMargin: false,
                  icon: Icons.logout_outlined,
                  activeIcon: Icons.logout_outlined,
                  onTap: () => controller.homeProfileController.onTapLogout(),
                ),
                const SizedBox(height: 14),
                Text(
                  'App ${AppInfo.versionLabel} • Upd: ${AppInfo.updatedAt}',
                  style: TextStyles.basicTextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    color: const Color(0xFF5D5E61),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required String title,
    bool isHold = false,
    bool isSelected = false,
    bool isMargin = true,
    required IconData icon,
    required IconData activeIcon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        // margin: isMargin ? const EdgeInsets.symmetric(horizontal: 16) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isSelected
              ? null
              : Border.all(width: 0.5, color: const Color(0x55D7C3B4)),
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? const Color(0xFFFFDCC1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isHold ? const Color(0xCDD7C3B4) : const Color(0xFF524439),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyles.basicTextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                color: isHold
                    ? const Color(0xCDD7C3B4)
                    : const Color(0xFF6C3A00),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileBottom({
    required String title,
    required String desc,
    String? value,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xFFD7C3B4)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFDCE2F3),
              ),
              child: Icon(icon, size: 20, color: Color(0xFF524439)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.basicTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      color: const Color(0xFF151C27),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyles.basicTextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      color: const Color(0xFF524439),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Visibility(
              visible: value == null,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: const Color(0xFF524439),
              ),
            ),
            Visibility(
              visible: value != null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFE2E2E5),
                ),
                child: Text(
                  value ?? '-',
                  style: TextStyles.basicTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    color: const Color(0xFF5D5E61),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        controller.homePageController.changePage(5);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 45, 16, 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: Color(0xFFD7C3B4)),
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2.5, color: Color(0xFFFFDCC1)),
                // color: Colors.white,
              ),
              child: ClipOval(child: Image.asset(Assets.logo.logo.path)),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppRole.name?.capitalize ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.basicTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      color: const Color(0xFF151C27),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppRole.current?.name.capitalizeFirst ?? '-',
                    style: TextStyles.basicTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      color: const Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: const Color(0xFF524439),
            ),
          ],
        ),
      ),
    );
  }
}
