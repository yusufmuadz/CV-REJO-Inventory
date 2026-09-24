import 'package:flutter/material.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../controllers/home_retur_controller.dart';
import 'retur_item_list.dart';

class ReturForm extends StatefulWidget {
  final HomeReturController controller;

  const ReturForm({super.key, required this.controller});

  @override
  State<ReturForm> createState() => _ReturFormState();
}

class _ReturFormState extends State<ReturForm> {
  late final TextEditingController nameMarketController;
  late final TextEditingController nameCustomerController;
  late final TextEditingController addressMarketController;

  @override
  void initState() {
    super.initState();

    nameMarketController = TextEditingController();
    nameCustomerController = TextEditingController();
    addressMarketController = TextEditingController();
  }

  @override
  void dispose() {
    nameMarketController.dispose();
    nameCustomerController.dispose();
    addressMarketController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildForm(
            title: 'Nama Customer',
            hintText: 'Masukkan nama customer',
            controller: nameCustomerController,
          ),
          const SizedBox(height: 15),
          _buildForm(
            title: 'Nama Toko*',
            hintText: 'Masukkan nama toko',
            controller: nameMarketController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'Masukkan nama toko';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          _buildForm(
            maxLines: 4,
            title: 'Alamat Toko*',
            controller: addressMarketController,
            hintText: 'Masukkan alamat toko',
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'Masukkan alamat toko';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          _buildLabel(title: 'Pilih Barang Retur'),
          ReturItemList(controller: widget.controller),
        ],
      ),
    );
  }

  Widget _buildLabel({required String title}) {
    return Text(
      title,
      style: TextStyles.basicTextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.38,
      ),
    );
  }

  Widget _buildForm({
    int? maxLines,
    required String title,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title: title),
        const SizedBox(height: 5),
        SharedTextField(
          maxLines: maxLines,
          isDense: true,
          controller: controller,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          validator: validator,
        ),
      ],
    );
  }
}
