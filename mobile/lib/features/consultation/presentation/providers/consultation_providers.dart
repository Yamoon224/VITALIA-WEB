import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:vitalia_mobile/features/consultation/data/repositories/consultation_repository_impl.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/answer_consultation_question_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/finish_consultation_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/get_next_question_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/start_consultation_usecase.dart';

final consultationRemoteDataSourceProvider =
    Provider<ConsultationRemoteDataSource>(
      (ref) => ConsultationRemoteDataSource(ref.watch(dioProvider)),
    );

final consultationRepositoryProvider = Provider<ConsultationRepository>(
  (ref) => ConsultationRepositoryImpl(
    ref.watch(consultationRemoteDataSourceProvider),
  ),
);

final startConsultationUseCaseProvider = Provider<StartConsultationUseCase>(
  (ref) => StartConsultationUseCase(ref.watch(consultationRepositoryProvider)),
);

final getNextQuestionUseCaseProvider = Provider<GetNextQuestionUseCase>(
  (ref) => GetNextQuestionUseCase(ref.watch(consultationRepositoryProvider)),
);

final answerConsultationQuestionUseCaseProvider =
    Provider<AnswerConsultationQuestionUseCase>(
      (ref) => AnswerConsultationQuestionUseCase(
        ref.watch(consultationRepositoryProvider),
      ),
    );

final finishConsultationUseCaseProvider = Provider<FinishConsultationUseCase>(
  (ref) => FinishConsultationUseCase(ref.watch(consultationRepositoryProvider)),
);
