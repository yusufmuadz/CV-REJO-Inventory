import 'package:get/get.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../utils/loading_custom.dart';
import '../../../../detail_order/presentation/widgets/dialog/input_assisten_widget.dart';
import '../../controllers/list_order_controller.dart';

class InputAssistantDialog {
  static Future<bool> inputAsisten(ListOrderController controller) async {
    final bool result =
        await controller.dialogService.inputDialog(
          title: 'Masukkan ${AppRole.isChecker2 ? 'Muat Barang' : 'Asisten'}',
          onPressed1: () => Get.back(result: false),
          onPressed2: () async {
            if (controller.isLoadingAssistant.value) return;

            final resultAdd = await controller.postDataListController
                .addAssistant();

            if (!resultAdd) return;
            Get.back(result: resultAdd);
            controller.dialogService.showSuccessSnackbar(
              'Berhasil Menambahkan Asisten',
            );
          },
          content: Obx(() {
            if (controller.isLoadingAssistant.value) {
              return const LoadingView();
            }

            return InputAssistenWidget(controller: controller);
          }),
        ) ??
        false;

    return result;
  }
}
