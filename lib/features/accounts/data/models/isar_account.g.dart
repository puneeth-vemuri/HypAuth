// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_account.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-start
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarAccountCollection on Isar {
  IsarCollection<IsarAccount> get isarAccounts => this.collection();
}

const IsarAccountSchema = CollectionSchema(
  name: r'IsarAccount',
  id: -2791839210492810943,
  properties: {
    r'accountName': PropertySchema(
      id: 0,
      name: r'accountName',
      type: IsarType.string,
    ),
    r'algorithm': PropertySchema(
      id: 1,
      name: r'algorithm',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'digits': PropertySchema(
      id: 3,
      name: r'digits',
      type: IsarType.long,
    ),
    r'icon': PropertySchema(
      id: 4,
      name: r'icon',
      type: IsarType.string,
    ),
    r'isFavorite': PropertySchema(
      id: 5,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'issuer': PropertySchema(
      id: 6,
      name: r'issuer',
      type: IsarType.string,
    ),
    r'period': PropertySchema(
      id: 7,
      name: r'period',
      type: IsarType.long,
    ),
    r'sortOrder': PropertySchema(
      id: 8,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 10,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _isarAccountEstimateSize,
  serialize: _isarAccountSerialize,
  deserialize: _isarAccountDeserialize,
  deserializeProp: _isarAccountDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: -8912831203912093812,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarAccountGetId,
  getLinks: _isarAccountGetLinks,
  attach: _isarAccountAttach,
  version: '3.1.0+1',
);

int _isarAccountEstimateSize(
  IsarAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = 0;
  bytesCount += 3 + object.accountName.length * 3;
  bytesCount += 3 + object.algorithm.length * 3;
  bytesCount += 3 + object.icon.length * 3;
  bytesCount += 3 + object.issuer.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _isarAccountSerialize(
  IsarAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountName);
  writer.writeString(offsets[1], object.algorithm);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.digits);
  writer.writeString(offsets[4], object.icon);
  writer.writeBool(offsets[5], object.isFavorite);
  writer.writeString(offsets[6], object.issuer);
  writer.writeLong(offsets[7], object.period);
  writer.writeLong(offsets[8], object.sortOrder);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.uuid);
}

IsarAccount _isarAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAccount();
  object.id = id;
  object.accountName = reader.readString(offsets[0]);
  object.algorithm = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.digits = reader.readLong(offsets[3]);
  object.icon = reader.readString(offsets[4]);
  object.isFavorite = reader.readBool(offsets[5]);
  object.issuer = reader.readString(offsets[6]);
  object.period = reader.readLong(offsets[7]);
  object.sortOrder = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.uuid = reader.readString(offsets[10]);
  return object;
}

P _isarAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown propertyWithId $propertyId');
  }
}

Id _isarAccountGetId(IsarAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarAccountGetLinks(IsarAccount object) {
  return [];
}

void _isarAccountAttach(IsarCollection<dynamic> col, Id id, IsarAccount object) {
  object.id = id;
}

extension IsarAccountQueryWhereSort on QueryBuilder<IsarAccount, IsarAccount, QWhere> {
  QueryBuilder<IsarAccount, IsarAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarAccountQueryWhere on QueryBuilder<IsarAccount, IsarAccount, QWhereClause> {
  QueryBuilder<IsarAccount, IsarAccount, QAfterWhereClause> uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }
}

extension IsarAccountQueryFilter on QueryBuilder<IsarAccount, IsarAccount, QFilterCondition> {
  QueryBuilder<IsarAccount, IsarAccount, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension IsarAccountQueryProperty on QueryBuilder<IsarAccount, IsarAccount, QQueryProperty> {
  QueryBuilder<IsarAccount, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
