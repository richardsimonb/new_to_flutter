import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'manga.freezed.dart';
part 'manga.g.dart';

@freezed
class Manga with _$Manga {
  const factory Manga({
    required String id,
    required Attributes attributes,
  }) = _Manga;

  factory Manga.fromJson(Map<String, dynamic> json)
    => _$MangaFromJson(json);
}

@freezed
class Attributes with _$Attributes{
  const factory Attributes({
    required Map<String, dynamic> title
  }) = _Attributes;

  factory Attributes.fromJson(Map<String, dynamic> json)
    => _$AttributesFromJson(json);
}