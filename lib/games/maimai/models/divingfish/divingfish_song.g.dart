// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divingfish_song.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDivingFishSongCollection on Isar {
  IsarCollection<DivingFishSong> get divingFishSongs => this.collection();
}

const DivingFishSongSchema = CollectionSchema(
  name: r'DivingFishSong',
  id: -9159479378649112619,
  properties: {
    r'basicInfo': PropertySchema(
      id: 0,
      name: r'basicInfo',
      type: IsarType.object,

      target: r'DivingFishBasicInfo',
    ),
    r'charts': PropertySchema(
      id: 1,
      name: r'charts',
      type: IsarType.objectList,

      target: r'DivingFishChartInfo',
    ),
    r'cids': PropertySchema(id: 2, name: r'cids', type: IsarType.longList),
    r'ds': PropertySchema(id: 3, name: r'ds', type: IsarType.doubleList),
    r'level': PropertySchema(id: 4, name: r'level', type: IsarType.stringList),
    r'songId': PropertySchema(id: 5, name: r'songId', type: IsarType.long),
    r'title': PropertySchema(id: 6, name: r'title', type: IsarType.string),
    r'type': PropertySchema(id: 7, name: r'type', type: IsarType.string),
  },

  estimateSize: _divingFishSongEstimateSize,
  serialize: _divingFishSongSerialize,
  deserialize: _divingFishSongDeserialize,
  deserializeProp: _divingFishSongDeserializeProp,
  idName: r'id',
  indexes: {
    r'songId': IndexSchema(
      id: -4588889454650216128,
      name: r'songId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'songId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.value,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'DivingFishChartInfo': DivingFishChartInfoSchema,
    r'DivingFishBasicInfo': DivingFishBasicInfoSchema,
  },

  getId: _divingFishSongGetId,
  getLinks: _divingFishSongGetLinks,
  attach: _divingFishSongAttach,
  version: '3.3.0',
);

int _divingFishSongEstimateSize(
  DivingFishSong object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.basicInfo;
    if (value != null) {
      bytesCount +=
          3 +
          DivingFishBasicInfoSchema.estimateSize(
            value,
            allOffsets[DivingFishBasicInfo]!,
            allOffsets,
          );
    }
  }
  bytesCount += 3 + object.charts.length * 3;
  {
    final offsets = allOffsets[DivingFishChartInfo]!;
    for (var i = 0; i < object.charts.length; i++) {
      final value = object.charts[i];
      bytesCount += DivingFishChartInfoSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.cids.length * 8;
  bytesCount += 3 + object.ds.length * 8;
  bytesCount += 3 + object.level.length * 3;
  {
    for (var i = 0; i < object.level.length; i++) {
      final value = object.level[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _divingFishSongSerialize(
  DivingFishSong object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<DivingFishBasicInfo>(
    offsets[0],
    allOffsets,
    DivingFishBasicInfoSchema.serialize,
    object.basicInfo,
  );
  writer.writeObjectList<DivingFishChartInfo>(
    offsets[1],
    allOffsets,
    DivingFishChartInfoSchema.serialize,
    object.charts,
  );
  writer.writeLongList(offsets[2], object.cids);
  writer.writeDoubleList(offsets[3], object.ds);
  writer.writeStringList(offsets[4], object.level);
  writer.writeLong(offsets[5], object.songId);
  writer.writeString(offsets[6], object.title);
  writer.writeString(offsets[7], object.type);
}

DivingFishSong _divingFishSongDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DivingFishSong(
    basicInfo: reader.readObjectOrNull<DivingFishBasicInfo>(
      offsets[0],
      DivingFishBasicInfoSchema.deserialize,
      allOffsets,
    ),
    charts:
        reader.readObjectList<DivingFishChartInfo>(
          offsets[1],
          DivingFishChartInfoSchema.deserialize,
          allOffsets,
          DivingFishChartInfo(),
        ) ??
        const [],
    cids: reader.readLongList(offsets[2]) ?? const [],
    ds: reader.readDoubleList(offsets[3]) ?? const [],
    id: id,
    level: reader.readStringList(offsets[4]) ?? const [],
    songId: reader.readLongOrNull(offsets[5]) ?? 0,
    title: reader.readStringOrNull(offsets[6]) ?? '',
    type: reader.readStringOrNull(offsets[7]) ?? '',
  );
  return object;
}

P _divingFishSongDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<DivingFishBasicInfo>(
            offset,
            DivingFishBasicInfoSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 1:
      return (reader.readObjectList<DivingFishChartInfo>(
                offset,
                DivingFishChartInfoSchema.deserialize,
                allOffsets,
                DivingFishChartInfo(),
              ) ??
              const [])
          as P;
    case 2:
      return (reader.readLongList(offset) ?? const []) as P;
    case 3:
      return (reader.readDoubleList(offset) ?? const []) as P;
    case 4:
      return (reader.readStringList(offset) ?? const []) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _divingFishSongGetId(DivingFishSong object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _divingFishSongGetLinks(DivingFishSong object) {
  return [];
}

void _divingFishSongAttach(
  IsarCollection<dynamic> col,
  Id id,
  DivingFishSong object,
) {
  object.id = id;
}

extension DivingFishSongByIndex on IsarCollection<DivingFishSong> {
  Future<DivingFishSong?> getBySongId(int songId) {
    return getByIndex(r'songId', [songId]);
  }

  DivingFishSong? getBySongIdSync(int songId) {
    return getByIndexSync(r'songId', [songId]);
  }

  Future<bool> deleteBySongId(int songId) {
    return deleteByIndex(r'songId', [songId]);
  }

  bool deleteBySongIdSync(int songId) {
    return deleteByIndexSync(r'songId', [songId]);
  }

  Future<List<DivingFishSong?>> getAllBySongId(List<int> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'songId', values);
  }

  List<DivingFishSong?> getAllBySongIdSync(List<int> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'songId', values);
  }

  Future<int> deleteAllBySongId(List<int> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'songId', values);
  }

  int deleteAllBySongIdSync(List<int> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'songId', values);
  }

  Future<Id> putBySongId(DivingFishSong object) {
    return putByIndex(r'songId', object);
  }

  Id putBySongIdSync(DivingFishSong object, {bool saveLinks = true}) {
    return putByIndexSync(r'songId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySongId(List<DivingFishSong> objects) {
    return putAllByIndex(r'songId', objects);
  }

  List<Id> putAllBySongIdSync(
    List<DivingFishSong> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'songId', objects, saveLinks: saveLinks);
  }
}

extension DivingFishSongQueryWhereSort
    on QueryBuilder<DivingFishSong, DivingFishSong, QWhere> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhere> anySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'songId'),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhere> anyTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'title'),
      );
    });
  }
}

