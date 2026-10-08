import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/text_styles.dart';
import '../../features/list_order/domain/entities/list_order_entity.dart';
import '../../utils/loading_custom.dart';

class SharedDetailPoRit extends StatelessWidget {
  final bool? isShowPlus;
  final RxBool? isLoading;
  final Rx<LoadState>? loadStateDetailPO;
  final RxList<OrderEntity> orders;
  final ScrollController? scrollDetailPOController;
  final VoidCallback retryFetch;

  const SharedDetailPoRit({
    super.key,
    this.isShowPlus,
    this.isLoading,
    this.scrollDetailPOController,
    this.loadStateDetailPO,
    required this.orders,
    required this.retryFetch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xFFE2E8F8)),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
            color: const Color(0xFFF0F3FF),
          ),
          child: _buildTitleIconList(),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
                right: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
                left: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            child: Obx(() {
              if (loadStateDetailPO?.value == LoadState.initial ||
                  isLoading?.value == true) {
                return const LoadingView();
              }

              if (orders.isEmpty) {
                return const Center(child: Text('Tidak ada pesanan'));
              }

              return ListView.separated(
                itemCount: orders.length + (isShowPlus == true ? 1 : 0),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  height: 16,
                  color: Color(0xFFE2E8F8),
                ),
                controller: scrollDetailPOController,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  if (index == orders.length) {
                    return _buildBottomIndicator(
                      loadStateDetailPO?.value ?? LoadState.initial,
                      retryFetch,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${index + 1}.',
                            textAlign: TextAlign.center,
                            style: TextStyles.basicTextStyle(
                              fontSize: 14,
                              fontFamily:
                                  GoogleFonts.hankenGrotesk().fontFamily,
                              color: Color(0xFF524439),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderNo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.basicTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.hankenGrotesk().fontFamily,
                                  color: Color(0xFF151C27),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.customer,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.basicTextStyle(
                                  fontSize: 12,
                                  fontFamily:
                                      GoogleFonts.hankenGrotesk().fontFamily,
                                  color: Color(0xFF5D5E61),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleIconList() {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '#',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF5D5E61),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Nomor PO',
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF524439),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
      ],
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

      // case LoadState.error:
      //   return Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     child: Center(
      //       child: ElevatedButton.icon(
      //         onPressed: onRetry,
      //         icon: const Icon(Icons.refresh, size: 18),
      //         label: const Text('Coba Lagi'),
      //       ),
      //     ),
      //   );

      default:
        return const SizedBox.shrink();
    }
  }
}
