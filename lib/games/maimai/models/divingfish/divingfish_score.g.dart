// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divingfish_score.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDivingFishScoreCollection on Isar {
  IsarCollection<DivingFishScore> get divingFishScores => this.collection();
}

const DivingFishScoreSchema = CollectionSchema(
  name: r'DivingFishScore',
  id: 307496651636920364,
  properties: {
    r'achievements': PropertySchema(
      id: 0,
      name: r'achievements',
      type: IsarType.double,
    ),
    r'ds': PropertySchema(id: 1, name: r'ds', type: IsarType.double),
    r'dxScore': PropertySchema(id: 2, name: r'dxScore', type: IsarType.long),
    r'fc': PropertySchema(id: 3, name: r'fc', type: IsarType.string),
    r'fs': PropertySchema(id: 4, name: r'fs', type: IsarType.string),
    r'level': PropertySchema(id: 5, name: r'level', type: IsarType.string),
    r'levelIndex': PropertySchema(
      id: 6,
      name: r'levelIndex',
      type: IsarType.long,
    ),
    r'levelLabel': PropertySchema(
      id: 7,
      name: r'levelLabel',
      type: IsarType.string,
    ),
    r'ra': PropertySchema(id: 8, name: r'ra', type: IsarType.long),
    r'rate': PropertySchema(id: 9, name: r'rate', type: IsarType.string),
    r'scoreKey': PropertySchema(id: 10, name: r'scoreKey', type: IsarType.long),
    r'songId': PropertySchema(id: 11, name: r'songId', type: IsarType.long),
    r'title': PropertySchema(id: 12, name: r'title', type: IsarType.string),
    r'type': PropertySchema(id: 13, name: r'type', type: IsarType.string),
  },

  estimateSize: _divingFishScoreEstimateSize,
  serialize: _divingFishScoreSerialize,
  deserialize: _divingFishScoreDeserialize,
  deserializeProp: _divingFishScoreDeserializeProp,
  idName: r'id',
  indexes: {
    r'scoreKey_levelIndex_type': IndexSchema(
      id: 6711425885913746226,
      name: r'scoreKey_levelIndex_type',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scoreKey',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'levelIndex',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _divingFishScoreGetId,
  getLinks: _divingFishScoreGetLinks,
  attach: _divingFishScoreAttach,
  version: '3.3.0',
);

int _divingFishScoreEstimateSize(
  DivingFishScore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fc.length * 3;
  bytesCount += 3 + object.fs.length * 3;
  bytesCount += 3 + object.level.length * 3;
  bytesCount += 3 + object.levelLabel.length * 3;
  bytesCount += 3 + object.rate.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _divingFishScoreSerialize(
  DivingFishScore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.achievements);
  writer.writeDouble(offsets[1], object.ds);
  writer.writeLong(offsets[2], object.dxScore);
  writer.writeString(offsets[3], object.fc);
  writer.writeString(offsets[4], object.fs);
  writer.writeString(offsets[5], object.level);
  writer.writeLong(offsets[6], object.levelIndex);
  writer.writeString(offsets[7], object.levelLabel);
  writer.writeLong(offsets[8], object.ra);
  writer.writeString(offsets[9], object.rate);
  writer.writeLong(offsets[10], object.scoreKey);
  writer.writeLong(offsets[11], object.songId);
  writer.writeString(offsets[12], object.title);
  writer.writeString(offsets[13], object.type);
}

DivingFishScore _divingFishScoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DivingFishScore(
    achievements: reader.readDoubleOrNull(offsets[0]) ?? 0.0,
    ds: reader.readDoubleOrNull(offsets[1]) ?? 0.0,
    dxScore: reader.readLongOrNull(offsets[2]) ?? 0,
    fc: reader.readStringOrNull(offsets[3]) ?? '',
    fs: reader.readStringOrNull(offsets[4]) ?? '',
    id: id,
    level: reader.readStringOrNull(offsets[5]) ?? '',
    levelIndex: reader.readLongOrNull(offsets[6]) ?? 0,
    levelLabel: reader.readStringOrNull(offsets[7]) ?? '',
    ra: reader.readLongOrNull(offsets[8]) ?? 0,
    rate: reader.readStringOrNull(offsets[9]) ?? '',
    songId: reader.readLongOrNull(offsets[11]) ?? 0,
    title: reader.readStringOrNull(offsets[12]) ?? '',
    type: reader.readStringOrNull(offsets[13]) ?? '',
  );
  return object;
}

P _divingFishScoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _divingFishScoreGetId(DivingFishScore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _divingFishScoreGetLinks(DivingFishScore object) {
  return [];
}

void _divingFishScoreAttach(
  IsarCollection<dynamic> col,
  Id id,
  DivingFishScore object,
) {
  object.id = id;
}

extension DivingFishScoreByIndex on IsarCollection<DivingFishScore> {
  Future<DivingFishScore?> getByScoreKeyLevelIndexType(
    int scoreKey,
    int levelIndex,
    String type,
  ) {
    return getByIndex(r'scoreKey_levelIndex_type', [
      scoreKey,
      levelIndex,
      type,
    ]);
  }

  DivingFishScore? getByScoreKeyLevelIndexTypeSync(
    int scoreKey,
    int levelIndex,
    String type,
  ) {
    return getByIndexSync(r'scoreKey_levelIndex_type', [
      scoreKey,
      levelIndex,
      type,
    ]);
  }

  Future<bool> deleteByScoreKeyLevelIndexType(
    int scoreKey,
    int levelIndex,
    String type,
  ) {
    return deleteByIndex(r'scoreKey_levelIndex_type', [
      scoreKey,
      levelIndex,
      type,
    ]);
  }

  bool deleteByScoreKeyLevelIndexTypeSync(
    int scoreKey,
    int levelIndex,
    String type,
  ) {
    return deleteByIndexSync(r'scoreKey_levelIndex_type', [
      scoreKey,
      levelIndex,
      type,
    ]);
  }

  Future<List<DivingFishScore?>> getAllByScoreKeyLevelIndexType(
    List<int> scoreKeyValues,
    List<int> levelIndexValues,
    List<String> typeValues,
  ) {
    final len = scoreKeyValues.length;
    assert(
      levelIndexValues.length == len && typeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([scoreKeyValues[i], levelIndexValues[i], typeValues[i]]);
    }

    return getAllByIndex(r'scoreKey_levelIndex_type', values);
  }

  List<DivingFishScore?> getAllByScoreKeyLevelIndexTypeSync(
    List<int> scoreKeyValues,
    List<int> levelIndexValues,
    List<String> typeValues,
  ) {
    final len = scoreKeyValues.length;
    assert(
      levelIndexValues.length == len && typeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([scoreKeyValues[i], levelIndexValues[i], typeValues[i]]);
    }

    return getAllByIndexSync(r'scoreKey_levelIndex_type', values);
  }

  Future<int> deleteAllByScoreKeyLevelIndexType(
    List<int> scoreKeyValues,
    List<int> levelIndexValues,
    List<String> typeValues,
  ) {
    final len = scoreKeyValues.length;
    assert(
      levelIndexValues.length == len && typeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([scoreKeyValues[i], levelIndexValues[i], typeValues[i]]);
    }

    return deleteAllByIndex(r'scoreKey_levelIndex_type', values);
  }

  int deleteAllByScoreKeyLevelIndexTypeSync(
    List<int> scoreKeyValues,
    List<int> levelIndexValues,
    List<String> typeValues,
  ) {
    final len = scoreKeyValues.length;
    assert(
      levelIndexValues.length == len && typeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([scoreKeyValues[i], levelIndexValues[i], typeValues[i]]);
    }

    return deleteAllByIndexSync(r'scoreKey_levelIndex_type', values);
  }

  Future<Id> putByScoreKeyLevelIndexType(DivingFishScore object) {
    return putByIndex(r'scoreKey_levelIndex_type', object);
  }

  Id putByScoreKeyLevelIndexTypeSync(
    DivingFishScore object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(
      r'scoreKey_levelIndex_type',
      object,
      saveLinks: saveLinks,
    );
  }

  Future<List<Id>> putAllByScoreKeyLevelIndexType(
    List<DivingFishScore> objects,
  ) {
    return putAllByIndex(r'scoreKey_levelIndex_type', objects);
  }

  List<Id> putAllByScoreKeyLevelIndexTypeSync(
    List<DivingFishScore> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'scoreKey_levelIndex_type',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension DivingFishScoreQueryWhereSort
    on QueryBuilder<DivingFishScore, DivingFishScore, QWhere> {
  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DivingFishScoreQueryWhere
    on QueryBuilder<DivingFishScore, DivingFishScore, QWhereClause> {
  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
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

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause> idBetween(
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

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyEqualToAnyLevelIndexType(int scoreKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'scoreKey_levelIndex_type',
          value: [scoreKey],
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyNotEqualToAnyLevelIndexType(int scoreKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [],
                upper: [scoreKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [],
                upper: [scoreKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyGreaterThanAnyLevelIndexType(int scoreKey, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [scoreKey],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyLessThanAnyLevelIndexType(int scoreKey, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [],
          upper: [scoreKey],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyBetweenAnyLevelIndexType(
    int lowerScoreKey,
    int upperScoreKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [lowerScoreKey],
          includeLower: includeLower,
          upper: [upperScoreKey],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyLevelIndexEqualToAnyType(int scoreKey, int levelIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'scoreKey_levelIndex_type',
          value: [scoreKey, levelIndex],
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyEqualToLevelIndexNotEqualToAnyType(int scoreKey, int levelIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey],
                upper: [scoreKey, levelIndex],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex],
                includeLower: false,
                upper: [scoreKey],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex],
                includeLower: false,
                upper: [scoreKey],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey],
                upper: [scoreKey, levelIndex],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyEqualToLevelIndexGreaterThanAnyType(
    int scoreKey,
    int levelIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [scoreKey, levelIndex],
          includeLower: include,
          upper: [scoreKey],
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyEqualToLevelIndexLessThanAnyType(
    int scoreKey,
    int levelIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [scoreKey],
          upper: [scoreKey, levelIndex],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyEqualToLevelIndexBetweenAnyType(
    int scoreKey,
    int lowerLevelIndex,
    int upperLevelIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'scoreKey_levelIndex_type',
          lower: [scoreKey, lowerLevelIndex],
          includeLower: includeLower,
          upper: [scoreKey, upperLevelIndex],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyLevelIndexTypeEqualTo(int scoreKey, int levelIndex, String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'scoreKey_levelIndex_type',
          value: [scoreKey, levelIndex, type],
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterWhereClause>
  scoreKeyLevelIndexEqualToTypeNotEqualTo(
    int scoreKey,
    int levelIndex,
    String type,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex],
                upper: [scoreKey, levelIndex, type],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex, type],
                includeLower: false,
                upper: [scoreKey, levelIndex],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex, type],
                includeLower: false,
                upper: [scoreKey, levelIndex],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scoreKey_levelIndex_type',
                lower: [scoreKey, levelIndex],
                upper: [scoreKey, levelIndex, type],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DivingFishScoreQueryFilter
    on QueryBuilder<DivingFishScore, DivingFishScore, QFilterCondition> {
  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  achievementsEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'achievements',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  achievementsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'achievements',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  achievementsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'achievements',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  achievementsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'achievements',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dsEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ds',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ds',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ds',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dxScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dxScore', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dxScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dxScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dxScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dxScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  dxScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dxScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fc',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fc',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fc', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fcIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fc', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fs',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fs', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  fsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fs', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
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

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
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

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
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

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'level',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'level',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'levelIndex', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'levelIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'levelIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'levelIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'levelLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'levelLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'levelLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'levelLabel', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  levelLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'levelLabel', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  raEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ra', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  raGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ra',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  raLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ra',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  raBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ra',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rate', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  rateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rate', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  scoreKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scoreKey', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  scoreKeyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scoreKey',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  scoreKeyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scoreKey',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  scoreKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scoreKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  songIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'songId', value: value),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  songIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'songId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  songIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'songId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  songIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'songId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }
}

extension DivingFishScoreQueryObject
    on QueryBuilder<DivingFishScore, DivingFishScore, QFilterCondition> {}

extension DivingFishScoreQueryLinks
    on QueryBuilder<DivingFishScore, DivingFishScore, QFilterCondition> {}

extension DivingFishScoreQuerySortBy
    on QueryBuilder<DivingFishScore, DivingFishScore, QSortBy> {
  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievements', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievements', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByDs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ds', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByDsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ds', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByDxScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dxScore', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByDxScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dxScore', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByFc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fc', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByFcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fc', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByFs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fs', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByFsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fs', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByLevelIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelIndex', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByLevelIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelIndex', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByLevelLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelLabel', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByLevelLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelLabel', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByRa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ra', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByRaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ra', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByScoreKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreKey', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByScoreKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreKey', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DivingFishScoreQuerySortThenBy
    on QueryBuilder<DivingFishScore, DivingFishScore, QSortThenBy> {
  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievements', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievements', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByDs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ds', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByDsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ds', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByDxScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dxScore', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByDxScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dxScore', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByFc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fc', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByFcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fc', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByFs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fs', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByFsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fs', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByLevelIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelIndex', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByLevelIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelIndex', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByLevelLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelLabel', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByLevelLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelLabel', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByRa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ra', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByRaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ra', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByScoreKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreKey', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByScoreKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreKey', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DivingFishScoreQueryWhereDistinct
    on QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> {
  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct>
  distinctByAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievements');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByDs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ds');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct>
  distinctByDxScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dxScore');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByFc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fc', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByFs({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByLevel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct>
  distinctByLevelIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'levelIndex');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct>
  distinctByLevelLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'levelLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByRa() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ra');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByRate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct>
  distinctByScoreKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreKey');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songId');
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishScore, DivingFishScore, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension DivingFishScoreQueryProperty
    on QueryBuilder<DivingFishScore, DivingFishScore, QQueryProperty> {
  QueryBuilder<DivingFishScore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DivingFishScore, double, QQueryOperations>
  achievementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievements');
    });
  }

  QueryBuilder<DivingFishScore, double, QQueryOperations> dsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ds');
    });
  }

  QueryBuilder<DivingFishScore, int, QQueryOperations> dxScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dxScore');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> fcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fc');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> fsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fs');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<DivingFishScore, int, QQueryOperations> levelIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'levelIndex');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> levelLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'levelLabel');
    });
  }

  QueryBuilder<DivingFishScore, int, QQueryOperations> raProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ra');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> rateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rate');
    });
  }

  QueryBuilder<DivingFishScore, int, QQueryOperations> scoreKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreKey');
    });
  }

  QueryBuilder<DivingFishScore, int, QQueryOperations> songIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songId');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<DivingFishScore, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDivingFishPlayerDataCollection on Isar {
  IsarCollection<DivingFishPlayerData> get divingFishPlayerDatas =>
      this.collection();
}

