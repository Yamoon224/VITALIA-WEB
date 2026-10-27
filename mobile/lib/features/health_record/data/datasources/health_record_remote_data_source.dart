import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/health_record/data/models/agent_memory_entry_model.dart';
import 'package:vitalia_mobile/features/health_record/data/models/health_profile_model.dart';

/// Seule classe du projet qui connaît la forme JSON exacte des endpoints
/// `health-profile` et `agent-memory` (section 11.1).
class HealthRecordRemoteDataSource {
  const HealthRecordRemoteDataSource(this._dio);

  final Dio _dio;

  Future<HealthProfileModel> getProfile() async {
    final response = await _dio.get('/health-profile');

    return HealthProfileModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<HealthProfileModel> updateProfile(HealthProfileModel profile) async {
    final response = await _dio.put('/health-profile', data: profile.toJson());

    return HealthProfileModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<List<AgentMemoryEntryModel>> pendingMemoryEntries() async {
    final response = await _dio.get('/agent-memory/pending');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map(
          (row) => AgentMemoryEntryModel.fromJson(row as Map<String, dynamic>),
        )
        .toList();
  }

  Future<AgentMemoryEntryModel> acceptMemoryEntry(String entryId) async {
    final response = await _dio.post('/agent-memory/$entryId/accept');

    return AgentMemoryEntryModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<AgentMemoryEntryModel> rejectMemoryEntry(String entryId) async {
    final response = await _dio.post('/agent-memory/$entryId/reject');

    return AgentMemoryEntryModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }
}
