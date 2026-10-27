enum ConsultationStatus {
  inProgress,
  completed;

  static ConsultationStatus fromApi(String value) => value == 'completed'
      ? ConsultationStatus.completed
      : ConsultationStatus.inProgress;
}