extension DivingFishSongQueryWhere
    on QueryBuilder<DivingFishSong, DivingFishSong, QWhereClause> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> idBetween(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> songIdEqualTo(
    int songId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'songId', value: [songId]),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  songIdNotEqualTo(int songId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'songId',
                lower: [],
                upper: [songId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'songId',
                lower: [songId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'songId',
                lower: [songId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'songId',
                lower: [],
                upper: [songId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  songIdGreaterThan(int songId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'songId',
          lower: [songId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  songIdLessThan(int songId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'songId',
          lower: [],
          upper: [songId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> songIdBetween(
    int lowerSongId,
    int upperSongId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'songId',
          lower: [lowerSongId],
          includeLower: includeLower,
          upper: [upperSongId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> titleEqualTo(
    String title,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'title', value: [title]),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  titleGreaterThan(String title, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'title',
          lower: [title],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> titleLessThan(
    String title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'title',
          lower: [],
          upper: [title],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause> titleBetween(
    String lowerTitle,
    String upperTitle, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'title',
          lower: [lowerTitle],
          includeLower: includeLower,
          upper: [upperTitle],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  titleStartsWith(String TitlePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'title',
          lower: [TitlePrefix],
          upper: ['$TitlePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'title', value: ['']),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterWhereClause>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'title', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'title', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'title', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'title', upper: ['']),
            );
      }
    });
  }
}

extension DivingFishSongQueryFilter
    on QueryBuilder<DivingFishSong, DivingFishSong, QFilterCondition> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  basicInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'basicInfo'),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  basicInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'basicInfo'),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'charts', length, true, length, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'charts', 0, true, 0, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'charts', 0, false, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'charts', 0, true, length, include);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'charts', length, include, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'charts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cids', value: value),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cids',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cids',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cids',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cids', length, true, length, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cids', 0, true, 0, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cids', 0, false, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cids', 0, true, length, include);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cids', length, include, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  cidsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cids',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsElementEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsElementGreaterThan(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsElementLessThan(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsElementBetween(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', length, true, length, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', 0, true, 0, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', 0, false, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', 0, true, length, include);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', length, include, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  dsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ds', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementGreaterThan(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementLessThan(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementBetween(
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'level', length, true, length, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'level', 0, true, 0, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'level', 0, false, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'level', 0, true, length, include);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'level', length, include, 999999, true);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  levelLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'level',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  songIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'songId', value: value),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
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

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }
}

extension DivingFishSongQueryObject
    on QueryBuilder<DivingFishSong, DivingFishSong, QFilterCondition> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition> basicInfo(
    FilterQuery<DivingFishBasicInfo> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'basicInfo');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterFilterCondition>
  chartsElement(FilterQuery<DivingFishChartInfo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'charts');
    });
  }
}

