import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'manga.freezed.dart';
part 'manga.g.dart';

@freezed
class Manga with _$Manga {
  const factory Manga({
    required String id,
    @JsonKey(name: 'attributes')
    required MangaAttributes attributes,
  }) = _Manga;

  factory Manga.fromJson(Map<String, dynamic> json)
    => _$MangaFromJson(json);
}

@freezed
class MangaAttributes with _$MangaAttributes{
  const factory MangaAttributes({
    required Map<String, dynamic> title
  }) = _MangaAttributes;

  factory MangaAttributes.fromJson(Map<String, dynamic> json)
    => _$MangaAttributesFromJson(json);
}