const DivingFishPlayerDataSchema = CollectionSchema(
  name: r'DivingFishPlayerData',
  id: -8559577910336201042,
  properties: {
    r'additionalRating': PropertySchema(
      id: 0,
      name: r'additionalRating',
      type: IsarType.long,
    ),
    r'lastUpdated': PropertySchema(
      id: 1,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'nickname': PropertySchema(
      id: 2,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'plate': PropertySchema(id: 3, name: r'plate', type: IsarType.string),
    r'rating': PropertySchema(id: 4, name: r'rating', type: IsarType.long),
    r'username': PropertySchema(
      id: 5,
      name: r'username',
      type: IsarType.string,
    ),
  },

  estimateSize: _divingFishPlayerDataEstimateSize,
  serialize: _divingFishPlayerDataSerialize,
  deserialize: _divingFishPlayerDataDeserialize,
  deserializeProp: _divingFishPlayerDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'username': IndexSchema(
      id: -2899563114555695793,
      name: r'username',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'username',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _divingFishPlayerDataGetId,
  getLinks: _divingFishPlayerDataGetLinks,
  attach: _divingFishPlayerDataAttach,
  version: '3.3.0',
);

int _divingFishPlayerDataEstimateSize(
  DivingFishPlayerData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nickname.length * 3;
  bytesCount += 3 + object.plate.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _divingFishPlayerDataSerialize(
  DivingFishPlayerData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.additionalRating);
  writer.writeDateTime(offsets[1], object.lastUpdated);
  writer.writeString(offsets[2], object.nickname);
  writer.writeString(offsets[3], object.plate);
  writer.writeLong(offsets[4], object.rating);
  writer.writeString(offsets[5], object.username);
}

DivingFishPlayerData _divingFishPlayerDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DivingFishPlayerData(
    additionalRating: reader.readLongOrNull(offsets[0]) ?? 0,
    id: id,
    lastUpdated: reader.readDateTimeOrNull(offsets[1]),
    nickname: reader.readStringOrNull(offsets[2]) ?? '',
    plate: reader.readStringOrNull(offsets[3]) ?? '',
    rating: reader.readLongOrNull(offsets[4]) ?? 0,
    username: reader.readStringOrNull(offsets[5]) ?? '',
  );
  return object;
}

P _divingFishPlayerDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _divingFishPlayerDataGetId(DivingFishPlayerData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _divingFishPlayerDataGetLinks(
  DivingFishPlayerData object,
) {
  return [];
}

void _divingFishPlayerDataAttach(
  IsarCollection<dynamic> col,
  Id id,
  DivingFishPlayerData object,
) {
  object.id = id;
}

extension DivingFishPlayerDataByIndex on IsarCollection<DivingFishPlayerData> {
  Future<DivingFishPlayerData?> getByUsername(String username) {
    return getByIndex(r'username', [username]);
  }

  DivingFishPlayerData? getByUsernameSync(String username) {
    return getByIndexSync(r'username', [username]);
  }

  Future<bool> deleteByUsername(String username) {
    return deleteByIndex(r'username', [username]);
  }

  bool deleteByUsernameSync(String username) {
    return deleteByIndexSync(r'username', [username]);
  }

  Future<List<DivingFishPlayerData?>> getAllByUsername(
    List<String> usernameValues,
  ) {
    final values = usernameValues.map((e) => [e]).toList();
    return getAllByIndex(r'username', values);
  }

  List<DivingFishPlayerData?> getAllByUsernameSync(
    List<String> usernameValues,
  ) {
    final values = usernameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'username', values);
  }

  Future<int> deleteAllByUsername(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'username', values);
  }

  int deleteAllByUsernameSync(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'username', values);
  }

  Future<Id> putByUsername(DivingFishPlayerData object) {
    return putByIndex(r'username', object);
  }

  Id putByUsernameSync(DivingFishPlayerData object, {bool saveLinks = true}) {
    return putByIndexSync(r'username', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUsername(List<DivingFishPlayerData> objects) {
    return putAllByIndex(r'username', objects);
  }

  List<Id> putAllByUsernameSync(
    List<DivingFishPlayerData> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'username', objects, saveLinks: saveLinks);
  }
}

extension DivingFishPlayerDataQueryWhereSort
    on QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QWhere> {
  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DivingFishPlayerDataQueryWhere
    on QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QWhereClause> {
  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
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

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  usernameEqualTo(String username) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'username', value: [username]),
      );
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterWhereClause>
  usernameNotEqualTo(String username) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [],
                upper: [username],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [username],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [username],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [],
                upper: [username],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DivingFishPlayerDataQueryFilter
    on
        QueryBuilder<
          DivingFishPlayerData,
          DivingFishPlayerData,
          QFilterCondition
        > {
  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  additionalRatingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'additionalRating', value: value),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  additionalRatingGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'additionalRating',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  additionalRatingLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'additionalRating',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  additionalRatingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'additionalRating',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUpdated', value: value),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  lastUpdatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUpdated',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nickname',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nickname',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'plate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'plate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plate', value: ''),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  plateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'plate', value: ''),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  ratingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rating', value: value),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  ratingGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rating',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  ratingLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rating',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  ratingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rating',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'username',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'username',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'username', value: ''),
      );
    });
  }

  QueryBuilder<
    DivingFishPlayerData,
    DivingFishPlayerData,
    QAfterFilterCondition
  >
  usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'username', value: ''),
      );
    });
  }
}

