import 'package:cv_rejo/features/scan_product/presentation/controllers/scan_product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/loading_custom.dart';
import 'input_qty_dialog.dart';

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
    return DraggableScrollableSheet(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoSearchTextField(
                  placeholder: 'Pencarian Nama / Barcode',
                  placeholderStyle: const TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.39,
                  ),
                  controller: controller.searchController,
                  suffixMode: OverlayVisibilityMode.editing,
                  onSubmitted: (value) {
                    controller.getItemProduct();
                  },
                  onSuffixTap: () {
                    controller.searchController.clear();
                    controller.searchResults.clear();
                  },
                  // onTap: () {
                  //   controller.isSearching.value = true;
                  // },
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
