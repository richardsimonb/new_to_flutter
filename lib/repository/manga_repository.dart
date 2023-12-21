import '../models/manga.dart';
import '../providers/manga_provider.dart';

class MangaRepository {
  final MangaProvider _mangaProvider;

  MangaRepository(this._mangaProvider);

  Future<List<Manga>> getMultiple({int offset = 0}) async {
    return await _mangaProvider.fetchAll(offset: offset);
  }
}