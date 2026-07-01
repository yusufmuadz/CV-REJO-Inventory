import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../../domain/entities/rit_constraint_entity.dart';
import '../../domain/usecases/get_home_usecase.dart';

class HomeRITController extends GetxController {
  final GetHomeUseCase homeUseCase;

  HomeRITController({required this.homeUseCase});

  final ritConstraints = <RitConstraintEntity>[].obs;
  final listTakeItTransaction = <RitConstraintEntity>[].obs;

  void addConstraint({
    required String title,
    required String nominal,
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList,
  }) async {
    ritConstraints.add(
      RitConstraintEntity(
        title: title,
        nominal: nominal.replaceAll(',', ''),
        date: date,
        status: status,
        desc: description,
        mediaFileList: mediaFileList ?? [],
      ),
    );
  }

  void addTakeIt({
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList,
  }) async {
    listTakeItTransaction.add(
      RitConstraintEntity(
        date: date,
        status: status,
        desc: description,
        mediaFileList: mediaFileList ?? [],
      ),
    );
  }
}
