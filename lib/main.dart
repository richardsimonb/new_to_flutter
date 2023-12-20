import 'package:flutter/material.dart';
import 'dart:async';

import 'models/manga.dart';
import 'providers/manga_api.dart';
import 'providers/manga_list.dart';

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
  List<Manga> _mangaTitle = [];
  late final Future<MangaList> _futureManga = MangadexList.create();
  int offset = 0;
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  _MangaTitleState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          offset += 10;
          _futureManga.then((item) => item.addMangas(offset: offset));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MangaList>(
      future: _futureManga,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          _mangaTitle = snapshot.data!.mangasList;
          //put infinite list here
          return ListView.builder(
            itemCount: _mangaTitle.length * 2,
            controller: _controller,
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return const Divider(); /*2*/
              final index = i ~/ 2; /*3*/
              return ListTile(
                title: Text(
                  _mangaTitle[index].title,
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
