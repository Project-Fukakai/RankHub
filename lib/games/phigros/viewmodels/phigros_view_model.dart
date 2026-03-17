import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/phigros/phigros_resources.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';
import 'package:rank_hub/models/phigros/song.dart';

class PhigrosState {
  final List<PhigrosSong> songs;
  final List<PhigrosSong> filteredSongs;
  final bool isLoadingSongs;
  final List<PhigrosGameRecord> records;
  final List<PhigrosGameRecord> filteredRecords;
  final bool isLoadingRecords;
  final PhigrosPlayerSummary? playerSummary;
  final String searchKeyword;
  final String? selectedDifficulty;
  final String? selectedChapter;
  final String recordSearchKeyword;
  final String? recordDifficultyFilter;

  const PhigrosState({
    this.songs = const [],
    this.filteredSongs = const [],
    this.isLoadingSongs = false,
    this.records = const [],
    this.filteredRecords = const [],
    this.isLoadingRecords = false,
    this.playerSummary,
    this.searchKeyword = '',
    this.selectedDifficulty,
    this.selectedChapter,
    this.recordSearchKeyword = '',
    this.recordDifficultyFilter,
  });

  PhigrosState copyWith({
    List<PhigrosSong>? songs,
    List<PhigrosSong>? filteredSongs,
    bool? isLoadingSongs,
    List<PhigrosGameRecord>? records,
    List<PhigrosGameRecord>? filteredRecords,
    bool? isLoadingRecords,
    PhigrosPlayerSummary? playerSummary,
    String? searchKeyword,
    String? selectedDifficulty,
    String? selectedChapter,
    String? recordSearchKeyword,
    String? recordDifficultyFilter,
  }) {
    return PhigrosState(
      songs: songs ?? this.songs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
      isLoadingSongs: isLoadingSongs ?? this.isLoadingSongs,
      records: records ?? this.records,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      isLoadingRecords: isLoadingRecords ?? this.isLoadingRecords,
      playerSummary: playerSummary ?? this.playerSummary,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedChapter: selectedChapter ?? this.selectedChapter,
      recordSearchKeyword: recordSearchKeyword ?? this.recordSearchKeyword,
      recordDifficultyFilter:
          recordDifficultyFilter ?? this.recordDifficultyFilter,
    );
  }
}

class PhigrosViewModel extends Notifier<PhigrosState> {
  static const String allChaptersKey = '__ALL__';

  @override
  PhigrosState build() {
    return const PhigrosState(selectedChapter: allChaptersKey);
  }

  Future<void> loadSongs({bool forceRefresh = false}) async {
    state = state.copyWith(isLoadingSongs: true);
    try {
      if (forceRefresh) {
        await ref
            .read(
              refreshResourceProviderOf<List<PhigrosSong>>(
                phigrosSongListResourceKey,
              ).future,
            )
            .catchError((_) {});
      }

      final songList = await ref
          .read(
            resourceProviderOf<List<PhigrosSong>>(
              phigrosSongListResourceKey,
            ).future,
          )
          .timeout(const Duration(seconds: 25));
      state = state.copyWith(songs: songList);
      _filterSongs();
      CoreLogService.i('Phigros: 加载曲库 ${songList.length} 首');
    } on TimeoutException {
      CoreLogService.w('Phigros: 加载曲库超时');
    } catch (e) {
      CoreLogService.w('Phigros: 加载曲库失败: $e');
    } finally {
      state = state.copyWith(isLoadingSongs: false);
    }
  }

