import 'dart:async';
import '../models/manga.dart';

abstract class MangaList {
  Future<void> addMangas({int offset = 0});

  List<Manga> get mangasList;
}
