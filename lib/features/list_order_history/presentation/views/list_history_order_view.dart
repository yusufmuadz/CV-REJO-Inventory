import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/order/sort_widget.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/list_history_order_controller.dart';

class ListHistoryOrderView extends GetView<ListHistoryOrderController> {
  const ListHistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List History Pesanan'),
        elevation: 1,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Untuk Android
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // Untuk iOS
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              if (controller.listDistrict.isEmpty) {
                controller.getDistrict();
              }

              Get.bottomSheet(
                SortWidget(controller: controller),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingView();
        }
        return RefreshIndicator(
          // edgeOffset: 65.0,
          onRefresh: () async {
            controller.onRefreshTransaction();
          },
          child: Column(
            children: [
              // Container(
              //   height: 42,
              //   margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: CupertinoSearchTextField(
              //     placeholder: 'Cari...',
              //     placeholderStyle: const TextStyle(
              //       color: Color(0xFF7C7C7C),
              //       fontSize: 13,
              //       fontFamily: 'Inter',
              //       fontWeight: FontWeight.w400,
              //       height: 0,
              //       letterSpacing: 0.39,
              //     ),
              //     prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
              //     controller: controller.searchController,
              //     onSubmitted: (value) {
              //       controller.onRefreshTransaction();
              //     },
              //     onSuffixTap: () {
              //       controller.searchController.clear();
              //       controller.onRefreshTransaction();
              //     },
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Divider(thickness: 1, height: 8, color: Colors.grey[100]),
              Expanded(child: _buildContent()),
            ],
          ),
        );
      }),
      // Column(
      //   children: [
      //     Container(
      //       height: 50,
      //       padding: EdgeInsets.all(5),
      //       margin: EdgeInsets.fromLTRB(16, 16, 16, 5),
      //       decoration: BoxDecoration(
      //         border: Border.all(width: 1, color: Color(0x2FD5914D)),
      //         borderRadius: BorderRadius.circular(100),
      //         color: Color.fromARGB(33, 46, 212, 112),
      //       ),
      //       child: TabBar(
      //         controller: controller.tabController,
      //         dividerHeight: 0.0,
      //         splashBorderRadius: BorderRadius.circular(100),
      //         labelColor: Colors.black,
      //         unselectedLabelColor: Colors.black,
      //         indicatorSize: TabBarIndicatorSize.tab,
      //         labelStyle: TextStyles.medium,
      //         unselectedLabelStyle: TextStyles.medium,
      //         indicator: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           color: Color(0x2FCF8E4D),
      //         ),
      //         tabs: [
      //           const Tab(text: 'Pesanan'),
      //           const Tab(text: 'Loader'),
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       child: TabBarView(
      //         controller: controller.tabController,
      //         children: [
      //           Obx(() {
      //             if (controller.isLoading.value) {
      //               return const LoadingView();
      //             }

      //             return RefreshIndicator(
      //               onRefresh: () async {
      //                 controller.onRefreshTransaction();
      //               },
      //               child: _buildContent(),
      //             );
      //           }),
      //           Container(),
      //           Obx(() {
      //             if (controller.isLoadingLoader.value) {
      //               return const LoadingView();
      //             }

      //             return RefreshIndicator(
      //               onRefresh: () async {
      //                 controller.onRefreshTransaction();
      //               },
      //               child: _buildContentLoader(),
      //             );
      //           }),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildEmptyOrder() {
    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: const Center(child: Text('Tidak ada pesanan')),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (controller.orders.isEmpty)
          _buildEmptyOrder()
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: controller.orders.length,
              (context, index) {
                OrderEntity transaction = controller.orders[index];
                return
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                //   child:
                _buildOrder(transaction: transaction);
                // );
              },
            ),
          ),
        // _buildListOrder(),
      ],
    );
  }

  Widget _buildContentLoader() {
    return CustomScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (controller.orders.isEmpty)
          _buildEmptyOrder()
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: controller.loaderOrders.length,
              (context, index) {
                OrderEntity transaction = controller.loaderOrders[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                  child: _buildOrder(transaction: transaction),
                );
              },
            ),
          ),
        // _buildListOrder(),
      ],
    );
  }

  Widget _buildOrder({required OrderEntity transaction}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: CustomCardList(
        onTap: () {
          Get.toNamed(
            Routes.DETAIL_ORDER,
            arguments: {
              'invoice': transaction.invoice,
              'routeFrom': 'listHistoryOrder',
            },
          );
        },
        isSelected: '',
        showSelection: false,
        transaction: transaction,
      ),
    );
  }
}
