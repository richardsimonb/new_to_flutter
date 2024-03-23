import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_to_flutter/features/manga/application/providers.dart';

import 'manga_list.dart';

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