// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPhigrosSongCollection on Isar {
  IsarCollection<PhigrosSong> get phigrosSongs => this.collection();
}

const PhigrosSongSchema = CollectionSchema(
  name: r'PhigrosSong',
  id: 1471599697308266898,
  properties: {
    r'bpm': PropertySchema(id: 0, name: r'bpm', type: IsarType.string),
    r'chapter': PropertySchema(id: 1, name: r'chapter', type: IsarType.string),
    r'chartDesignerAT': PropertySchema(
      id: 2,
      name: r'chartDesignerAT',
      type: IsarType.string,
    ),
    r'chartDesignerEZ': PropertySchema(
      id: 3,
      name: r'chartDesignerEZ',
      type: IsarType.string,
    ),
    r'chartDesignerHD': PropertySchema(
      id: 4,
      name: r'chartDesignerHD',
      type: IsarType.string,
    ),
    r'chartDesignerIN': PropertySchema(
      id: 5,
      name: r'chartDesignerIN',
      type: IsarType.string,
    ),
    r'collection': PropertySchema(
      id: 6,
      name: r'collection',
      type: IsarType.string,
    ),
    r'composer': PropertySchema(
      id: 7,
      name: r'composer',
      type: IsarType.string,
    ),
    r'difficultyAT': PropertySchema(
      id: 8,
      name: r'difficultyAT',
      type: IsarType.double,
    ),
    r'difficultyEZ': PropertySchema(
      id: 9,
      name: r'difficultyEZ',
      type: IsarType.double,
    ),
    r'difficultyHD': PropertySchema(
      id: 10,
      name: r'difficultyHD',
      type: IsarType.double,
    ),
    r'difficultyIN': PropertySchema(
      id: 11,
      name: r'difficultyIN',
      type: IsarType.double,
    ),
    r'hasAT': PropertySchema(id: 12, name: r'hasAT', type: IsarType.bool),
    r'illustrationBlurUrl': PropertySchema(
      id: 13,
      name: r'illustrationBlurUrl',
      type: IsarType.string,
    ),
    r'illustrationLowResUrl': PropertySchema(
      id: 14,
      name: r'illustrationLowResUrl',
      type: IsarType.string,
    ),
    r'illustrationUrl': PropertySchema(
      id: 15,
      name: r'illustrationUrl',
      type: IsarType.string,
    ),
    r'illustrator': PropertySchema(
      id: 16,
      name: r'illustrator',
      type: IsarType.string,
    ),
    r'length': PropertySchema(id: 17, name: r'length', type: IsarType.string),
    r'name': PropertySchema(id: 18, name: r'name', type: IsarType.string),
    r'previewEndTime': PropertySchema(
      id: 19,
      name: r'previewEndTime',
      type: IsarType.double,
    ),
    r'previewTime': PropertySchema(
      id: 20,
      name: r'previewTime',
      type: IsarType.double,
    ),
    r'songId': PropertySchema(id: 21, name: r'songId', type: IsarType.string),
    r'songKey': PropertySchema(id: 22, name: r'songKey', type: IsarType.string),
  },

  estimateSize: _phigrosSongEstimateSize,
  serialize: _phigrosSongSerialize,
  deserialize: _phigrosSongDeserialize,
  deserializeProp: _phigrosSongDeserializeProp,
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
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _phigrosSongGetId,
  getLinks: _phigrosSongGetLinks,
  attach: _phigrosSongAttach,
  version: '3.3.0',
);