extension DivingFishPlayerDataQueryObject
    on
        QueryBuilder<
          DivingFishPlayerData,
          DivingFishPlayerData,
          QFilterCondition
        > {}

extension DivingFishPlayerDataQueryLinks
    on
        QueryBuilder<
          DivingFishPlayerData,
          DivingFishPlayerData,
          QFilterCondition
        > {}

extension DivingFishPlayerDataQuerySortBy
    on QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QSortBy> {
  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByAdditionalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalRating', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByAdditionalRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalRating', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension DivingFishPlayerDataQuerySortThenBy
    on QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QSortThenBy> {
  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByAdditionalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalRating', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByAdditionalRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalRating', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QAfterSortBy>
  thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension DivingFishPlayerDataQueryWhereDistinct
    on QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct> {
  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByAdditionalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'additionalRating');
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByNickname({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByPlate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<DivingFishPlayerData, DivingFishPlayerData, QDistinct>
  distinctByUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension DivingFishPlayerDataQueryProperty
    on
        QueryBuilder<
          DivingFishPlayerData,
          DivingFishPlayerData,
          QQueryProperty
        > {
  QueryBuilder<DivingFishPlayerData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DivingFishPlayerData, int, QQueryOperations>
  additionalRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'additionalRating');
    });
  }

  QueryBuilder<DivingFishPlayerData, DateTime?, QQueryOperations>
  lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<DivingFishPlayerData, String, QQueryOperations>
  nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<DivingFishPlayerData, String, QQueryOperations> plateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plate');
    });
  }

  QueryBuilder<DivingFishPlayerData, int, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<DivingFishPlayerData, String, QQueryOperations>
  usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
