/// Statut d'une proposition de mémoire de l'agent (section 5.8) : pas
/// d'écriture silencieuse de données médicales — `proposed` jusqu'à
/// validation explicite de l'utilisateur.
enum MemoryEntryStatus {
  proposed,
  accepted,
  rejected;

  static MemoryEntryStatus fromApi(String value) => switch (value) {
    'accepted' => MemoryEntryStatus.accepted,
    'rejected' => MemoryEntryStatus.rejected,
    _ => MemoryEntryStatus.proposed,
  };
}
