import 'dart:async';
import '../models/manga.dart';

abstract class MangaProvider {
  Future<List<Manga>> fetchAll({int offset = 0});
}
