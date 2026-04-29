class ErrorPostItemProductEntity {
  final bool? isMaxFailure;
  final String? details;

  ErrorPostItemProductEntity({this.isMaxFailure, this.details});

  factory ErrorPostItemProductEntity.fromJson(Map<String, dynamic> json) {
    return ErrorPostItemProductEntity(
      isMaxFailure: json['max_mistakes'] ?? false,
      details: json['details'] ?? '',
    );
  }

  ErrorPostItemProductEntity? toEntity() {
    return this;
  }
}
