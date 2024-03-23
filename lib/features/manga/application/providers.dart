import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/manga.dart';
import '../data/manga_repository.dart';

part 'providers.g.dart';

@riverpod
class ListManga extends _$ListManga {
  @override
  FutureOr<List<Manga>> build() async {
    return ref.read(mangaRepositoryProvider).getMultiple();
  }

  Future<void> getMoreManga({int offset = 0}) async {
    final previousState = await future;
    final newMangas =
        await ref.read(mangaRepositoryProvider).getMultiple(offset: offset);
    state = AsyncData(previousState + newMangas);
  }
}