int _phigrosSongEstimateSize(
  PhigrosSong object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bpm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chapter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chartDesignerAT;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chartDesignerEZ;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chartDesignerHD;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chartDesignerIN;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.collection;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.composer.length * 3;
  bytesCount += 3 + object.illustrationBlurUrl.length * 3;
  bytesCount += 3 + object.illustrationLowResUrl.length * 3;
  bytesCount += 3 + object.illustrationUrl.length * 3;
  {
    final value = object.illustrator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.length;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.songId.length * 3;
  {
    final value = object.songKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _phigrosSongSerialize(
  PhigrosSong object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bpm);
  writer.writeString(offsets[1], object.chapter);
  writer.writeString(offsets[2], object.chartDesignerAT);
  writer.writeString(offsets[3], object.chartDesignerEZ);
  writer.writeString(offsets[4], object.chartDesignerHD);
  writer.writeString(offsets[5], object.chartDesignerIN);
  writer.writeString(offsets[6], object.collection);
  writer.writeString(offsets[7], object.composer);
  writer.writeDouble(offsets[8], object.difficultyAT);
  writer.writeDouble(offsets[9], object.difficultyEZ);
  writer.writeDouble(offsets[10], object.difficultyHD);
  writer.writeDouble(offsets[11], object.difficultyIN);
  writer.writeBool(offsets[12], object.hasAT);
  writer.writeString(offsets[13], object.illustrationBlurUrl);
  writer.writeString(offsets[14], object.illustrationLowResUrl);
  writer.writeString(offsets[15], object.illustrationUrl);
  writer.writeString(offsets[16], object.illustrator);
  writer.writeString(offsets[17], object.length);
  writer.writeString(offsets[18], object.name);
  writer.writeDouble(offsets[19], object.previewEndTime);
  writer.writeDouble(offsets[20], object.previewTime);
  writer.writeString(offsets[21], object.songId);
  writer.writeString(offsets[22], object.songKey);
}

PhigrosSong _phigrosSongDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PhigrosSong();
  object.bpm = reader.readStringOrNull(offsets[0]);
  object.chapter = reader.readStringOrNull(offsets[1]);
  object.chartDesignerAT = reader.readStringOrNull(offsets[2]);
  object.chartDesignerEZ = reader.readStringOrNull(offsets[3]);
  object.chartDesignerHD = reader.readStringOrNull(offsets[4]);
  object.chartDesignerIN = reader.readStringOrNull(offsets[5]);
  object.collection = reader.readStringOrNull(offsets[6]);
  object.composer = reader.readString(offsets[7]);
  object.difficultyAT = reader.readDoubleOrNull(offsets[8]);
  object.difficultyEZ = reader.readDoubleOrNull(offsets[9]);
  object.difficultyHD = reader.readDoubleOrNull(offsets[10]);
  object.difficultyIN = reader.readDoubleOrNull(offsets[11]);
  object.id = id;
  object.illustrator = reader.readStringOrNull(offsets[16]);
  object.length = reader.readStringOrNull(offsets[17]);
  object.name = reader.readString(offsets[18]);
  object.previewEndTime = reader.readDoubleOrNull(offsets[19]);
  object.previewTime = reader.readDoubleOrNull(offsets[20]);
  object.songId = reader.readString(offsets[21]);
  object.songKey = reader.readStringOrNull(offsets[22]);
  return object;
}

P _phigrosSongDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    case 20:
      return (reader.readDoubleOrNull(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _phigrosSongGetId(PhigrosSong object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _phigrosSongGetLinks(PhigrosSong object) {
  return [];
}

void _phigrosSongAttach(
  IsarCollection<dynamic> col,
  Id id,
  PhigrosSong object,
) {
  object.id = id;
}

extension PhigrosSongByIndex on IsarCollection<PhigrosSong> {
  Future<PhigrosSong?> getBySongId(String songId) {
    return getByIndex(r'songId', [songId]);
  }

  PhigrosSong? getBySongIdSync(String songId) {
    return getByIndexSync(r'songId', [songId]);
  }

  Future<bool> deleteBySongId(String songId) {
    return deleteByIndex(r'songId', [songId]);
  }

  bool deleteBySongIdSync(String songId) {
    return deleteByIndexSync(r'songId', [songId]);
  }

  Future<List<PhigrosSong?>> getAllBySongId(List<String> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'songId', values);
  }

  List<PhigrosSong?> getAllBySongIdSync(List<String> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'songId', values);
  }

  Future<int> deleteAllBySongId(List<String> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'songId', values);
  }

  int deleteAllBySongIdSync(List<String> songIdValues) {
    final values = songIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'songId', values);
  }

  Future<Id> putBySongId(PhigrosSong object) {
    return putByIndex(r'songId', object);
  }

  Id putBySongIdSync(PhigrosSong object, {bool saveLinks = true}) {
    return putByIndexSync(r'songId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySongId(List<PhigrosSong> objects) {
    return putAllByIndex(r'songId', objects);
  }

  List<Id> putAllBySongIdSync(
    List<PhigrosSong> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'songId', objects, saveLinks: saveLinks);
  }
}

