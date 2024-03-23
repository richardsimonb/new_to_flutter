import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_to_flutter/features/manga/application/providers.dart';

import '../domain/manga.dart';

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
      return Center(
        child: Text(mangaTitle.error.toString()),
      );
    }

  }
}