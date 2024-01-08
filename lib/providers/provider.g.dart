// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mangaRepositoryHash() => r'5878a12b934e678ae3cd18460dd70143e921d772';

/// See also [mangaRepository].
@ProviderFor(mangaRepository)
final mangaRepositoryProvider = AutoDisposeProvider<MangaRepository>.internal(
  mangaRepository,
  name: r'mangaRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mangaRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MangaRepositoryRef = AutoDisposeProviderRef<MangaRepository>;
String _$listMangaHash() => r'52aea80250829a63a2b8202bf5d56ece989dafcb';

/// See also [ListManga].
@ProviderFor(ListManga)
final listMangaProvider =
    AutoDisposeAsyncNotifierProvider<ListManga, List<Manga>>.internal(
  ListManga.new,
  name: r'listMangaProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listMangaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ListManga = AutoDisposeAsyncNotifier<List<Manga>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
