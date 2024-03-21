import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_to_flutter/providers/manga_api.dart';

import 'repository/manga_repository.dart';
import 'widgets/manga_home.dart';

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