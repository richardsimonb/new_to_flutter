import 'dart:async';
import 'package:new_to_flutter/providers/manga_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/manga.dart';
import '../repository/manga_repository.dart';

part 'notifier.g.dart';

final mangaRepository = MangaRepository(mangaProvider: MangadexProvider());

@riverpod
class ListManga extends _$ListManga {
  @override
  Future<List<Manga>> build() async {
    return mangaRepository.getMultiple();
  }
}