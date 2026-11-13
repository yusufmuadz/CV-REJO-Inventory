class ParamGetRIT {
  final String? page;
  final String? limit;
  final String? search;
  final String? date;
  final bool isPastRit;
  final bool? isSisipan;

  ParamGetRIT({
    this.search,
    this.date,
    required this.isPastRit,
    this.isSisipan,
    this.page,
    this.limit = '10',
  });
}
