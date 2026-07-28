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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issuer': issuer,
      'accountName': accountName,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
      'sortOrder': sortOrder,
      'algorithm': algorithm,
      'digits': digits,
      'period': period,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      accountName: json['accountName'] as String,
      icon: json['icon'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
      algorithm: json['algorithm'] as String? ?? 'SHA1',
      digits: json['digits'] as int? ?? 6,
      period: json['period'] as int? ?? 30,
    );
  }
}
