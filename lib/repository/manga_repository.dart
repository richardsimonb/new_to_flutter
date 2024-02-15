import '../models/manga.dart';
import '../providers/manga_provider.dart';

class MangaRepository{
  final MangaProvider mangaProvider;

  MangaRepository({required this.mangaProvider});

  Future<List<Manga>> getMultiple({int offset = 0}) async {
    return await mangaProvider.fetchAll(offset: offset);
  }

}