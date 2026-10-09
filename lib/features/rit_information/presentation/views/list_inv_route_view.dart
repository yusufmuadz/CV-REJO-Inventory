import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/presentation/widgets/home_collector_driver/list_invoice_widget.dart';
import '../controllers/rit_controller.dart';

class ListInvRouteView extends StatelessWidget {
  final RitController masterCtrlr;
  const ListInvRouteView({super.key, required this.masterCtrlr});

  @override
  Widget build(BuildContext context) {
    final controller = masterCtrlr.invController;

    return SharedListInvView(
      isGetLoading: controller.isGetLoading,
      getLoadState: controller.getLoadState,
      isSelectedRoute: controller.isSelectedRoute,
      listInv: controller.listInv,
      buttonINV: controller.buttonINV,
      searchInvController: controller.searchInvController,
      routeStackService: masterCtrlr.routeStackService,
      dialogService: masterCtrlr.dialogService,
      onSubmitted: (String p1) {},
      onSuffixTap: () {},
      onCheckboxChanged: (int value) => controller.onSelectedInv(value),
      retryFetch: () => controller.retryFetch(),
    );
  }
}
