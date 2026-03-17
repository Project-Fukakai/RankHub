// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_score.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNetScoreCollection on Isar {
  IsarCollection<NetScore> get netScores => this.collection();
}

const NetScoreSchema = CollectionSchema(
  name: r'NetScore',
  id: 6367976256504869304,
  properties: {
    r'achievement': PropertySchema(
      id: 0,
      name: r'achievement',
      type: IsarType.long,
    ),
    r'comboStatus': PropertySchema(
      id: 1,
      name: r'comboStatus',
      type: IsarType.long,
    ),
    r'deluxscoreMax': PropertySchema(
      id: 2,
      name: r'deluxscoreMax',
      type: IsarType.long,
    ),
    r'extNum1': PropertySchema(id: 3, name: r'extNum1', type: IsarType.long),
    r'extNum2': PropertySchema(id: 4, name: r'extNum2', type: IsarType.long),
    r'level': PropertySchema(id: 5, name: r'level', type: IsarType.long),
    r'musicId': PropertySchema(id: 6, name: r'musicId', type: IsarType.long),
    r'playCount': PropertySchema(
      id: 7,
      name: r'playCount',
      type: IsarType.long,
    ),
    r'scoreRank': PropertySchema(
      id: 8,
      name: r'scoreRank',
      type: IsarType.long,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.long,
    ),
  },

  estimateSize: _netScoreEstimateSize,
  serialize: _netScoreSerialize,
  deserialize: _netScoreDeserialize,
  deserializeProp: _netScoreDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _netScoreGetId,
  getLinks: _netScoreGetLinks,
  attach: _netScoreAttach,
  version: '3.3.0',
);

int _netScoreEstimateSize(
  NetScore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _netScoreSerialize(
  NetScore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.achievement);
  writer.writeLong(offsets[1], object.comboStatus);
  writer.writeLong(offsets[2], object.deluxscoreMax);
  writer.writeLong(offsets[3], object.extNum1);
  writer.writeLong(offsets[4], object.extNum2);
  writer.writeLong(offsets[5], object.level);
  writer.writeLong(offsets[6], object.musicId);
  writer.writeLong(offsets[7], object.playCount);
  writer.writeLong(offsets[8], object.scoreRank);
  writer.writeLong(offsets[9], object.syncStatus);
}

NetScore _netScoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NetScore(
    achievement: reader.readLongOrNull(offsets[0]) ?? 0,
    comboStatus: reader.readLongOrNull(offsets[1]) ?? 0,
    deluxscoreMax: reader.readLongOrNull(offsets[2]) ?? 0,
    extNum1: reader.readLongOrNull(offsets[3]) ?? 0,
    extNum2: reader.readLongOrNull(offsets[4]) ?? 0,
    id: id,
    level: reader.readLongOrNull(offsets[5]) ?? 0,
    musicId: reader.readLongOrNull(offsets[6]) ?? 0,
    playCount: reader.readLongOrNull(offsets[7]) ?? 0,
    scoreRank: reader.readLongOrNull(offsets[8]) ?? 0,
    syncStatus: reader.readLongOrNull(offsets[9]) ?? 0,
  );
  return object;
}

P _netScoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _netScoreGetId(NetScore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _netScoreGetLinks(NetScore object) {
  return [];
}

void _netScoreAttach(IsarCollection<dynamic> col, Id id, NetScore object) {
  object.id = id;
}

extension NetScoreQueryWhereSort on QueryBuilder<NetScore, NetScore, QWhere> {
  QueryBuilder<NetScore, NetScore, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NetScoreQueryWhere on QueryBuilder<NetScore, NetScore, QWhereClause> {
  QueryBuilder<NetScore, NetScore, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NetScore, NetScore, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterWhereClause> idBetween(
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
}

extension NetScoreQueryFilter
    on QueryBuilder<NetScore, NetScore, QFilterCondition> {
  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> achievementEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'achievement', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition>
  achievementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'achievement',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> achievementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'achievement',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> achievementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'achievement',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> comboStatusEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'comboStatus', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition>
  comboStatusGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'comboStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> comboStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'comboStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> comboStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'comboStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> deluxscoreMaxEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deluxscoreMax', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition>
  deluxscoreMaxGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deluxscoreMax',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> deluxscoreMaxLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deluxscoreMax',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> deluxscoreMaxBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deluxscoreMax',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum1EqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'extNum1', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum1GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'extNum1',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum1LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'extNum1',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum1Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'extNum1',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum2EqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'extNum2', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum2GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'extNum2',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum2LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'extNum2',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> extNum2Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'extNum2',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> idBetween(
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

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> levelEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'level', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'level',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'level',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'level',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> musicIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'musicId', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> musicIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'musicId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> musicIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'musicId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> musicIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'musicId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> playCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playCount', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> playCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> playCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> playCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> scoreRankEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scoreRank', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> scoreRankGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scoreRank',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> scoreRankLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scoreRank',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> scoreRankBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scoreRank',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> syncStatusEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncStatus', value: value),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> syncStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> syncStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterFilterCondition> syncStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension NetScoreQueryObject
    on QueryBuilder<NetScore, NetScore, QFilterCondition> {}

extension NetScoreQueryLinks
    on QueryBuilder<NetScore, NetScore, QFilterCondition> {}

extension NetScoreQuerySortBy on QueryBuilder<NetScore, NetScore, QSortBy> {
  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievement', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievement', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByComboStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comboStatus', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByComboStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comboStatus', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByDeluxscoreMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deluxscoreMax', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByDeluxscoreMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deluxscoreMax', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByExtNum1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum1', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByExtNum1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum1', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByExtNum2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum2', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByExtNum2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum2', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByMusicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicId', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByMusicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicId', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByScoreRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreRank', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortByScoreRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreRank', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension NetScoreQuerySortThenBy
    on QueryBuilder<NetScore, NetScore, QSortThenBy> {
  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievement', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievement', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByComboStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comboStatus', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByComboStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comboStatus', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByDeluxscoreMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deluxscoreMax', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByDeluxscoreMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deluxscoreMax', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByExtNum1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum1', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByExtNum1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum1', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByExtNum2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum2', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByExtNum2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extNum2', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByMusicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicId', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByMusicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicId', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByScoreRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreRank', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenByScoreRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreRank', Sort.desc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<NetScore, NetScore, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension NetScoreQueryWhereDistinct
    on QueryBuilder<NetScore, NetScore, QDistinct> {
  QueryBuilder<NetScore, NetScore, QDistinct> distinctByAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievement');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByComboStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comboStatus');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByDeluxscoreMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deluxscoreMax');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByExtNum1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extNum1');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByExtNum2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extNum2');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByMusicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musicId');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctByScoreRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreRank');
    });
  }

  QueryBuilder<NetScore, NetScore, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }
}

extension NetScoreQueryProperty
    on QueryBuilder<NetScore, NetScore, QQueryProperty> {
  QueryBuilder<NetScore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> achievementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievement');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> comboStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comboStatus');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> deluxscoreMaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deluxscoreMax');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> extNum1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extNum1');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> extNum2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extNum2');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> musicIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musicId');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> scoreRankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreRank');
    });
  }

  QueryBuilder<NetScore, int, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }
}
