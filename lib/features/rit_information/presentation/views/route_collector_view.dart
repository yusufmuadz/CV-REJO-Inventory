import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/rit/shared_card_rit.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/route_collector_entity.dart';
import '../controllers/inv_controller.dart';
import '../controllers/rit_controller.dart';

class RouteCollectorView extends StatelessWidget {
  final RitController masterCtrlr;
  const RouteCollectorView({super.key, required this.masterCtrlr});

  @override
  Widget build(BuildContext context) {
    final controller = masterCtrlr.invController;

    return _buildContent(controller: controller);
  }

  Widget _buildContent({required InvController controller}) {
    final localScrollController = ScrollController();

    return RefreshIndicator(
      onRefresh: () async => controller.onRefreshRouteCollector(),
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
                  controller.ritController.loadState.value !=
                      LoadState.initial &&
                  controller.ritController.loadState.value != LoadState.idle;
              return CustomScrollView(
                // 3. Pasang localScrollController ke CustomScrollView Anda
                controller: localScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (controller.listRouteCollector.isEmpty)
                    _buildEmptyOrder()
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 15),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount:
                              controller.listRouteCollector.length +
                              (isPlusOne ? 1 : 0),
                          (context, index) {
                            if (index == controller.listRouteCollector.length) {
                              return _buildBottomIndicator(
                                controller.ritController.loadState.value,
                                controller.retryFetchRouteCollector,
                              );
                            }

                            return _buildOrder(
                              index: index,
                              entity: controller.listRouteCollector[index],
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
    required RouteCollectorEntity entity,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SharedCardRIT(
        isSelected: false,
        totalPO: entity.jumlahTransaksi,
        noRIT: entity.noRoute,
        dateRIT: '',
        colorRIT: int.parse('0xC7C1CEE2'),
        routeRIT: [],
        isSelection: false.obs,
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            masterCtrlr.pageIndex.value = 4;

            if (masterCtrlr.pageController.hasClients) {
              masterCtrlr.pageController.jumpToPage(4);
            }
          });

          // masterCtrlr.pageIndex.value = 4;
          // masterCtrlr.pageController.jumpToPage(4);
          masterCtrlr.invController.getInvCollector(
            isRefresh: true,
            noRoute: entity.noRoute,
            noNotaRoute: entity.notaRoute,
          );

          debugPrint('Has clients: ${masterCtrlr.pageController.hasClients}');
          debugPrint('Page index: ${masterCtrlr.pageIndex.value}');

          if (masterCtrlr.pageController.hasClients) {
            masterCtrlr.pageController.jumpToPage(4);
          }

          debugPrint(
            'Current page: ${masterCtrlr.pageController.hasClients ? masterCtrlr.pageController.page : "Not attached"}',
          );
        },
        onTapSeePO: () {},
      ),
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
