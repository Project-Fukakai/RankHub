// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPinnedCollectionCollection on Isar {
  IsarCollection<PinnedCollection> get pinnedCollections => this.collection();
}

const PinnedCollectionSchema = CollectionSchema(
  name: r'PinnedCollection',
  id: 5980811552069402314,
  properties: {
    r'collectionId': PropertySchema(
      id: 0,
      name: r'collectionId',
      type: IsarType.long,
    ),
    r'collectionType': PropertySchema(
      id: 1,
      name: r'collectionType',
      type: IsarType.string,
    ),
    r'pinnedAt': PropertySchema(
      id: 2,
      name: r'pinnedAt',
      type: IsarType.dateTime,
    ),
    r'typeIdKey': PropertySchema(
      id: 3,
      name: r'typeIdKey',
      type: IsarType.string,
    ),
  },

  estimateSize: _pinnedCollectionEstimateSize,
  serialize: _pinnedCollectionSerialize,
  deserialize: _pinnedCollectionDeserialize,
  deserializeProp: _pinnedCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'typeIdKey_collectionId': IndexSchema(
      id: 1391738713384664641,
      name: r'typeIdKey_collectionId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'typeIdKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'collectionId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _pinnedCollectionGetId,
  getLinks: _pinnedCollectionGetLinks,
  attach: _pinnedCollectionAttach,
  version: '3.3.0',
);

int _pinnedCollectionEstimateSize(
  PinnedCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.collectionType.length * 3;
  bytesCount += 3 + object.typeIdKey.length * 3;
  return bytesCount;
}

void _pinnedCollectionSerialize(
  PinnedCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.collectionId);
  writer.writeString(offsets[1], object.collectionType);
  writer.writeDateTime(offsets[2], object.pinnedAt);
  writer.writeString(offsets[3], object.typeIdKey);
}

PinnedCollection _pinnedCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PinnedCollection(
    collectionId: reader.readLong(offsets[0]),
    collectionType: reader.readString(offsets[1]),
    id: id,
    pinnedAt: reader.readDateTimeOrNull(offsets[2]),
  );
  return object;
}