extension PhigrosSongQueryWhereSort
    on QueryBuilder<PhigrosSong, PhigrosSong, QWhere> {
  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PhigrosSongQueryWhere
    on QueryBuilder<PhigrosSong, PhigrosSong, QWhereClause> {
  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> idBetween(
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

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> songIdEqualTo(
    String songId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'songId', value: [songId]),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterWhereClause> songIdNotEqualTo(
    String songId,
  ) {
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
}

extension PhigrosSongQueryFilter
    on QueryBuilder<PhigrosSong, PhigrosSong, QFilterCondition> {
  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bpm'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bpm'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bpm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bpm',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bpm',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> bpmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bpm', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  bpmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bpm', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapter'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapter'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chapter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> chapterMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chapter',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapter', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chapterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chapter', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chartDesignerAT'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chartDesignerAT'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chartDesignerAT',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chartDesignerAT',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chartDesignerAT',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chartDesignerAT', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerATIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chartDesignerAT', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chartDesignerEZ'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chartDesignerEZ'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chartDesignerEZ',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chartDesignerEZ',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chartDesignerEZ',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chartDesignerEZ', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerEZIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chartDesignerEZ', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chartDesignerHD'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chartDesignerHD'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chartDesignerHD',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chartDesignerHD',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chartDesignerHD',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chartDesignerHD', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerHDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chartDesignerHD', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chartDesignerIN'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chartDesignerIN'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chartDesignerIN',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chartDesignerIN',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chartDesignerIN',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chartDesignerIN', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  chartDesignerINIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chartDesignerIN', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'collection'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'collection'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'collection',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'collection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'collection',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'collection', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  collectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'collection', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> composerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> composerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'composer',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'composer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> composerMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'composer',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'composer', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  composerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'composer', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'difficultyAT'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'difficultyAT'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyAT',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyAT',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyAT',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyATBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyAT',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'difficultyEZ'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'difficultyEZ'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyEZ',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyEZ',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyEZ',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyEZBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyEZ',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'difficultyHD'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'difficultyHD'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyHD',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyHD',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyHD',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyHDBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyHD',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'difficultyIN'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'difficultyIN'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyIN',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyIN',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyIN',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  difficultyINBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyIN',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> hasATEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasAT', value: value),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'illustrationBlurUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'illustrationBlurUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'illustrationBlurUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'illustrationBlurUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationBlurUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'illustrationBlurUrl',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'illustrationLowResUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'illustrationLowResUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'illustrationLowResUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'illustrationLowResUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationLowResUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'illustrationLowResUrl',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'illustrationUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'illustrationUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'illustrationUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'illustrationUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustrationUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'illustrationUrl', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'illustrator'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'illustrator'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'illustrator',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'illustrator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'illustrator',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'illustrator', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  illustratorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'illustrator', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'length'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  lengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'length'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  lengthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'length',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  lengthStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'length',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> lengthMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'length',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  lengthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'length', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  lengthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'length', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'previewEndTime'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'previewEndTime'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'previewEndTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'previewEndTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'previewEndTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewEndTimeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'previewEndTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'previewTime'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'previewTime'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'previewTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'previewTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'previewTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  previewTimeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'previewTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'songId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'songId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'songId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'songId', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'songId', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'songKey'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'songKey'),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'songKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'songKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition> songKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'songKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'songKey', value: ''),
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterFilterCondition>
  songKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'songKey', value: ''),
      );
    });
  }
}

extension PhigrosSongQueryObject
    on QueryBuilder<PhigrosSong, PhigrosSong, QFilterCondition> {}

extension PhigrosSongQueryLinks
    on QueryBuilder<PhigrosSong, PhigrosSong, QFilterCondition> {}

extension PhigrosSongQuerySortBy
    on QueryBuilder<PhigrosSong, PhigrosSong, QSortBy> {
  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByBpm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bpm', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByBpmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bpm', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChartDesignerAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByChartDesignerATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChartDesignerEZ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerEZ', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByChartDesignerEZDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerEZ', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChartDesignerHD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerHD', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByChartDesignerHDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerHD', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByChartDesignerIN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerIN', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByChartDesignerINDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerIN', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collection', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collection', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByComposer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByComposerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByDifficultyAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByDifficultyATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByDifficultyEZ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyEZ', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByDifficultyEZDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyEZ', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByDifficultyHD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyHD', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByDifficultyHDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyHD', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByDifficultyIN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyIN', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByDifficultyINDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyIN', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByHasAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByHasATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByIllustrationBlurUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationBlurUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByIllustrationBlurUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationBlurUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByIllustrationLowResUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationLowResUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByIllustrationLowResUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationLowResUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByIllustrationUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByIllustrationUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByIllustrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrator', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByIllustratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrator', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'length', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'length', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByPreviewEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewEndTime', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  sortByPreviewEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewEndTime', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByPreviewTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewTime', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortByPreviewTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewTime', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortBySongKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songKey', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> sortBySongKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songKey', Sort.desc);
    });
  }
}

