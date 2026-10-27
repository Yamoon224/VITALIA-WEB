/// Conversations thématisées (section 5.2 du cahier des charges).
enum ConversationTopic {
  consultation,
  examResults,
  wellness,
  followUp;

  String get apiValue => switch (this) {
    ConversationTopic.consultation => 'consultation',
    ConversationTopic.examResults => 'exam_results',
    ConversationTopic.wellness => 'wellness',
    ConversationTopic.followUp => 'follow_up',
  };
}
