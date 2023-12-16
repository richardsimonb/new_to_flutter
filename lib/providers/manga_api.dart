import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/manga.dart';
import 'manga_list.dart';

class MangadexList extends MangaList {
  final List<Manga> _mangas;

  MangadexList._(this._mangas);

  static Future<MangadexList> create() async {
    final List<Manga> mangaList = await _fetchMangas();
    return MangadexList._(mangaList);
  }

  static Future<List<Manga>> _fetchMangas({int offset = 0}) async {
    final http.Client client = http.Client();
    final response = await client.get(Uri.https(
        'api.mangadex.org', '/manga', {'limit': '10', 'offset': '$offset'}));
    final jsonData = jsonDecode(response.body);
    final parsed = jsonData['data'].cast<Map<String, dynamic>>();
    client.close();
    return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
  }

  @override
  Future<void> addMangas({int offset = 0}) async {
    _mangas.addAll(await _fetchMangas(offset: offset));
  }

  @override
  List<Manga> get mangasList => _mangas;
}
