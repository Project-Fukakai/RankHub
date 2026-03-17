// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountEntityCollection on Isar {
  IsarCollection<AccountEntity> get accountEntitys => this.collection();
}

const AccountEntitySchema = CollectionSchema(
  name: r'AccountEntity',
  id: -996322080142432925,
  properties: {
    r'accountIdentifier': PropertySchema(
      id: 0,
      name: r'accountIdentifier',
      type: IsarType.string,
    ),
    r'avatarUrl': PropertySchema(
      id: 1,
      name: r'avatarUrl',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'credentialsJson': PropertySchema(
      id: 3,
      name: r'credentialsJson',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 4,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'metadataJson': PropertySchema(
      id: 5,
      name: r'metadataJson',
      type: IsarType.string,
    ),
    r'platformId': PropertySchema(
      id: 6,
      name: r'platformId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _accountEntityEstimateSize,
  serialize: _accountEntitySerialize,
  deserialize: _accountEntityDeserialize,
  deserializeProp: _accountEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'platformId': IndexSchema(
      id: 5645674383303701451,
      name: r'platformId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'platformId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'accountIdentifier_platformId': IndexSchema(
      id: -4598234536564630851,
      name: r'accountIdentifier_platformId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accountIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'platformId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _accountEntityGetId,
  getLinks: _accountEntityGetLinks,
  attach: _accountEntityAttach,
  version: '3.3.0',
);

int _accountEntityEstimateSize(
  AccountEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountIdentifier.length * 3;
  {
    final value = object.avatarUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.credentialsJson.length * 3;
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.metadataJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.platformId.length * 3;
  return bytesCount;
}

void _accountEntitySerialize(
  AccountEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountIdentifier);
  writer.writeString(offsets[1], object.avatarUrl);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.credentialsJson);
  writer.writeString(offsets[4], object.displayName);
  writer.writeString(offsets[5], object.metadataJson);
  writer.writeString(offsets[6], object.platformId);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

AccountEntity _accountEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountEntity();
  object.accountIdentifier = reader.readString(offsets[0]);
  object.avatarUrl = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.credentialsJson = reader.readString(offsets[3]);
  object.displayName = reader.readString(offsets[4]);
  object.id = id;
  object.metadataJson = reader.readStringOrNull(offsets[5]);
  object.platformId = reader.readString(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _accountEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountEntityGetId(AccountEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _accountEntityGetLinks(AccountEntity object) {
  return [];
}

void _accountEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AccountEntity object,
) {
  object.id = id;
}

extension AccountEntityByIndex on IsarCollection<AccountEntity> {
  Future<AccountEntity?> getByAccountIdentifierPlatformId(
    String accountIdentifier,
    String platformId,
  ) {
    return getByIndex(r'accountIdentifier_platformId', [
      accountIdentifier,
      platformId,
    ]);
  }

  AccountEntity? getByAccountIdentifierPlatformIdSync(
    String accountIdentifier,
    String platformId,
  ) {
    return getByIndexSync(r'accountIdentifier_platformId', [
      accountIdentifier,
      platformId,
    ]);
  }

  Future<bool> deleteByAccountIdentifierPlatformId(
    String accountIdentifier,
    String platformId,
  ) {
    return deleteByIndex(r'accountIdentifier_platformId', [
      accountIdentifier,
      platformId,
    ]);
  }

  bool deleteByAccountIdentifierPlatformIdSync(
    String accountIdentifier,
    String platformId,
  ) {
    return deleteByIndexSync(r'accountIdentifier_platformId', [
      accountIdentifier,
      platformId,
    ]);
  }

  Future<List<AccountEntity?>> getAllByAccountIdentifierPlatformId(
    List<String> accountIdentifierValues,
    List<String> platformIdValues,
  ) {
    final len = accountIdentifierValues.length;
    assert(
      platformIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountIdentifierValues[i], platformIdValues[i]]);
    }

    return getAllByIndex(r'accountIdentifier_platformId', values);
  }

  List<AccountEntity?> getAllByAccountIdentifierPlatformIdSync(
    List<String> accountIdentifierValues,
    List<String> platformIdValues,
  ) {
    final len = accountIdentifierValues.length;
    assert(
      platformIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountIdentifierValues[i], platformIdValues[i]]);
    }

    return getAllByIndexSync(r'accountIdentifier_platformId', values);
  }

  Future<int> deleteAllByAccountIdentifierPlatformId(
    List<String> accountIdentifierValues,
    List<String> platformIdValues,
  ) {
    final len = accountIdentifierValues.length;
    assert(
      platformIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountIdentifierValues[i], platformIdValues[i]]);
    }

    return deleteAllByIndex(r'accountIdentifier_platformId', values);
  }

  int deleteAllByAccountIdentifierPlatformIdSync(
    List<String> accountIdentifierValues,
    List<String> platformIdValues,
  ) {
    final len = accountIdentifierValues.length;
    assert(
      platformIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountIdentifierValues[i], platformIdValues[i]]);
    }

    return deleteAllByIndexSync(r'accountIdentifier_platformId', values);
  }

  Future<Id> putByAccountIdentifierPlatformId(AccountEntity object) {
    return putByIndex(r'accountIdentifier_platformId', object);
  }

  Id putByAccountIdentifierPlatformIdSync(
    AccountEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(
      r'accountIdentifier_platformId',
      object,
      saveLinks: saveLinks,
    );
  }

  Future<List<Id>> putAllByAccountIdentifierPlatformId(
    List<AccountEntity> objects,
  ) {
    return putAllByIndex(r'accountIdentifier_platformId', objects);
  }

  List<Id> putAllByAccountIdentifierPlatformIdSync(
    List<AccountEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'accountIdentifier_platformId',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension AccountEntityQueryWhereSort
    on QueryBuilder<AccountEntity, AccountEntity, QWhere> {
  QueryBuilder<AccountEntity, AccountEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccountEntityQueryWhere
    on QueryBuilder<AccountEntity, AccountEntity, QWhereClause> {
  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  platformIdEqualTo(String platformId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'platformId', value: [platformId]),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  platformIdNotEqualTo(String platformId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'platformId',
                lower: [],
                upper: [platformId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'platformId',
                lower: [platformId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'platformId',
                lower: [platformId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'platformId',
                lower: [],
                upper: [platformId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  accountIdentifierEqualToAnyPlatformId(String accountIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'accountIdentifier_platformId',
          value: [accountIdentifier],
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  accountIdentifierNotEqualToAnyPlatformId(String accountIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [],
                upper: [accountIdentifier],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [],
                upper: [accountIdentifier],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  accountIdentifierPlatformIdEqualTo(
    String accountIdentifier,
    String platformId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'accountIdentifier_platformId',
          value: [accountIdentifier, platformId],
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterWhereClause>
  accountIdentifierEqualToPlatformIdNotEqualTo(
    String accountIdentifier,
    String platformId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier],
                upper: [accountIdentifier, platformId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier, platformId],
                includeLower: false,
                upper: [accountIdentifier],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier, platformId],
                includeLower: false,
                upper: [accountIdentifier],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountIdentifier_platformId',
                lower: [accountIdentifier],
                upper: [accountIdentifier, platformId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AccountEntityQueryFilter
    on QueryBuilder<AccountEntity, AccountEntity, QFilterCondition> {
  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountIdentifier',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountIdentifier',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountIdentifier',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountIdentifier', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  accountIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountIdentifier', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'avatarUrl'),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'avatarUrl'),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'avatarUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'avatarUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'avatarUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'avatarUrl', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  avatarUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'avatarUrl', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'credentialsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'credentialsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'credentialsJson', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  credentialsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'credentialsJson', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'metadataJson'),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'metadataJson'),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'metadataJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'metadataJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'metadataJson', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  metadataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'metadataJson', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'platformId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'platformId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'platformId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'platformId', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  platformIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'platformId', value: ''),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AccountEntityQueryObject
    on QueryBuilder<AccountEntity, AccountEntity, QFilterCondition> {}

extension AccountEntityQueryLinks
    on QueryBuilder<AccountEntity, AccountEntity, QFilterCondition> {}

extension AccountEntityQuerySortBy
    on QueryBuilder<AccountEntity, AccountEntity, QSortBy> {
  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByAccountIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountIdentifier', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByAccountIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountIdentifier', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> sortByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByCredentialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByCredentialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> sortByPlatformId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformId', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByPlatformIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformId', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AccountEntityQuerySortThenBy
    on QueryBuilder<AccountEntity, AccountEntity, QSortThenBy> {
  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByAccountIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountIdentifier', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByAccountIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountIdentifier', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByCredentialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByCredentialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByPlatformId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformId', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByPlatformIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformId', Sort.desc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AccountEntityQueryWhereDistinct
    on QueryBuilder<AccountEntity, AccountEntity, QDistinct> {
  QueryBuilder<AccountEntity, AccountEntity, QDistinct>
  distinctByAccountIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accountIdentifier',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByAvatarUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct>
  distinctByCredentialsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'credentialsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByDisplayName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByMetadataJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByPlatformId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platformId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountEntity, AccountEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AccountEntityQueryProperty
    on QueryBuilder<AccountEntity, AccountEntity, QQueryProperty> {
  QueryBuilder<AccountEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AccountEntity, String, QQueryOperations>
  accountIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountIdentifier');
    });
  }

  QueryBuilder<AccountEntity, String?, QQueryOperations> avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarUrl');
    });
  }

  QueryBuilder<AccountEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AccountEntity, String, QQueryOperations>
  credentialsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credentialsJson');
    });
  }

  QueryBuilder<AccountEntity, String, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<AccountEntity, String?, QQueryOperations>
  metadataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataJson');
    });
  }

  QueryBuilder<AccountEntity, String, QQueryOperations> platformIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platformId');
    });
  }

  QueryBuilder<AccountEntity, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
