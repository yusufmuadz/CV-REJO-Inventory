import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/rit/shared_card_rit.dart';
import '../../../../shared/rit/shared_detail_po_rit.dart';
import '../../../../shared/rit/shared_input_driver.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_rit_sisipan_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';

class HomeRitSisipanView extends StatelessWidget {
  final HomeController homeController;

  const HomeRitSisipanView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBarWidget().content(
            title: 'RIT Sisipan',
            isActionIcon: false,
            controller: homeController,
          ),
          Expanded(
            child: Obx(() {
              if (homeController.homeRitSisipanController.isLoading.value) {
                return const LoadingView();
              }
              return _buildContent();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final controller = homeController.homeRitSisipanController;

    // 1. Buat ScrollController lokal agar fresh setiap kali widget dibangun
    final localScrollController = ScrollController();

    return RefreshIndicator(
      onRefresh: () async => controller.onRefreshRIT(),
      child: PrimaryScrollController(
        controller: localScrollController,
        child: Builder(
          builder: (context) {
            // 2. Pasang listener langsung ke localScrollController untuk mendeteksi scroll
            localScrollController.removeListener(
              () {},
            ); // Bersihkan listener lama jika terjadi re-render
            localScrollController.addListener(() {
              // Kirim instance scroll aktif ke fungsi di GetX Controller Anda
              // controller.onWidgetScroll(localScrollController);
            });

            return Obx(() {
              final isPlusOne =
                  controller.getLoadState.value != LoadState.initial &&
                  controller.getLoadState.value != LoadState.idle;
              return CustomScrollView(
                // 3. Pasang localScrollController ke CustomScrollView Anda
                controller: localScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (controller.listRit.isEmpty)
                    _buildEmptyOrder()
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 15),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount:
                              controller.listRit.length + (isPlusOne ? 1 : 0),
                          (context, index) {
                            if (index == controller.listRit.length) {
                              return _buildBottomIndicator(
                                controller.getLoadState.value,
                                controller.retryFetch,
                              );
                            }

                            return _buildOrder(
                              index: index,
                              ritEntity: controller.listRit[index],
                              controller: controller,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildOrder({
    required int index,
    required RitListEntity ritEntity,
    required HomeRitSisipanController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SharedCardRIT(
        isSelected: false,
        totalPO: ritEntity.totalPO,
        noRIT: ritEntity.city,
        dateRIT: ritEntity.tanggalRit,
        colorRIT: int.parse('0xFF${ritEntity.color.replaceAll('#', '')}'),
        routeRIT: ritEntity.route,
        isSelection: false.obs,
        onTap: () async {
          if (controller.listUser.isEmpty) {
            controller.getAssisten();
          }
          _openPopUp(ritEntity: ritEntity);
        },
        onTapSeePO: () {
          controller.getPO(noRIT: ritEntity.city, date: ritEntity.tanggalRit);
          controller.dialogService.defaultDialog(
            height: 0.5,
            singleButton: true,
            title: 'Detail RIT - ${ritEntity.city}',
            titleButton1: 'Kembali',
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            content: SharedDetailPoRit(
              isLoading: controller.isLoadingPO,
              orders: controller.listOrder,
              retryFetch: () => controller.getPO(
                noRIT: ritEntity.city,
                date: ritEntity.tanggalRit,
              ),
            ),
          );
        },
      ),
    );
  }

  void _openPopUp({required RitListEntity ritEntity}) {
    final controller = homeController.homeRitSisipanController;

    controller.dialogService.inputDialog(
      height: 0.6,
      title: 'Masukkan Muat Barang',
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      onPressed1: () {
        if (controller.isLoadingAssistant.value) return;

        Get.back(result: false);
      },
      onPressed2: () async {
        if (controller.isLoadingAssistant.value) return;

        controller.addAssistant(
          noRIT: ritEntity.city,
          tanggalRIT: ritEntity.tanggalRit,
        );
      },
      content: Obx(() {
        if (controller.isLoadingAssistant.value) {
          return SizedBox(width: Get.width, child: const LoadingView());
        }

        return SharedInputDriver(
          isDetail: true,
          noRIT: ritEntity.city,
          statusTransportationSelected: controller.statusTransportationSelected,
          statusTransportations: controller.statusTransportations,
          driverSelected: controller.driverSelected,
          assistantSelected: controller.assistantSelected,
          nopolTransportation: controller.nopolTransportation,
          selectTransportation: controller.selectTransportation,
          listUser: controller.listUser,
          transportations: controller.transportations,
          onRefreshAssistant: () => controller.getAssisten(),
        );
      }),
    );
  }

  Widget _buildEmptyOrder() {
    String message = 'Tidak ada pesanan';

    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
    );
  }

  Widget _buildBottomIndicator(LoadState state, VoidCallback onRetry) {
    switch (state) {
      case LoadState.loadingMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: LoadingView(),
        );

      case LoadState.noMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              '✨ Tidak ada data lagi',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );

      case LoadState.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