  Future<void> loadRecords({bool forceRefresh = false}) async {
    state = state.copyWith(isLoadingRecords: true);
    try {
      if (forceRefresh) {
        await ref
            .read(
              refreshResourceProviderOf<List<PhigrosGameRecord>>(
                phigrosRecordListResourceKey,
              ).future,
            )
            .catchError((_) {});
      }

      final recordList = await ref
          .read(
            resourceProviderOf<List<PhigrosGameRecord>>(
              phigrosRecordListResourceKey,
            ).future,
          )
          .timeout(const Duration(seconds: 25));

      PhigrosPlayerSummary? summary;
      try {
        summary = await ref
            .read(
              resourceProviderOf<PhigrosPlayerSummary>(
                phigrosPlayerSummaryResourceKey,
              ).future,
            )
            .timeout(const Duration(seconds: 25));
      } catch (_) {}

      state = state.copyWith(records: recordList, playerSummary: summary);
      _filterRecords();
      CoreLogService.i('Phigros: 加载成绩 ${recordList.length} 条');
    } on TimeoutException {
      CoreLogService.w('Phigros: 加载成绩超时');
    } catch (e) {
      CoreLogService.w('Phigros: 加载成绩失败: $e');
    } finally {
      state = state.copyWith(isLoadingRecords: false);
    }
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
    _filterSongs();
  }

  void setDifficultyFilter(String? difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
    _filterSongs();
  }

  void setChapterFilter(String? chapter) {
    final normalized = (chapter == null || chapter.trim().isEmpty)
        ? allChaptersKey
        : chapter;
    state = state.copyWith(selectedChapter: normalized);
    _filterSongs();
  }

  List<String> getChapterOptions() {
    final chapters = <String>{};
    for (final song in state.songs) {
      final chapter = song.chapter?.trim() ?? '';
      if (chapter.isEmpty || chapter == '--') continue;
      chapters.add(chapter);
    }
    final sorted = chapters.toList()..sort();
    return sorted;
  }

  void setRecordSearchKeyword(String keyword) {
    state = state.copyWith(recordSearchKeyword: keyword);
    _filterRecords();
  }

  void setRecordDifficultyFilter(String? difficulty) {
    state = state.copyWith(recordDifficultyFilter: difficulty);
    _filterRecords();
  }

  Map<String, int> getSongStats() {
    return {
      'total': state.songs.length,
      'ez': state.songs
          .where((s) => s.difficultyEZ != null && s.difficultyEZ! > 0)
          .length,
      'hd': state.songs
          .where((s) => s.difficultyHD != null && s.difficultyHD! > 0)
          .length,
      'in': state.songs
          .where((s) => s.difficultyIN != null && s.difficultyIN! > 0)
          .length,
      'at': state.songs
          .where((s) => s.difficultyAT != null && s.difficultyAT! > 0)
          .length,
    };
  }

  Map<String, List<PhigrosGameRecord>> getB30Records() {
    final sortedRecords = state.records.toList()
      ..sort((a, b) => b.rks.compareTo(a.rks));

    final phiRecords = sortedRecords
        .where((record) => record.rating == 'ϕ')
        .take(3)
        .toList();

    final bestRecords = sortedRecords.take(27).toList();

    return {'phi': phiRecords, 'best': bestRecords};
  }

  double calculatePersonalRks() {
    final b30 = getB30Records();
    final phi = b30['phi'] ?? [];
    final best = b30['best'] ?? [];

    if (phi.isEmpty && best.isEmpty) return 0.0;

    final phiSum = phi.fold<double>(0.0, (sum, r) => sum + r.rks);
    final bestSum = best.fold<double>(0.0, (sum, r) => sum + r.rks);

    return (phiSum + bestSum) / 30;
  }

