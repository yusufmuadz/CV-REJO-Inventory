class PostItemProductEntity {
  final bool? isMultiple;
  final String? itemName;

  PostItemProductEntity({
    this.isMultiple,
    this.itemName,
  });

  factory PostItemProductEntity.fromJson(Map<String, dynamic> json) {
    return PostItemProductEntity(
      isMultiple: json['is_multiple'] ?? false,
      itemName: json['item_name'] ?? '',
    );
  }
}