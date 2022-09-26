// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:english_words/english_words.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'models/manga.dart';


// A function that converts a response body into a List<Manga>.
List<Manga> parseManga(String responseBody) {
  final jsonData = jsonDecode(responseBody);
  final parsed = jsonData['data'].cast<Map<String, dynamic>>();

  return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
}

Future<List<Manga>> fetchManga(http.Client client, {int offset = 0}) async {
  final response = await client
      .get(Uri.https('api.mangadex.org','/manga',{'limit':'10','offset':'$offset'}));

  // Use the compute function to run parseManga in a separate isolate.
  return parseManga(response.body);
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Isolate Demo';

    return const MaterialApp(
      title: appTitle,
      home: MangaHome(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Manga>>(
        future: fetchManga(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
//            return const Center(
//              child: Text('${snapshot.error}'),
//            );
          } else if (snapshot.hasData) {
            return MangaList(manga: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MangaList extends StatelessWidget {
  const MangaList({super.key, required this.manga});

  final List<Manga> manga;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: manga.length * 2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/

          return ListTile(
            title: Text(
              manga[index].title,
            ),
          );
        },

    );
  }
}

class MangaHome extends StatelessWidget {
  const MangaHome({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const MangaTitle(),
    );
  }
}

class MangaTitle extends StatefulWidget {
  const MangaTitle({super.key});

  @override
  State<MangaTitle> createState() => _MangaTitleState();
}

class _MangaTitleState extends State<MangaTitle> {

  final List<Manga> _manga = [];
  late Future<List<Manga>> _futureManga;
  int offset = 0;
  final ScrollController _controller =
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  _MangaTitleState() {
    http.Client client = http.Client();
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          offset += 10;
          _futureManga = getManga(client,offset: offset);
          client.close();
        });
      };
    });
    _futureManga = getManga(client,offset: offset);
    client.close();
  }

  Future<List<Manga>> getManga(http.Client client, {int offset = 0}) async {
    final response = await client
        .get(Uri.https('api.mangadex.org','/manga',{'limit':'10','offset':'$offset'}));
    final jsonData = jsonDecode(response.body);
    final parsed = jsonData['data'].cast<Map<String, dynamic>>();
    _manga.addAll(parsed.map<Manga>((json) => Manga.fromJson(json)).toList());

    return _manga;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Manga>>(
      future: _futureManga, //fetchManga(http.Client(), offset: offset),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
//          return Text('${snapshot.error}');
            return Center(
              child: Text('${snapshot.error}'),
            );
        } else if (snapshot.hasData) {
          //return MangaList(manga: snapshot.data!);
          var mangaTitle = snapshot.data!;
          //put infinite list here
          return ListView.builder(
            itemCount: mangaTitle.length * 2,
            controller: _controller,
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return const Divider(); /*2*/

              final index = i ~/ 2; /*3*/

//              if (index >= mangaTitle.length) {
//                offset += 10;
//              }

              return ListTile(
                title: Text(
                  mangaTitle[index].title,
                ),
              );
            },

          );


        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

//
//void main() {
//  runApp(const MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  const MyApp({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Startup Name Generator',
//      theme: ThemeData(
//        // Add the 5 lines from here...
//        appBarTheme: const AppBarTheme(
//          backgroundColor: Colors.white,
//          foregroundColor: Colors.black,
//        ),
//      ),
//      home: RandomWords(),
//    );
//  }
//}
//
//class RandomWords extends StatefulWidget {
//  const RandomWords({super.key});
//
//  @override
//  _RandomWordsState createState() => _RandomWordsState();
//}
//
//class _RandomWordsState extends State<RandomWords> {
//  final _suggestions = <WordPair>[];
//  final _saved = <WordPair>{};
//  final _biggerFont = const TextStyle(fontSize: 18);
//
//  void _pushSaved() {
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(
//        builder: (context) {
//          final tiles = _saved.map(
//            (pair) {
//              return ListTile(
//                title: Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final divided = tiles.isNotEmpty
//              ? ListTile.divideTiles(
//                  context: context,
//                  tiles: tiles,
//                ).toList()
//              : <Widget>[];
//
//          return Scaffold(
//            appBar: AppBar(
//              title: const Text('Saved Suggestions'),
//            ),
//            body: ListView(children: divided),
//          );
//        },
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      // NEW from here ...
//      appBar: AppBar(
//        title: const Text('Startup Name Generator'),
//        actions: [
//          IconButton(
//            icon: const Icon(Icons.list),
//            onPressed: _pushSaved,
//            tooltip: 'Saved Suggestions',
//          ),
//        ],
//      ),
//      body: ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: /*1*/ (context, i) {
//          if (i.isOdd) return const Divider(); /*2*/
//
//          final index = i ~/ 2; /*3*/
//          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//          }
//
//          final alreadySaved = _saved.contains(_suggestions[index]);
//
//          return ListTile(
//            title: Text(
//              _suggestions[index].asPascalCase,
//              style: _biggerFont,
//            ),
//            trailing: Icon(
//              // NEW from here ...
//              alreadySaved ? Icons.favorite : Icons.favorite_border,
//              color: alreadySaved ? Colors.red : null,
//              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
//            ),
//            onTap: () {
//              // NEW from here ...
//              setState(() {
//                if (alreadySaved) {
//                  _saved.remove(_suggestions[index]);
//                } else {
//                  _saved.add(_suggestions[index]);
//                }
//              }); // to here.
//            },
//          );
//        },
//      ),
//    );
//  }
//}
//