  double? calculateRequiredAccForRksIncrease(
    PhigrosGameRecord currentRecord,
    bool isInB30,
  ) {
    if (currentRecord.acc >= 100.0) return null;

    final currentPersonalRks = calculatePersonalRks();
    double calculateTargetRks(double currentRks) {
      final expanded = (currentRks * 1000).floor();
      final root = (currentRks * 10).floor() * 100;
      final third = expanded % 10;
      final second = (expanded / 10).toInt() % 10;
      return (third >= 5
              ? root + (second + 1) * 10 + 5
              : root + second * 10 + 5) /
          1000;
    }

    final targetPersonalRks = calculateTargetRks(currentPersonalRks);

    final b30 = getB30Records();
    final phi = b30['phi'] ?? [];
    final best = b30['best'] ?? [];

    final maxRks = currentRecord.constant;

    if (!isInB30) {
      if (phi.length < 3 || (phi.isNotEmpty && maxRks > phi.last.rks)) {
        return 100.0;
      }
      return null;
    }

    final allB30 = [...phi, ...best];
    final otherRksSum = allB30
        .where((r) => r.id != currentRecord.id)
        .fold<double>(0.0, (sum, r) => sum + r.rks);

    final requiredRksA = targetPersonalRks * 30 - otherRksSum;

    double? accA;
    if (requiredRksA > 0 && currentRecord.constant > 0) {
      final calculatedAcc =
          sqrt(requiredRksA / currentRecord.constant) * 45 + 55;
      if (calculatedAcc <= 100 && calculatedAcc > currentRecord.acc) {
        accA = calculatedAcc;
      }
    }

    if (accA != null) return accA;

    if (maxRks < (phi.isNotEmpty ? phi.last.rks : 0.0)) {
      return null;
    }

    double? accB;
    final maxRecord = PhigrosGameRecord()
      ..id = currentRecord.id
      ..accountId = currentRecord.accountId
      ..songId = currentRecord.songId
      ..songName = currentRecord.songName
      ..artist = currentRecord.artist
      ..level = currentRecord.level
      ..constant = currentRecord.constant
      ..score = 1000000
      ..acc = 100.0
      ..rks = maxRks
      ..fc = true
      ..lastUpdated = DateTime.now();

    final newPhi = [...phi, maxRecord]..sort((a, b) => b.rks.compareTo(a.rks));
    final newPhiTop = newPhi.take(3).toList();

    final newBest =
        allB30.map((r) => r.id == currentRecord.id ? maxRecord : r).toList()
          ..sort((a, b) => b.rks.compareTo(a.rks));
    final newBest27 = newBest.take(27).toList();

    final newPhiSum = newPhiTop.fold<double>(0.0, (sum, r) => sum + r.rks);
    final newBestAvg = newBest27.fold<double>(0.0, (sum, r) => sum + r.rks);
    final newPersonalRks = (newPhiSum + newBestAvg) / 30;

    if (newPersonalRks >= targetPersonalRks) {
      accB = 100.0;
    }

    return accB;
  }

  void _filterSongs() {
    var filtered = state.songs.toList();

    if (state.searchKeyword.isNotEmpty) {
      final keyword = state.searchKeyword.toLowerCase();
      filtered = filtered.where((song) {
        return song.name.toLowerCase().contains(keyword) ||
            song.composer.toLowerCase().contains(keyword) ||
            (song.illustrator?.toLowerCase().contains(keyword) ?? false);
      }).toList();
    }

    if (state.selectedDifficulty != null) {
      final difficulty = state.selectedDifficulty!;
      filtered = filtered.where((song) {
        switch (difficulty) {
          case 'EZ':
            return song.difficultyEZ != null && song.difficultyEZ! > 0;
          case 'HD':
            return song.difficultyHD != null && song.difficultyHD! > 0;
          case 'IN':
            return song.difficultyIN != null && song.difficultyIN! > 0;
          case 'AT':
            return song.difficultyAT != null && song.difficultyAT! > 0;
          default:
            return true;
        }
      }).toList();
    }

    final selectedChapter = state.selectedChapter;
    if (selectedChapter != null &&
        selectedChapter.isNotEmpty &&
        selectedChapter != allChaptersKey) {
      filtered = filtered
          .where((song) => song.chapter == selectedChapter)
          .toList();
    }

    state = state.copyWith(filteredSongs: filtered);
  }

  void _filterRecords() {
    var filtered = state.records.toList();

    if (state.recordSearchKeyword.isNotEmpty) {
      final keyword = state.recordSearchKeyword.toLowerCase();
      filtered = filtered.where((record) {
        return record.songName.toLowerCase().contains(keyword) ||
            record.artist.toLowerCase().contains(keyword);
      }).toList();
    }

    if (state.recordDifficultyFilter != null) {
      filtered = filtered
          .where((record) => record.level == state.recordDifficultyFilter)
          .toList();
    }

    state = state.copyWith(filteredRecords: filtered);
  }
}

final phigrosViewModelProvider =
    NotifierProvider<PhigrosViewModel, PhigrosState>(PhigrosViewModel.new);

String extractPhigrosAccountIdentifier(Account account) {
  return account.externalId ?? account.username ?? account.platformId;
}
