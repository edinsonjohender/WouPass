class Category {
  final int? id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isDefault;
  final int sortOrder;
  final DateTime createdAt;

  const Category({
    this.id,
    required this.name,
    this.icon = 'folder',
    this.colorHex = '#6C63FF',
    this.isDefault = false,
    this.sortOrder = 0,
    required this.createdAt,
  });

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? colorHex,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
