import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/manga.dart';
import '../data/manga_repository.dart';

class MangaTitle extends ConsumerStatefulWidget {
  const MangaTitle({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MangaTitleState();
}

class _MangaTitleState extends ConsumerState<MangaTitle> {
  List<Manga> _mangaTitle = [];
  late final Future<List<Manga>> _futureManga = ref.read(mangaRepositoryProvider).getMultiple();
  int offset = 0;
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  _MangaTitleState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          offset += 10;
          _futureManga.then((value) async => value.addAll(await ref.read(mangaRepositoryProvider).getMultiple(offset: offset)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Manga>>(
      future: _futureManga,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          _mangaTitle = snapshot.data!;
          //put infinite list here
          return ListView.builder(
            itemCount: _mangaTitle.length * 2,
            controller: _controller,
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return const Divider(); /*2*/
              final index = i ~/ 2; /*3*/
              return ListTile(
                title: Text(
                  _mangaTitle[index].id,
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