class Account {
  final String id;
  final String issuer;
  final String accountName;
  final String icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final int sortOrder;
  final String algorithm;
  final int digits;
  final int period;

  const Account({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.sortOrder = 0,
    this.algorithm = 'SHA1',
    this.digits = 6,
    this.period = 30,
  });

  Account copyWith({
    String? id,
    String? issuer,
    String? accountName,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    int? sortOrder,
    String? algorithm,
    int? digits,
    int? period,
  }) {
    return Account(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      sortOrder: sortOrder ?? this.sortOrder,
      algorithm: algorithm ?? this.algorithm,
      digits: digits ?? this.digits,
      period: period ?? this.period,
    );
  }
}
