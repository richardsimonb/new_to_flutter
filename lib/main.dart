import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_to_flutter/providers/manga_api.dart';
import 'package:new_to_flutter/providers/provider.dart';
import 'dart:async';

import 'models/manga.dart';
import 'repository/manga_repository.dart';

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  return MangaRepository(mangaProvider: MangadexProvider());
});

void main() => runApp(const ProviderScope(child: MyApp()) );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Riverpod Mangadex';

    return const MaterialApp(
      title: appTitle,
      home: MangaHome(title: appTitle),
    );
  }
}

class MangaHome extends ConsumerWidget {
  const MangaHome({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int counter = 10;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(listMangaProvider.future),
        child: const MangaList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          ref.read(listMangaProvider.notifier).getMoreManga(offset: counter);
          counter+= 10;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

class MangaList extends ConsumerWidget{
  const MangaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final AsyncValue<List<Manga>> mangaTitle = ref.watch(listMangaProvider);

    if(mangaTitle.hasValue) {
      return ListView.builder(
        itemCount: mangaTitle.value!.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          return ListTile(
            title: Text(
              mangaTitle.value![index].attributes.title.values.first,
            ),
          );
        },
      );
    } else if(mangaTitle.isLoading) {
      return  const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return  const Center(
        child: Text("error"),
      );
    }

  }
}