extension DivingFishSongQueryLinks
    on QueryBuilder<DivingFishSong, DivingFishSong, QFilterCondition> {}

extension DivingFishSongQuerySortBy
    on QueryBuilder<DivingFishSong, DivingFishSong, QSortBy> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> sortBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy>
  sortBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DivingFishSongQuerySortThenBy
    on QueryBuilder<DivingFishSong, DivingFishSong, QSortThenBy> {
  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy>
  thenBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DivingFishSongQueryWhereDistinct
    on QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> {
  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctByCids() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cids');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctByDs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ds');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songId');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DivingFishSong, DivingFishSong, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension DivingFishSongQueryProperty
    on QueryBuilder<DivingFishSong, DivingFishSong, QQueryProperty> {
  QueryBuilder<DivingFishSong, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DivingFishSong, DivingFishBasicInfo?, QQueryOperations>
  basicInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'basicInfo');
    });
  }

  QueryBuilder<DivingFishSong, List<DivingFishChartInfo>, QQueryOperations>
  chartsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'charts');
    });
  }

  QueryBuilder<DivingFishSong, List<int>, QQueryOperations> cidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cids');
    });
  }

  QueryBuilder<DivingFishSong, List<double>, QQueryOperations> dsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ds');
    });
  }

  QueryBuilder<DivingFishSong, List<String>, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<DivingFishSong, int, QQueryOperations> songIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songId');
    });
  }

  QueryBuilder<DivingFishSong, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<DivingFishSong, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DivingFishChartInfoSchema = Schema(
  name: r'DivingFishChartInfo',
  id: 3042421506160871144,
  properties: {
    r'charter': PropertySchema(id: 0, name: r'charter', type: IsarType.string),
    r'notes': PropertySchema(id: 1, name: r'notes', type: IsarType.longList),
  },

  estimateSize: _divingFishChartInfoEstimateSize,
  serialize: _divingFishChartInfoSerialize,
  deserialize: _divingFishChartInfoDeserialize,
  deserializeProp: _divingFishChartInfoDeserializeProp,
);

int _divingFishChartInfoEstimateSize(
  DivingFishChartInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.charter.length * 3;
  bytesCount += 3 + object.notes.length * 8;
  return bytesCount;
}

void _divingFishChartInfoSerialize(
  DivingFishChartInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.charter);
  writer.writeLongList(offsets[1], object.notes);
}

DivingFishChartInfo _divingFishChartInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DivingFishChartInfo(
    charter: reader.readStringOrNull(offsets[0]) ?? '',
    notes: reader.readLongList(offsets[1]) ?? const [],
  );
  return object;
}

