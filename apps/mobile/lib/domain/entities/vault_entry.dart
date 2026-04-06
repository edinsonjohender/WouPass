class VaultEntry {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String uri;
  final String notes;
  final int? categoryId;
  final String icon;
  final bool favorite;
  final int passwordRenewalDays;
  final DateTime lastPasswordChange;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VaultEntry({
    this.id,
    required this.title,
    this.username = '',
    required this.password,
    this.uri = '',
    this.notes = '',
    this.categoryId,
    this.icon = 'globe',
    this.favorite = false,
    this.passwordRenewalDays = 0,
    required this.lastPasswordChange,
    required this.createdAt,
    required this.updatedAt,
  });

  VaultEntry copyWith({
    int? id,
    String? title,
    String? username,
    String? password,
    String? uri,
    String? notes,
    int? categoryId,
    String? icon,
    bool? favorite,
    int? passwordRenewalDays,
    DateTime? lastPasswordChange,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VaultEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      uri: uri ?? this.uri,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      favorite: favorite ?? this.favorite,
      passwordRenewalDays: passwordRenewalDays ?? this.passwordRenewalDays,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
