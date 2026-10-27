enum LaboratoryType {
  laboratory,
  imagingCenter;

  static LaboratoryType fromApi(String value) => value == 'imaging_center'
      ? LaboratoryType.imagingCenter
      : LaboratoryType.laboratory;

  String get label => this == LaboratoryType.imagingCenter
      ? "Centre d'imagerie"
      : 'Laboratoire';
}