extension PhigrosSongQuerySortThenBy
    on QueryBuilder<PhigrosSong, PhigrosSong, QSortThenBy> {
  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByBpm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bpm', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByBpmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bpm', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChartDesignerAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByChartDesignerATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChartDesignerEZ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerEZ', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByChartDesignerEZDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerEZ', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChartDesignerHD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerHD', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByChartDesignerHDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerHD', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByChartDesignerIN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerIN', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByChartDesignerINDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartDesignerIN', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collection', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collection', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByComposer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByComposerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByDifficultyAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByDifficultyATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByDifficultyEZ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyEZ', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByDifficultyEZDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyEZ', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByDifficultyHD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyHD', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByDifficultyHDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyHD', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByDifficultyIN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyIN', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByDifficultyINDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyIN', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByHasAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAT', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByHasATDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAT', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByIllustrationBlurUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationBlurUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByIllustrationBlurUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationBlurUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByIllustrationLowResUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationLowResUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByIllustrationLowResUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationLowResUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByIllustrationUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationUrl', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByIllustrationUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrationUrl', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByIllustrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrator', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByIllustratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'illustrator', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'length', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'length', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByPreviewEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewEndTime', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy>
  thenByPreviewEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewEndTime', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByPreviewTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewTime', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenByPreviewTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewTime', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenBySongId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenBySongIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songId', Sort.desc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenBySongKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songKey', Sort.asc);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QAfterSortBy> thenBySongKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songKey', Sort.desc);
    });
  }
}

extension PhigrosSongQueryWhereDistinct
    on QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> {
  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByBpm({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bpm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByChapter({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByChartDesignerAT({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'chartDesignerAT',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByChartDesignerEZ({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'chartDesignerEZ',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByChartDesignerHD({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'chartDesignerHD',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByChartDesignerIN({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'chartDesignerIN',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByCollection({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collection', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByComposer({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'composer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByDifficultyAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficultyAT');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByDifficultyEZ() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficultyEZ');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByDifficultyHD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficultyHD');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByDifficultyIN() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficultyIN');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByHasAT() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasAT');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct>
  distinctByIllustrationBlurUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'illustrationBlurUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct>
  distinctByIllustrationLowResUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'illustrationLowResUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByIllustrationUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'illustrationUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByIllustrator({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'illustrator', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByLength({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'length', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByPreviewEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewEndTime');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctByPreviewTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewTime');
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctBySongId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhigrosSong, PhigrosSong, QDistinct> distinctBySongKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songKey', caseSensitive: caseSensitive);
    });
  }
}

extension PhigrosSongQueryProperty
    on QueryBuilder<PhigrosSong, PhigrosSong, QQueryProperty> {
  QueryBuilder<PhigrosSong, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> bpmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bpm');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations>
  chartDesignerATProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chartDesignerAT');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations>
  chartDesignerEZProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chartDesignerEZ');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations>
  chartDesignerHDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chartDesignerHD');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations>
  chartDesignerINProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chartDesignerIN');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> collectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collection');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations> composerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'composer');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations> difficultyATProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyAT');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations> difficultyEZProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyEZ');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations> difficultyHDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyHD');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations> difficultyINProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyIN');
    });
  }

  QueryBuilder<PhigrosSong, bool, QQueryOperations> hasATProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasAT');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations>
  illustrationBlurUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'illustrationBlurUrl');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations>
  illustrationLowResUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'illustrationLowResUrl');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations>
  illustrationUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'illustrationUrl');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> illustratorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'illustrator');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> lengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'length');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations>
  previewEndTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewEndTime');
    });
  }

  QueryBuilder<PhigrosSong, double?, QQueryOperations> previewTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewTime');
    });
  }

  QueryBuilder<PhigrosSong, String, QQueryOperations> songIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songId');
    });
  }

  QueryBuilder<PhigrosSong, String?, QQueryOperations> songKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songKey');
    });
  }
}
