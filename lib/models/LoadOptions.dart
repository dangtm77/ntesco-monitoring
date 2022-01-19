class LoadOptionsModel {
  final int take;
  final int skip;
  final String? sort;
  final String? filter;
  final String? requireTotalCount;

  LoadOptionsModel({required this.take, required this.skip, this.sort, this.filter, this.requireTotalCount});

  Map<String, dynamic> toMap() {
    return {
      'take': take.toString(),
      'skip': skip.toString(),
      'sort': sort.toString(), //"[{\"selector\":\"ngayTao\", \"desc\":\"true\"}]"
      'filter': filter.toString(),
      'requireTotalCount': requireTotalCount.toString()
    };
  }
}
