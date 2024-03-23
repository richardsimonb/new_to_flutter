import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/manga.dart';

part 'manga_repository.g.dart';

abstract class MangaAPI {
  Future<List<Manga>> fetchAll({int offset = 0});
}

class MangadexAPI extends MangaAPI {
  final String _url = 'api.mangadex.org';
  final http.Client _client = http.Client();

  @override
  Future<List<Manga>> fetchAll({int offset = 0}) async {
    final response = await _client
        .get(Uri.https(_url, '/manga', {'limit': '10', 'offset': '$offset'}));
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final parsed = (jsonData['data'] as List).cast<Map<String, dynamic>>();
    _client.close();
    return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
  }
}

class MangaRepository{
  final MangaAPI mangaAPI;

  MangaRepository({required this.mangaAPI});

  Future<List<Manga>> getMultiple({int offset = 0}) async {
    return await mangaAPI.fetchAll(offset: offset);
  }
}

@riverpod
MangaRepository mangaRepository(MangaRepositoryRef ref) =>
    MangaRepository(mangaAPI: MangadexAPI());