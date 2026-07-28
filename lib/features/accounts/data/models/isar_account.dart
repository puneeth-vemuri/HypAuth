import 'package:isar/isar.dart';
import '../../domain/models/account.dart';

part 'isar_account.g.dart';

@collection
class IsarAccount {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String issuer;
  late String accountName;
  late String icon;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isFavorite;
  late int sortOrder;
  late String algorithm;
  late int digits;
  late int period;

  Account toDomain() {
    return Account(
      id: uuid,
      issuer: issuer,
      accountName: accountName,
      icon: icon,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFavorite: isFavorite,
      sortOrder: sortOrder,
      algorithm: algorithm,
      digits: digits,
      period: period,
    );
  }

  static IsarAccount fromDomain(Account domain) {
    final entity = IsarAccount()
      ..uuid = domain.id
      ..issuer = domain.issuer
      ..accountName = domain.accountName
      ..icon = domain.icon
      ..createdAt = domain.createdAt
      ..updatedAt = domain.updatedAt
      ..isFavorite = domain.isFavorite
      ..sortOrder = domain.sortOrder
      ..algorithm = domain.algorithm
      ..digits = domain.digits
      ..period = domain.period;
    return entity;
  }
}
