import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';

class GetHealthProfileUseCase {
  const GetHealthProfileUseCase(this._repository);

  final HealthRecordRepository _repository;

  Future<Result<HealthProfile>> call() => _repository.getProfile();
}
