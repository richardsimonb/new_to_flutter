import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/manga.dart';

final List<Manga> _manga = [];

Future<List<Manga>> fetchManga(http.Client client, {int offset = 0}) async {
  final response = await client
      .get(Uri.https('api.mangadex.org','/manga',{'limit':'10','offset':'$offset'}));
  final jsonData = jsonDecode(response.body);
  final parsed = jsonData['data'].cast<Map<String, dynamic>>();
//  _manga.addAll(parsed.map<Manga>((json) => Manga.fromJson(json)).toList());

//  return _manga;
  return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
}

Future<List<Manga>> addMangaList(http.Client client,List<Manga> mangaList,{int offset = 0}) async {
  final manga = await fetchManga(client,offset: offset);
  mangaList.addAll(manga);
  return mangaList;
}