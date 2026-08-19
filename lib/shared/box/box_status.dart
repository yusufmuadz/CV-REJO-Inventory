import 'package:flutter/material.dart';

import '../../core/middlewares/app_role.dart';

class BoxStatus {
  static String buildText({
    String statusPIC = '',
    String statusChecker1 = '',
    String statusChecker2 = '',
    String statusDriver = '',
    bool statusScanDriver = false,
    bool statusArriveDriver = false,
    bool statusDelivCancel = false,
  }) {
    String text = 'Checker';

    if (AppRole.isPIC || AppRole.isChecker1) {
      String status = statusPIC;

      if (statusPIC == 'completed' && AppRole.isChecker1) {
        status = statusChecker1;
      }

      if (status == 'available') {
        text = 'Available';
      } else if (status == 'ongoing') {
        text = 'Ongoing';
      } else if (status == 'completed') {
        text = 'Completed';
      }
    } else {
      if (statusChecker2 == 'completed') {
        text = 'Leader';
      }
    }

    if (AppRole.isDriver) {
      if (statusDelivCancel == true) {
        text = 'PENDING';
      } else {
        if (statusScanDriver) {
          text = 'READY';
        }

        if (statusArriveDriver) {
          text = 'COMPLETED';
        }

        if (!statusScanDriver && !statusArriveDriver) {
          text = 'AVAILABLE';
        }
      }
    }

    return text;
  }

  static Color buildColor({
    String statusPIC = '',
    String statusChecker1 = '',
    String statusChecker2 = '',
    String statusDriver = '',
    bool statusScanDriver = false,
    bool statusArriveDriver = false,
    bool statusDelivCancel = false,
  }) {
    Color color = Color(0xFF5eb75f);

    if (AppRole.isPIC || AppRole.isChecker1) {
      String status = statusPIC;

      if (statusPIC == 'completed' && AppRole.isChecker1) {
        status = statusChecker1;
      }

      if (status == 'available') {
        color = const Color(0xFF5eb75f);
      } else if (status == 'ongoing' || status == 'completed') {
        color = const Color(0xFF666666);
      }
    } else {
      if (statusChecker2 == 'ongoing') {
        color = const Color(0xFF5eb75f);
      } else if (statusChecker2 == 'completed') {
        color = const Color(0xFF666666);
      }
    }

    if (AppRole.isDriver) {
      if (statusDelivCancel == true) {
        color = const Color(0xFF666666);
      } else {
        if (statusScanDriver) {
          color = const Color(0xFF5eb75f);
        }

        if (statusArriveDriver) {
          color = const Color(0xFF666666);
        }

        if (!statusScanDriver && !statusArriveDriver) {
          color = const Color(0xFF2ED471);
        }
      }
    }

    return color;
  }
}