P _pinnedCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pinnedCollectionGetId(PinnedCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pinnedCollectionGetLinks(PinnedCollection object) {
  return [];
}

void _pinnedCollectionAttach(
  IsarCollection<dynamic> col,
  Id id,
  PinnedCollection object,
) {
  object.id = id;
}

extension PinnedCollectionByIndex on IsarCollection<PinnedCollection> {
  Future<PinnedCollection?> getByTypeIdKeyCollectionId(
    String typeIdKey,
    int collectionId,
  ) {
    return getByIndex(r'typeIdKey_collectionId', [typeIdKey, collectionId]);
  }

  PinnedCollection? getByTypeIdKeyCollectionIdSync(
    String typeIdKey,
    int collectionId,
  ) {
    return getByIndexSync(r'typeIdKey_collectionId', [typeIdKey, collectionId]);
  }

  Future<bool> deleteByTypeIdKeyCollectionId(
    String typeIdKey,
    int collectionId,
  ) {
    return deleteByIndex(r'typeIdKey_collectionId', [typeIdKey, collectionId]);
  }

  bool deleteByTypeIdKeyCollectionIdSync(String typeIdKey, int collectionId) {
    return deleteByIndexSync(r'typeIdKey_collectionId', [
      typeIdKey,
      collectionId,
    ]);
  }

  Future<List<PinnedCollection?>> getAllByTypeIdKeyCollectionId(
    List<String> typeIdKeyValues,
    List<int> collectionIdValues,
  ) {
    final len = typeIdKeyValues.length;
    assert(
      collectionIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeIdKeyValues[i], collectionIdValues[i]]);
    }

    return getAllByIndex(r'typeIdKey_collectionId', values);
  }

  List<PinnedCollection?> getAllByTypeIdKeyCollectionIdSync(
    List<String> typeIdKeyValues,
    List<int> collectionIdValues,
  ) {
    final len = typeIdKeyValues.length;
    assert(
      collectionIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeIdKeyValues[i], collectionIdValues[i]]);
    }

    return getAllByIndexSync(r'typeIdKey_collectionId', values);
  }

  Future<int> deleteAllByTypeIdKeyCollectionId(
    List<String> typeIdKeyValues,
    List<int> collectionIdValues,
  ) {
    final len = typeIdKeyValues.length;
    assert(
      collectionIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeIdKeyValues[i], collectionIdValues[i]]);
    }

    return deleteAllByIndex(r'typeIdKey_collectionId', values);
  }

  int deleteAllByTypeIdKeyCollectionIdSync(
    List<String> typeIdKeyValues,
    List<int> collectionIdValues,
  ) {
    final len = typeIdKeyValues.length;
    assert(
      collectionIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeIdKeyValues[i], collectionIdValues[i]]);
    }

    return deleteAllByIndexSync(r'typeIdKey_collectionId', values);
  }

  Future<Id> putByTypeIdKeyCollectionId(PinnedCollection object) {
    return putByIndex(r'typeIdKey_collectionId', object);
  }

  Id putByTypeIdKeyCollectionIdSync(
    PinnedCollection object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(
      r'typeIdKey_collectionId',
      object,
      saveLinks: saveLinks,
    );
  }

  Future<List<Id>> putAllByTypeIdKeyCollectionId(
    List<PinnedCollection> objects,
  ) {
    return putAllByIndex(r'typeIdKey_collectionId', objects);
  }

  List<Id> putAllByTypeIdKeyCollectionIdSync(
    List<PinnedCollection> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'typeIdKey_collectionId',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension PinnedCollectionQueryWhereSort
    on QueryBuilder<PinnedCollection, PinnedCollection, QWhere> {
  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PinnedCollectionQueryWhere
    on QueryBuilder<PinnedCollection, PinnedCollection, QWhereClause> {
  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyEqualToAnyCollectionId(String typeIdKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'typeIdKey_collectionId',
          value: [typeIdKey],
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyNotEqualToAnyCollectionId(String typeIdKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [],
                upper: [typeIdKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [],
                upper: [typeIdKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyCollectionIdEqualTo(String typeIdKey, int collectionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'typeIdKey_collectionId',
          value: [typeIdKey, collectionId],
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyEqualToCollectionIdNotEqualTo(String typeIdKey, int collectionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey],
                upper: [typeIdKey, collectionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey, collectionId],
                includeLower: false,
                upper: [typeIdKey],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey, collectionId],
                includeLower: false,
                upper: [typeIdKey],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'typeIdKey_collectionId',
                lower: [typeIdKey],
                upper: [typeIdKey, collectionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyEqualToCollectionIdGreaterThan(
    String typeIdKey,
    int collectionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'typeIdKey_collectionId',
          lower: [typeIdKey, collectionId],
          includeLower: include,
          upper: [typeIdKey],
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyEqualToCollectionIdLessThan(
    String typeIdKey,
    int collectionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'typeIdKey_collectionId',
          lower: [typeIdKey],
          upper: [typeIdKey, collectionId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterWhereClause>
  typeIdKeyEqualToCollectionIdBetween(
    String typeIdKey,
    int lowerCollectionId,
    int upperCollectionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'typeIdKey_collectionId',
          lower: [typeIdKey, lowerCollectionId],
          includeLower: includeLower,
          upper: [typeIdKey, upperCollectionId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PinnedCollectionQueryFilter
    on QueryBuilder<PinnedCollection, PinnedCollection, QFilterCondition> {
  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'collectionId', value: value),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'collectionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'collectionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'collectionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'collectionType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'collectionType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'collectionType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'collectionType', value: ''),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  collectionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'collectionType', value: ''),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
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

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pinnedAt'),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pinnedAt'),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinnedAt', value: value),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pinnedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pinnedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  pinnedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pinnedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'typeIdKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'typeIdKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'typeIdKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'typeIdKey', value: ''),
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterFilterCondition>
  typeIdKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'typeIdKey', value: ''),
      );
    });
  }
}

extension PinnedCollectionQueryObject
    on QueryBuilder<PinnedCollection, PinnedCollection, QFilterCondition> {}

extension PinnedCollectionQueryLinks
    on QueryBuilder<PinnedCollection, PinnedCollection, QFilterCondition> {}

extension PinnedCollectionQuerySortBy
    on QueryBuilder<PinnedCollection, PinnedCollection, QSortBy> {
  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByCollectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionId', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByCollectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionId', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByCollectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionType', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByCollectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionType', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByPinnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedAt', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByPinnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedAt', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByTypeIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIdKey', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  sortByTypeIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIdKey', Sort.desc);
    });
  }
}

extension PinnedCollectionQuerySortThenBy
    on QueryBuilder<PinnedCollection, PinnedCollection, QSortThenBy> {
  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByCollectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionId', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByCollectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionId', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByCollectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionType', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByCollectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionType', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByPinnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedAt', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByPinnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedAt', Sort.desc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByTypeIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIdKey', Sort.asc);
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QAfterSortBy>
  thenByTypeIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIdKey', Sort.desc);
    });
  }
}

extension PinnedCollectionQueryWhereDistinct
    on QueryBuilder<PinnedCollection, PinnedCollection, QDistinct> {
  QueryBuilder<PinnedCollection, PinnedCollection, QDistinct>
  distinctByCollectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectionId');
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QDistinct>
  distinctByCollectionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'collectionType',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QDistinct>
  distinctByPinnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedAt');
    });
  }

  QueryBuilder<PinnedCollection, PinnedCollection, QDistinct>
  distinctByTypeIdKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeIdKey', caseSensitive: caseSensitive);
    });
  }
}

extension PinnedCollectionQueryProperty
    on QueryBuilder<PinnedCollection, PinnedCollection, QQueryProperty> {
  QueryBuilder<PinnedCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PinnedCollection, int, QQueryOperations> collectionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectionId');
    });
  }

  QueryBuilder<PinnedCollection, String, QQueryOperations>
  collectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectionType');
    });
  }

  QueryBuilder<PinnedCollection, DateTime?, QQueryOperations>
  pinnedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedAt');
    });
  }

  QueryBuilder<PinnedCollection, String, QQueryOperations> typeIdKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeIdKey');
    });
  }
}
