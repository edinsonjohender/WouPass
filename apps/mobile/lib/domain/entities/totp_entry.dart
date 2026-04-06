class TotpEntry {
  final int? id;
  final String issuer;
  final String accountName;
  final String secret;
  final int digits;
  final int period;
  final String algorithm;
  final int? vaultEntryId;
  final DateTime createdAt;

  const TotpEntry({
    this.id,
    required this.issuer,
    required this.accountName,
    required this.secret,
    this.digits = 6,
    this.period = 30,
    this.algorithm = 'SHA1',
    this.vaultEntryId,
    required this.createdAt,
  });

  TotpEntry copyWith({
    int? id,
    String? issuer,
    String? accountName,
    String? secret,
    int? digits,
    int? period,
    String? algorithm,
    int? vaultEntryId,
    DateTime? createdAt,
  }) {
    return TotpEntry(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      secret: secret ?? this.secret,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      algorithm: algorithm ?? this.algorithm,
      vaultEntryId: vaultEntryId ?? this.vaultEntryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
