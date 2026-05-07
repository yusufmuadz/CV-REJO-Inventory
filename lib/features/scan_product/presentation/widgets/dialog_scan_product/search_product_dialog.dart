import 'package:cv_rejo/features/scan_product/presentation/controllers/scan_product_controller.dart';
import 'package:cv_rejo/shared/custom/custom_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/loading_custom.dart';

void showSearchProduct() {
  Get.bottomSheet(
    SearchProduct(),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}

class SearchProduct extends StatelessWidget {
  final controller = Get.find<ScanProductController>();

  SearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    const Text(
                      'Cari Produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!controller.controllerScanner.value.isStarting) {
                          controller.startScanner();
                        }
                        Get.back();
                      },
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1, height: 20, color: Colors.grey.shade200),
                SizedBox(
                  height: 42,
                  child: CustomSearchField(
                    placeholder: 'Pencarian Nama / Barcode',
                    searchController: controller.searchController,
                    onSubmitted: (value) {
                      controller.getItemProduct();
                    },
                    onSuffixTap: () {
                      controller.searchController.clear();
                      controller.searchResults.clear();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: buildViewSearch(scrollController: scrollController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildViewSearch({required ScrollController scrollController}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: LoadingView());
      }

      if (controller.searchResults.isEmpty) {
        return const Center(
          child: Text(
            'Data tidak ditemukan',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.searchResults.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemBuilder: (context, index) {
          final item = controller.searchResults[index];
          return Container(
            color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
            child: ListTile(
              dense: true,
              title: Text(
                item.nama,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(item.barcode),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              onTap: () {
                // openInputQtyDialog(
                //   itemName: item.nama,
                //   barcodeValue: item.barcode,
                //   controller: controller,
                // );
                controller.getProduct(item.barcode);
              },
            ),
          );
        },
      );
    });
  }
}
