// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPhigrosAvatarCollection on Isar {
  IsarCollection<PhigrosAvatar> get phigrosAvatars => this.collection();
}

const PhigrosAvatarSchema = CollectionSchema(
  name: r'PhigrosAvatar',
  id: -6842372810731563928,
  properties: {
    r'addressableKey': PropertySchema(
      id: 0,
      name: r'addressableKey',
      type: IsarType.string,
    ),
    r'avatarName': PropertySchema(
      id: 1,
      name: r'avatarName',
      type: IsarType.string,
    ),
    r'avatarUrl': PropertySchema(
      id: 2,
      name: r'avatarUrl',
      type: IsarType.string,
    ),
  },

  estimateSize: _phigrosAvatarEstimateSize,
  serialize: _phigrosAvatarSerialize,
  deserialize: _phigrosAvatarDeserialize,
  deserializeProp: _phigrosAvatarDeserializeProp,
  idName: r'id',
  indexes: {
    r'avatarName': IndexSchema(
      id: 3710024329376750176,
      name: r'avatarName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'avatarName',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _phigrosAvatarGetId,
  getLinks: _phigrosAvatarGetLinks,
  attach: _phigrosAvatarAttach,
  version: '3.3.0',
);

int _phigrosAvatarEstimateSize(
  PhigrosAvatar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.addressableKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.avatarName.length * 3;
  bytesCount += 3 + object.avatarUrl.length * 3;
  return bytesCount;
}

void _phigrosAvatarSerialize(
  PhigrosAvatar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.addressableKey);
  writer.writeString(offsets[1], object.avatarName);
  writer.writeString(offsets[2], object.avatarUrl);
}

PhigrosAvatar _phigrosAvatarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PhigrosAvatar();
  object.addressableKey = reader.readStringOrNull(offsets[0]);
  object.avatarName = reader.readString(offsets[1]);
  object.id = id;
  return object;
}

P _phigrosAvatarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _phigrosAvatarGetId(PhigrosAvatar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _phigrosAvatarGetLinks(PhigrosAvatar object) {
  return [];
}

void _phigrosAvatarAttach(
  IsarCollection<dynamic> col,
  Id id,
  PhigrosAvatar object,
) {
  object.id = id;
}

extension PhigrosAvatarByIndex on IsarCollection<PhigrosAvatar> {
  Future<PhigrosAvatar?> getByAvatarName(String avatarName) {
    return getByIndex(r'avatarName', [avatarName]);
  }

  PhigrosAvatar? getByAvatarNameSync(String avatarName) {
    return getByIndexSync(r'avatarName', [avatarName]);
  }

  Future<bool> deleteByAvatarName(String avatarName) {
    return deleteByIndex(r'avatarName', [avatarName]);
  }

  bool deleteByAvatarNameSync(String avatarName) {
    return deleteByIndexSync(r'avatarName', [avatarName]);
  }

  Future<List<PhigrosAvatar?>> getAllByAvatarName(
    List<String> avatarNameValues,
  ) {
    final values = avatarNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'avatarName', values);
  }

  List<PhigrosAvatar?> getAllByAvatarNameSync(List<String> avatarNameValues) {
    final values = avatarNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'avatarName', values);
  }

  Future<int> deleteAllByAvatarName(List<String> avatarNameValues) {
    final values = avatarNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'avatarName', values);
  }

  int deleteAllByAvatarNameSync(List<String> avatarNameValues) {
    final values = avatarNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'avatarName', values);
  }

  Future<Id> putByAvatarName(PhigrosAvatar object) {
    return putByIndex(r'avatarName', object);
  }

  Id putByAvatarNameSync(PhigrosAvatar object, {bool saveLinks = true}) {
    return putByIndexSync(r'avatarName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAvatarName(List<PhigrosAvatar> objects) {
    return putAllByIndex(r'avatarName', objects);
  }

  List<Id> putAllByAvatarNameSync(
    List<PhigrosAvatar> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'avatarName', objects, saveLinks: saveLinks);
  }
}

extension PhigrosAvatarQueryWhereSort
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QWhere> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PhigrosAvatarQueryWhere
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QWhereClause> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause> idBetween(
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause>
  avatarNameEqualTo(String avatarName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'avatarName', value: [avatarName]),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterWhereClause>
  avatarNameNotEqualTo(String avatarName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'avatarName',
                lower: [],
                upper: [avatarName],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'avatarName',
                lower: [avatarName],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'avatarName',
                lower: [avatarName],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'avatarName',
                lower: [],
                upper: [avatarName],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PhigrosAvatarQueryFilter
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QFilterCondition> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'addressableKey'),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'addressableKey'),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'addressableKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'addressableKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'addressableKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'addressableKey', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  addressableKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'addressableKey', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'avatarName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'avatarName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'avatarName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'avatarName', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'avatarName', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlGreaterThan(
    String value, {
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlLessThan(
    String value, {
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlBetween(
    String lower,
    String upper, {
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'avatarUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
  avatarUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'avatarUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition>
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterFilterCondition> idBetween(
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
}

extension PhigrosAvatarQueryObject
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QFilterCondition> {}

extension PhigrosAvatarQueryLinks
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QFilterCondition> {}

extension PhigrosAvatarQuerySortBy
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QSortBy> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  sortByAddressableKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressableKey', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  sortByAddressableKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressableKey', Sort.desc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> sortByAvatarName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarName', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  sortByAvatarNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarName', Sort.desc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> sortByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  sortByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }
}

extension PhigrosAvatarQuerySortThenBy
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QSortThenBy> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  thenByAddressableKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressableKey', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  thenByAddressableKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressableKey', Sort.desc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> thenByAvatarName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarName', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  thenByAvatarNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarName', Sort.desc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> thenByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy>
  thenByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PhigrosAvatarQueryWhereDistinct
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QDistinct> {
  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QDistinct>
  distinctByAddressableKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'addressableKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QDistinct> distinctByAvatarName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosAvatar, PhigrosAvatar, QDistinct> distinctByAvatarUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarUrl', caseSensitive: caseSensitive);
    });
  }
}

extension PhigrosAvatarQueryProperty
    on QueryBuilder<PhigrosAvatar, PhigrosAvatar, QQueryProperty> {
  QueryBuilder<PhigrosAvatar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PhigrosAvatar, String?, QQueryOperations>
  addressableKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addressableKey');
    });
  }

  QueryBuilder<PhigrosAvatar, String, QQueryOperations> avatarNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarName');
    });
  }

  QueryBuilder<PhigrosAvatar, String, QQueryOperations> avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarUrl');
    });
  }
}
