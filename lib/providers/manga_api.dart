import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/manga.dart';
import 'manga_provider.dart';

class MangadexProvider extends MangaProvider {

  final String _url = 'api.mangadex.org';
  final http.Client _client = http.Client();

  @override
  Future<List<Manga>> fetchAll({int offset = 0}) async {
    final response = await _client.get(Uri.https(
        _url, '/manga', {'limit': '10', 'offset': '$offset'}));
    final jsonData = jsonDecode(response.body);
    final parsed = jsonData['data'].cast<Map<String, dynamic>>();
    _client.close();
    return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
  }
}
