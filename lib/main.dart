import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/manga/presentation/manga_home.dart';

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