P _divingFishChartInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongList(offset) ?? const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DivingFishChartInfoQueryFilter
    on
        QueryBuilder<
          DivingFishChartInfo,
          DivingFishChartInfo,
          QFilterCondition
        > {
  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'charter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'charter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'charter',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'charter', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  charterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'charter', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: value),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'notes', length, true, length, true);
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'notes', 0, true, 0, true);
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'notes', 0, false, 999999, true);
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'notes', 0, true, length, include);
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'notes', length, include, 999999, true);
    });
  }

  QueryBuilder<DivingFishChartInfo, DivingFishChartInfo, QAfterFilterCondition>
  notesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DivingFishChartInfoQueryObject
    on
        QueryBuilder<
          DivingFishChartInfo,
          DivingFishChartInfo,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DivingFishBasicInfoSchema = Schema(
  name: r'DivingFishBasicInfo',
  id: -7603378405107073286,
  properties: {
    r'artist': PropertySchema(id: 0, name: r'artist', type: IsarType.string),
    r'bpm': PropertySchema(id: 1, name: r'bpm', type: IsarType.long),
    r'from': PropertySchema(id: 2, name: r'from', type: IsarType.string),
    r'genre': PropertySchema(id: 3, name: r'genre', type: IsarType.string),
    r'isNew': PropertySchema(id: 4, name: r'isNew', type: IsarType.bool),
    r'releaseDate': PropertySchema(
      id: 5,
      name: r'releaseDate',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 6, name: r'title', type: IsarType.string),
  },

  estimateSize: _divingFishBasicInfoEstimateSize,
  serialize: _divingFishBasicInfoSerialize,
  deserialize: _divingFishBasicInfoDeserialize,
  deserializeProp: _divingFishBasicInfoDeserializeProp,
);

int _divingFishBasicInfoEstimateSize(
  DivingFishBasicInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.artist.length * 3;
  bytesCount += 3 + object.from.length * 3;
  bytesCount += 3 + object.genre.length * 3;
  bytesCount += 3 + object.releaseDate.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _divingFishBasicInfoSerialize(
  DivingFishBasicInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.artist);
  writer.writeLong(offsets[1], object.bpm);
  writer.writeString(offsets[2], object.from);
  writer.writeString(offsets[3], object.genre);
  writer.writeBool(offsets[4], object.isNew);
  writer.writeString(offsets[5], object.releaseDate);
  writer.writeString(offsets[6], object.title);
}

DivingFishBasicInfo _divingFishBasicInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DivingFishBasicInfo(
    artist: reader.readStringOrNull(offsets[0]) ?? '',
    bpm: reader.readLongOrNull(offsets[1]) ?? 0,
    from: reader.readStringOrNull(offsets[2]) ?? '',
    genre: reader.readStringOrNull(offsets[3]) ?? '',
    isNew: reader.readBoolOrNull(offsets[4]) ?? false,
    releaseDate: reader.readStringOrNull(offsets[5]) ?? '',
    title: reader.readStringOrNull(offsets[6]) ?? '',
  );
  return object;
}

P _divingFishBasicInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DivingFishBasicInfoQueryFilter
    on
        QueryBuilder<
          DivingFishBasicInfo,
          DivingFishBasicInfo,
          QFilterCondition
        > {
  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'artist',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'artist',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'artist', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  artistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'artist', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  bpmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bpm', value: value),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  bpmGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bpm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  bpmLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bpm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  bpmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bpm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'from',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'from',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'from',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'from', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  fromIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'from', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genre',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'genre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'genre',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genre', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  genreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genre', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  isNewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isNew', value: value),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'releaseDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'releaseDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  releaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
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

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<DivingFishBasicInfo, DivingFishBasicInfo, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }
}

extension DivingFishBasicInfoQueryObject
    on
        QueryBuilder<
          DivingFishBasicInfo,
          DivingFishBasicInfo,
          QFilterCondition
        > {}
