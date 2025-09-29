class PaginationInfo {
  final int page;
  final int pageSize;
  final int total;
  const PaginationInfo({required this.page, required this.pageSize, required this.total});

  bool get hasNext => page * pageSize < total;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );
  }
}
