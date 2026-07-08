import 'package:get/get.dart';

import '../../domain/usecases/detail_order_usecase.dart';

class GetDetailOrderController extends GetxController {
  final DetailOrderUseCase detailOrderUseCase;

  GetDetailOrderController({required this.detailOrderUseCase});
}
