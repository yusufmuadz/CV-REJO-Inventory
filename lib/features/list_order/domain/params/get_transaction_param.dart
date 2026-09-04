
class ParamsGetTransaction {
  final String? limit;
  final String? page;
  final String? q;
  final String? sort;
  final String? filter;
  final String? district;
  final String? dateRit;
  final bool? pastRit;
  final bool? isTracking;
  final List<String>? courier;

  ParamsGetTransaction({
    this.limit,
    this.page,
    this.q,
    this.sort,
    this.filter,
    this.district,
    this.courier,
    this.dateRit,
    this.pastRit,
    this.isTracking,
  });
}
