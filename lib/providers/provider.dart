import 'dart:async';
import 'package:new_to_flutter/providers/manga_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/manga.dart';
import '../repository/manga_repository.dart';

part 'provider.g.dart';

@riverpod
MangaRepository mangaRepository(MangaRepositoryRef ref) => MangaRepository(mangaProvider: MangadexProvider());

@riverpod
class ListManga extends _$ListManga {
  @override
  FutureOr<List<Manga>> build() async {
    return ref.read(mangaRepositoryProvider).getMultiple();
  }

  Future<void> getMoreManga({int offset = 0}) async{
    final previousState = await future;
    final newMangas = await ref.read(mangaRepositoryProvider).getMultiple(offset: offset);
    state = AsyncData(previousState + newMangas);
  }

}