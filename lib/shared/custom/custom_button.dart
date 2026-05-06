import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomButton {
  /// ===== BASIC BUTTON =====
  static Widget basicButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
    Size? minimumSize,
    Color? shadowColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        foregroundColor: Colors.white,
        backgroundColor: color,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ===== DOUBLE BUTTON =====
  static Widget doubleButton({
    required String title1,
    required String title2,
    required Color color1,
    required Color color2,
    required VoidCallback onPressed1,
    required VoidCallback onPressed2,
    bool visible1 = true,
    bool visible2 = true,
    bool visibleSpace = true,
    Size? minimumSize,
    Color? shadowColor,
  }) {
    return Row(
      children: [
        Visibility(
          visible: visible1,
          child: Expanded(
            child: basicButton(
              title: title1,
              color: color1,
              onPressed: onPressed1,
              shadowColor: shadowColor,
              minimumSize: minimumSize,
            ),
          ),
        ),
        Visibility(visible: visibleSpace, child: const SizedBox(width: 10)),
        Visibility(
          visible: visible2,
          child: Expanded(
            child: basicButton(
              title: title2,
              color: color2,
              onPressed: onPressed2,
              shadowColor: shadowColor,
              minimumSize: minimumSize,
            ),
          ),
        ),
      ],
    );
  }

  /// ===== BOTTOM BAR STYLE =====
  static Widget bottomBarStyle({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget bottomBarIcon({required HomeController controller}) {
    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        // iconSize: 26,
        backgroundColor: Colors.white,
        currentIndex: controller.tabIndex.value,
        selectedItemColor: Color(0xFF06823f),
        unselectedItemColor: Color(0xFFC3C3C3),
        // selectedLabelStyle: TextStyle(
        //   fontFamily: 'Inter',
        //   fontSize: 14,
        //   fontWeight: FontWeight.w500,
        //   color: Color(0xFF06823f),
        // ),
        // unselectedLabelStyle: TextStyle(
        //   fontFamily: 'Inter',
        //   fontSize: 14,
        //   fontWeight: FontWeight.w500,
        //   color: Color(0xFFC3C3C3),
        // ),
        type: BottomNavigationBarType.fixed,
        elevation: 1,
        onTap: (index) {
          controller.tabIndex.value = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline, color: Color(0xFF8890a0)),
            activeIcon: Icon(Ionicons.home, color: Color(0xFF06823f)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.document_text_outline,
              color: Color(0xFF8890a0),
            ),
            activeIcon: Icon(Ionicons.document_text, color: Color(0xFF06823f)),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.time_outline, color: Color(0xFF8890a0)),
            activeIcon: Icon(Ionicons.time, color: Color(0xFF06823f)),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.person_circle_outline,
              color: Color(0xFF8890a0),
            ),
            activeIcon: Icon(
              Ionicons.person_circle_sharp,
              color: Color(0xFF06823f),
            ),
            label: 'Profil',
          ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/task-edit-02-1.svg'),
          //   activeIcon: SvgPicture.asset(
          //     'assets/icons/task-edit-02-1.svg',
          //     colorFilter: ColorFilter.mode(
          //       const Color(0xFF00336A),
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   label: 'Task',
          // ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/sticky-note-02.svg'),
          //   activeIcon: SvgPicture.asset(
          //     'assets/icons/sticky-note-02.svg',
          //     colorFilter: ColorFilter.mode(
          //       const Color(0xFF00336A),
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   label: 'PKTR',
          // ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/Frame-1.svg'),
          //   activeIcon: SvgPicture.asset(
          //     'assets/icons/Frame-1.svg',
          //     colorFilter: ColorFilter.mode(
          //       const Color(0xFF00336A),
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   label: 'Akun',
          // ),
        ],
      ),
    );
  }
}
