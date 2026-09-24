import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../controllers/home_retur_controller.dart';
import 'retur_item_dialog.dart';

class ReturItemHeader extends StatelessWidget {
  final bool isRelated;
  final bool isIcon;
  final bool isCheckbox;
  final int? index;
  final String? title;
  final String? number;
  final bool? valueCheckbox;
  final Function(bool?)? onChanged;
  final HomeReturController controller;

  const ReturItemHeader({
    super.key,
    this.isIcon = true,
    this.isCheckbox = true,
    this.index,
    this.title,
    this.number,
    this.valueCheckbox,
    this.onChanged,
    required this.isRelated,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildHeaderLeft(),
        const SizedBox(width: 10),
        _buildLabel(),
        const SizedBox(width: 10),
        _buildAdd(),
        _buildClose(),
        _buildCheck(),
      ],
    );
  }

  Widget _buildAdd() {
    return Visibility(
      visible: !isRelated && isIcon,
      child: InkWell(
        onTap: () => ReturItemDialog.show(controller: controller),
        child: const Icon(
          Icons.add_circle_outline_outlined,
          size: 28,
          color: Color(0xFFd68f4d),
        ),
      ),
    );
  }

  Widget _buildClose() {
    return Visibility(
      visible: !isRelated && title != null && !isIcon,
      child: InkWell(
        onTap: () {
          controller.itemPoAddRetur.removeAt(index ?? 0);
        },
        child: const Icon(
          Ionicons.close_circle_outline,
          size: 28,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildCheck() {
    return Visibility(
      visible: isRelated && isCheckbox,
      child: Checkbox(
        value: valueCheckbox,
        onChanged: onChanged,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _buildLabel() {
    String resultTitle = 'PILIH SEMUA';

    if (!isRelated) {
      resultTitle = 'TAMBAH BARANG';
    }

    if (title != null) {
      resultTitle = title ?? '';
    }
    return Expanded(
      child: Text(
        resultTitle,
        style: GoogleFonts.hankenGrotesk(
          color: const Color(0xFF524439),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.48,
        ),
      ),
    );
  }

  Widget _buildHeaderLeft() {
    if (isIcon) {
      return const SizedBox(
        width: 30,
        child: Icon(
          Icons.checklist_rounded,
          size: 24,
          color: Color(0xFF857467),
        ),
      );
    }
    return SizedBox(
      width: 30,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: GoogleFonts.hankenGrotesk(
          color: const Color(0xFF857467),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.48,
        ),
      ),
    );
  }
}
