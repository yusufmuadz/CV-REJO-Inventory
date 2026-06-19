import 'package:get/get.dart';

import '../../domain/usecases/get_home_usecase.dart';

class HomeRITController extends GetxController {
  final GetHomeUseCase homeUseCase;

  HomeRITController({required this.homeUseCase});
}
