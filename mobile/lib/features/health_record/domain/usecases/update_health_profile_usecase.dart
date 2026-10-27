import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';

class UpdateHealthProfileUseCase {
  const UpdateHealthProfileUseCase(this._repository);

  final HealthRecordRepository _repository;

  Future<Result<HealthProfile>> call(HealthProfile profile) =>
      _repository.updateProfile(profile);
}
