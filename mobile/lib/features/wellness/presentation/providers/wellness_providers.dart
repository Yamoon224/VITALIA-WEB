import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/wellness/data/datasources/wellness_remote_data_source.dart';
import 'package:vitalia_mobile/features/wellness/data/repositories/wellness_repository_impl.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/list_mood_entries_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/list_wellness_goals_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/log_mood_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/set_wellness_goal_usecase.dart';

final wellnessRemoteDataSourceProvider = Provider<WellnessRemoteDataSource>(
  (ref) => WellnessRemoteDataSource(ref.watch(dioProvider)),
);

final wellnessRepositoryProvider = Provider<WellnessRepository>(
  (ref) => WellnessRepositoryImpl(ref.watch(wellnessRemoteDataSourceProvider)),
);

final listWellnessGoalsUseCaseProvider = Provider<ListWellnessGoalsUseCase>(
  (ref) => ListWellnessGoalsUseCase(ref.watch(wellnessRepositoryProvider)),
);

final setWellnessGoalUseCaseProvider = Provider<SetWellnessGoalUseCase>(
  (ref) => SetWellnessGoalUseCase(ref.watch(wellnessRepositoryProvider)),
);

final listMoodEntriesUseCaseProvider = Provider<ListMoodEntriesUseCase>(
  (ref) => ListMoodEntriesUseCase(ref.watch(wellnessRepositoryProvider)),
);

final logMoodUseCaseProvider = Provider<LogMoodUseCase>(
  (ref) => LogMoodUseCase(ref.watch(wellnessRepositoryProvider)),
);
